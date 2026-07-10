class MessagesController < ApplicationController
  before_action :authenticate_user!

  INSTRUCTIONS = <<~PROMPT
    # Persona
    You are GuideRails, a senior Ruby on Rails developer who teaches Rails to
    developers at every level. You are patient and precise, and you never bluff.
    You would rather look something up than guess at it.

    # Context
    You are the assistant in a chat application. The person you are talking to is
    a developer with a Rails question. They may be a complete beginner or a
    seasoned engineer, so calibrate depth to the question you are asked.

    Your answers must be grounded in the official Rails Guides rather than in
    memory. Two tools give you access to them: ListRailsGuides returns the table
    of contents, and FetchRailsGuide reads one guide given a URL from that table.

    # Task
    For every message, work through these in order:

    1. If the question is not about Ruby on Rails, decline politely, say what you
      do cover, and stop. Do not answer it, even if you know the answer.
    2. If the question is too vague to answer well, ask one clarifying question
      instead of guessing at what they meant.
    3. Otherwise, call ListRailsGuides, choose the guide that best matches the
      question, and read it with FetchRailsGuide before you answer. Do this even
      when you are confident you already know the answer.
    4. Answer from what you read. Never invent method names, configuration
      options, or API behaviour. If the guides do not cover the question, say so
      plainly and offer what related material does exist.
    5. Define technical terms and Rails-specific concepts the first time you use
      them, briefly and in plain language.

    # Format
    Reply in Markdown. Prefer short paragraphs of prose over bullet lists, and
    put code in fenced blocks tagged with its language (```ruby, ```erb, ```bash)
    so it is visually distinct from your explanation. Keep answers concise: cover
    what was asked, and stop.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @previous_messages = @chat.messages.order(:created_at).to_a
    @message = @chat.messages.build(message_params.merge(role: :user))

    if @message.save
      @user_message = @message
      @assistant_message = generate_assistant_reply(@previous_messages)
      @message = @chat.messages.build

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
                   turbo_stream.remove("optimistic-message"),
                   turbo_stream.replace("new_message_container",
                                        partial: "messages/form",
                                        locals: { chat: @chat, message: @message })
                 ],
                 status: :unprocessable_entity
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  def update
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.find(params[:id])

    if @message.update(message_params)
      preceding_messages = @chat.messages.where("id < ?", @message.id).order(:created_at).to_a
      trailing_messages = @chat.messages.where("id > ?", @message.id)
      @removed_message_ids = trailing_messages.map { |message| ActionView::RecordIdentifier.dom_id(message) }
      trailing_messages.destroy_all

      @assistant_message = generate_assistant_reply(preceding_messages)
      @new_message = @chat.messages.build

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(ActionView::RecordIdentifier.dom_id(@message),
                                                    partial: "messages/message",
                                                    locals: { message: @message, chat: @chat }),
                 status: :unprocessable_entity
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def generate_assistant_reply(previous_messages)
    ruby_llm_chat = RubyLLM.chat.with_instructions(INSTRUCTIONS).with_tools(Tools::ListRailsGuides, Tools::FetchRailsGuide)
    previous_messages.each do |message|
      ruby_llm_chat.add_message(role: message.user? ? :user : :assistant, content: message.content)
    end
    response = ruby_llm_chat.ask(@message.content)
    @chat.messages.create!(role: :ai_assistant, content: response.content)
  end

  def message_params
    params.require(:message).permit(:content)
  end
end

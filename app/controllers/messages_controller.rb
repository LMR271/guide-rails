class MessagesController < ApplicationController
  before_action :authenticate_user!

  INSTRUCTIONS = "You are GuideRails, an assistant that helps developers understand Ruby on Rails. " \
                 "Answer clearly and concisely, grounded in official Rails documentation and conventions."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @previous_messages = @chat.messages.order(:created_at).to_a
    @message = @chat.messages.build(message_params.merge(role: :user))

    if @message.save
      @ruby_llm_chat = RubyLLM.chat.with_instructions(INSTRUCTIONS).with_tools(Tools::ListRailsGuides, Tools::FetchRailsGuide)
      build_conversation_history
      response = @ruby_llm_chat.ask(@message.content)
      @assistant_message = @chat.messages.create!(role: :ai_assistant, content: response.content)
      @user_message = @message
      @message = @chat.messages.build

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_message_container",
                                                    partial: "messages/form",
                                                    locals: { chat: @chat, message: @message }),
                 status: :unprocessable_entity
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def build_conversation_history
    @previous_messages.each do |message|
      @ruby_llm_chat.add_message(role: message.user? ? :user : :assistant, content: message.content)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end

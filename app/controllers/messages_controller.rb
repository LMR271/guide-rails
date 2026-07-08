class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @user_question = params[:content]
    @ai_answer = RubyLLM.chat.ask(@user_question).content
    render "chats/show"
  end
end

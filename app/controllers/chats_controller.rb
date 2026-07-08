class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats.order(created_at: :desc)
  end

  def show
    @chat = current_user.chats.find(params[:id])
  end

  def new
    @chat = current_user.chats.build
  end

  def create
    @chat = current_user.chats.build(chat_params)
    if @chat.save
      redirect_to @chat, notice: "Chat created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @chat = current_user.chats.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Chat deleted."
  end

  private

  def chat_params
    params.require(:chat).permit(:topic)
  end
end

class ChatsController < ApplicationController
  # add once the login-feature branch is merged into master:
  # before_action :authenticate_user!

  def index
    @chats = Chat.order(created_at: :desc)
  end

  def show
    @chat = Chat.find(params[:id])
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      redirect_to @chat, notice: "Chat created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Chat deleted."
  end

  private

  def chat_params
    params.require(:chat).permit(:topic)
  end
end

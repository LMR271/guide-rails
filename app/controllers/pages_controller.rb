class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    return unless user_signed_in?

    @chats = current_user.chats.order(created_at: :desc).limit(5)
    @total_chats = current_user.chats.count
  end
end

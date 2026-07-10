class Message < ApplicationRecord
  MAX_USER_MESSAGES = 10

  belongs_to :chat
  enum :role, { user: "user", ai_assistant: "ai_assistant" } # distinguishes human vs. AI messages; stored as strings for readability and enables message.user? / message.ai_assistant?

  validates :content, :role, presence: true
  validate :user_message_limit, if: -> { user? && new_record? }

  private

  def user_message_limit
    if chat.messages.where(role: :user).count >= MAX_USER_MESSAGES
      errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat")
    end
  end
end

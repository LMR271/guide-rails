class Message < ApplicationRecord
  belongs_to :chat
  enum :role, { user: "user", ai_assistant: "ai_assistant" } # distinguishes human vs. AI messages; stored as strings for readability and enables message.user? / message.ai_assistant?

  validates :content, :role, presence: true
end

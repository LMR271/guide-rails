class Chat < ApplicationRecord
  # add once the login-feature branch is merged into master:
  # belongs_to :user
  has_many :messages, dependent: :destroy

  validates :topic, presence: true
end

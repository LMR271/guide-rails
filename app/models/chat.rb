class Chat < ApplicationRecord
  # add once the login-feature branch is merged into master:
  # belongs_to :user

  validates :topic, presence: true
end

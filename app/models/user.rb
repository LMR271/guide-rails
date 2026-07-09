class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Associations
  has_many :chats, dependent: :destroy

  # Devise stuff :)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # for Google OmniAuth
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password_confirmation,
            confirmation: { message: "Doesn't match password" },
            if: :password_required?

  def self.from_omniauth(auth)
    # Find or create a user based on the provider and uid
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20] # Generate a random password
    end
  end
end

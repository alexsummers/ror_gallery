class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :provider, :uid, :name, :captcha, :captcha_key

  apply_simple_captcha

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :category_subscriptions, dependent: :destroy
  has_many :categories, through: :category_subscriptions
  has_many :events, dependent: :destroy
  has_many :navigation_events, dependent: :destroy

  validates :name, presence: true, length: {minimum: 3, maximum: 100}

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where('provider = :provider AND uid = :uid', provider: auth.provider, uid: auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
      )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

end
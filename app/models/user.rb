class User < ApplicationRecord
  include Spotlight::User
  #if Blacklight::Utils.needs_attr_accessible?
  #  attr_accessible :email, :password, :password_confirmation
  #end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :omniauthable,
         :registerable,:recoverable, :rememberable, :trackable,
         :validatable, omniauth_providers: [:saml]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  #Only accept existing user accounts
  def self.from_omniauth(access_token)
    email = "#{access_token.uid}@uoregon.edu"
    User.where(email: email).first
  end
end

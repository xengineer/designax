# coding: utf-8

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  attr_accessible :role, :login, :user_group_id, :delflag
  # attr_accessible :title, :body
  attr_accessor :login
  belongs_to :user_group
  
  ROLES=%w[artist manager admin]

  validates_uniqueness_of :username, :message => "this username is taken"
  validate :username_is_present

  def active_for_authentication?
    super && self.account_active?
  end

  def account_active?
    if self.delflag.to_s == 'true'
      logMessage = self.class.to_s + "#" + __method__.to_s + " " + :username.to_s +
                   " DELFLAG: " + self.delflag.to_s

      logger.info logMessage
      return false
    end
    return true
  end

  def inactive_message
    "メールアドレスまたはパスワードが間違っています。"
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
  end
  ### This is the correct method you override with the code above
  ### def self.find_for_database_authentication(warden_conditions)
  ### end )

  def email_required?
    false
  end

  def username_is_present
    if self.username.blank?
      errors.add(:base, "Username must be set")
    end
  end

  def getUser
    if self.role == "artist"
      return User.find_all_by_username(self.username)
    else
      return User.all
    end
  end
  #validates :username,
  #:uniqueness => {
  #  :case_sensitive => false
  #},
  #:format => { ... } # etc.

end

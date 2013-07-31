class User < ActiveRecord::Base
  attr_accessible :email, :login
  attr_protected :hashed_password

  attr_accessor :password, :password_confirmation

  validates :login,
    :presence => true,
    :length => {:maximum => 50}
  validates :email, 
    :presence => true,
    :uniqueness => {:case_sensitive => false},
    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => false},
    :length => {:maximum => 60, :allow_nil => true}
  validates_confirmation_of :password, :allow_nil => true

  validate :validate_password_length

  before_save   :update_hashed_password

  has_many :results
  has_many :quizzes, :through => :results

  def update_hashed_password
    if self.password 
      salt_password(password)
    end
  end

  def check_password?(clear_password)
    User.hash_password("#{salt}#{User.hash_password clear_password}") == hashed_password
  end

  def salt_password(clear_password)
    self.salt = User.generate_salt
    self.hashed_password = User.hash_password("#{salt}#{User.hash_password clear_password}")
  end

  def self.try_to_login(email, password)
    email = email.to_s
    password = password.to_s

    return nil if password.empty?
    user = find_by_email(email)
    if user
      return nil if !user.active?
      return nil unless user.check_password?(password)

      user.update_attribute(:last_login, Time.now) if user && !user.new_record?
      user
    else 
      nil
    end
  rescue => text
    raise text
  end

  def self.current=(user)
    @current_user = user
  end

  def self.current
    @current_user
  end

  private

  def validate_password_length
    if !password.nil? && password.size < 6
      errors.add(:password, :too_short, :count => 6)
    end
  end

  def self.hash_password(clear_password)
    Digest::SHA1.hexdigest(clear_password || "")
  end

  def self.generate_salt
    SecureRandom.hex(16)
  end
end

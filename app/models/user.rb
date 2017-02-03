require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessible :hashed_password, :name, :salt
  attr_accessor :password_confirmation
  attr_reader :password

  validates :name, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  validate :password_must_be_present

  after_destroy :ensure_an_admin_remains
  
  class << self
    def authenticate(name, password)
      user = self.find_by_name(name)
      if user
        expected_password = encrypt_password(password, user.salt)
        if user.hashed_password != expected_password
          user = nil
        end
      end
      user
    end
    
    def encrypt_password(password, salt)
      Digest::SHA2.hexdigest(password + "wibble" + salt)
    end
  end
  
  # 'password' is a virtual attribute
  def password=(password)
    @password = password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  def ensure_an_admin_remains
    if User.count.zero?
      raise "Can't delete last user"
    end
  end
  
  private
  def password_must_be_present
    errors.add(:password, "Missing password" ) unless hashed_password.present?
  end
  
  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end

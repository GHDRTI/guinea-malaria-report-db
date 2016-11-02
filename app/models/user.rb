class User < ActiveRecord::Base

  LOGIN_KEY_LENGTH = 24
  LOGIN_KEY_EXPIRES_DAYS = 31

  def self.user_by_login_key key
    where("login_key = :key AND login_key_expires > :expires", 
      key: key, expires: DateTime.now).first
  end

  def new_login_key!
    begin 
      key = SecureRandom.hex(24)
    end while User.exists?(login_key: key)
    update!({
      login_key: key, 
      login_key_expires: DateTime.now + LOGIN_KEY_EXPIRES_DAYS.days
    })
    return login_key
  end

end

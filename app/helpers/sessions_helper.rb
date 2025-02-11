module SessionsHelper
  attr_accessor :remember_token

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !session[:logged_in].nil?
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost   
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = new_token
    session[:remember_digest] = digest(remember_token)
  end

  def log_in(options = {})
    options[:forwarding_url] ||= root_path
  end

  def log_out
    session.delete(:logged_in)
    session.delete(:remember_digest)
  end

  # Stores the URL the user is trying to access.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  def authenticate(password)
    admin_password = ENV["ADMIN_PASSWORD"]
    if admin_password.nil?
      raise RuntimeError.new("System password not set")
    end
    if password == admin_password
      session[:logged_in] = true
      remember
      return true
    else
      return false
    end
  end

  def get_sort_key
    session[:sort_key] ||= :composed_in
  end

  def get_scope
    session[:scope] ||= :recorded
  end
end

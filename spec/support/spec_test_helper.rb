module SpecTestHelper
  # Logs the administrator in through SessionsController
  def log_in_through_controller(options = {})
    options[:password] ||= 'password'
    options[:remember_me] ||= '1'
    options[:forwarding_url] ||= root_path
    post login_path,
      :params => {
        :session => { :password => options[:password],
                      :remember_me => options[:remember_me],
                      :forwarding_url => options[:forwarding_url] }
      }
  end
end


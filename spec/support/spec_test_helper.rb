module SpecTestHelper
  # Logs the administrator in through SessionsController
  def log_in_through_controller(options = {})
    options[:password] ||= 'password'
    options[:forwarding_url] ||= root_path
    post "/sessions/create",
      :params => {
        :session => { :password => options[:password],
                      :forwarding_url => options[:forwarding_url] }
      }
  end
end


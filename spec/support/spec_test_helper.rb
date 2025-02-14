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

  def define_environment
    if !ENV['APP_HOST'].nil?
      @original_app_host = ENV['APP_HOST']
    else
      ENV['APP_HOST'] = 'http://ourserver.com'
      @original_app_host = nil
    end

    if !ENV['MEDIA_HOST'].nil?
      @original_media_host = ENV['MEDIA_HOST']
    else
      ENV['MEDIA_HOST'] = 'http://ourserver.com'
      @original_media_host = nil
    end

    if !ENV['FILE_ROOT'].nil?
      @original_file_root = ENV['FILE_ROOT']
    else
      ENV['FILE_ROOT'] = 'recordings/mp3'
      @original_file_root = nil
    end
  end

  def clear_environment
    ENV['APP_HOST'] = @original_app_host
    ENV['MEDIA_HOST'] = @original_media_host
    ENV['FILE_ROOT'] = @original_file_root
  end
end


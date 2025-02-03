require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "handling unauthorized users" do
    it "redirects someone who has not yet logged in" do
      get new_genre_path
      expect(response).to have_http_status(:redirect)
      post genres_path
      expect(response).to have_http_status(:redirect)
      get new_work_path
      expect(response).to have_http_status(:redirect)
      get edit_work_path({ :id => 1 })
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      ENV["ADMIN_PASSWORD"] = nil
      expect {
        post sessions_create_path, params: {
          session: { password: "" } 
        }
      }.to raise_error(RuntimeError)
      ENV["ADMIN_PASSWORD"] = 'password'
      post sessions_create_path, params: {
        session: { password: "password",
                   forwarding_url: "/genres/edit" }
      }
      expect(response).to have_http_status(:redirect)
      expect(session[:logged_in]).to_not be nil
      expect(session[:remember_digest]).to_not be nil
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "login with invalid information" do
      ENV["ADMIN_PASSWORD"] = 'foobar'
      post sessions_create_path, params: { session: { email: "", password: "" } }
      expect(response).to have_http_status(:redirect)
      expect(flash.empty?).to be false
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "login with valid information followed by logout" do
      ENV["ADMIN_PASSWORD"] = 'password'
      get sessions_new_path
      expect(response.body).to match(/Log In/)
      post sessions_create_path, params: { 
        session: { 
          password: 'password',
          forwarding_url: genres_path
        } 
      }
      expect(session[:logged_in]).to_not be nil
      expect(session[:remember_digest]).to_not be nil
      assert_redirected_to genres_path
      expect(response.redirect?).to be true
      ENV["ADMIN_PASSWORD"] = nil
    end
  end

  describe "GET /destroy" do
    it "returns http redirect" do
      get sessions_destroy_path
      expect(session[:remember_digest]).to be nil
      expect(response).to have_http_status(:redirect)
    end
  end



end

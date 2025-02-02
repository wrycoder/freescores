require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "handling unauthorized users" do
    it "redirects someone who has not yet logged in" do
      get dashboard_show_path
      expect(response).to have_http_status(:redirect)
    end
  end
end

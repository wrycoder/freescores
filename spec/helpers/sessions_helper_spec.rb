require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  it "can get a new token" do
    token = new_token
    expect(token).to_not be nil
  end

  it "remembers a user" do
    remember
    expect(session[:remember_digest]).to_not be nil
  end

  it "alerts the user if the system password is not set" do
    password = 'password'
    expect { authenticate(password) }.to raise_error(RuntimeError)
    ENV["ADMIN_PASSWORD"] = password
    expect(authenticate(password)).to be true
    expect(authenticate('foobar')).to be false
    ENV["ADMIN_PASSWORD"] = nil
  end
end

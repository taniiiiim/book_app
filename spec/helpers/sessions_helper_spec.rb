require 'rails_helper'
require "test_helper"

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

  before do
    @user = User.create(name: "Example User", email: "user@example.com",
                        password: "password", password_confirmation: "password")
    remember_token = User.new_token
    @user.update_attribute(:remember_digest, User.digest(remember_token))
    cookies.permanent.signed[:user_id] = @user.id
    cookies.permanent[:remember_token] = remember_token
  end

  it "current_user returns right user when session is nil" do
    expect(@user).to eq current_user
    expect(is_logged_in?).to be_truthy
  end

  it "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    expect(current_user.nil?).to be_truthy
  end


end

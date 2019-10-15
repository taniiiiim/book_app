require 'rails_helper'

RSpec.describe "users controller", type: :request do

  before do
    @user = User.create(name: "Example User", email: "user@example.com",
                        password: "password", password_confirmation: "password",
                        admin: true)
    @user1 = User.create(name: "Example User1", email: "user1@example.com",
                        password: "password", password_confirmation: "password")
    delete logout_path
  end

  it "should get new" do
    get signup_path
    assert_response :success
  end

  it "should redirect edit when not logged in" do
    get edit_user_path(@user)
    expect(response.status).to eq 302
    follow_redirect!
    expect(flash.empty?).to be_falsey
    expect(response).to render_template "sessions/new"
  end

  it "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    expect(response.status).to eq 302
    follow_redirect!
    expect(flash.empty?).to be_falsey
    expect(response).to render_template "sessions/new"
  end

  it "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user1)
    expect(is_logged_in?).to be_truthy
    expect(@user1.admin?).to be_falsey
    patch user_path(@user1), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }
    expect(@user1.admin?).to be_falsey
  end

  it "should redirect edit when logged in as wrong user" do
    log_in_as(@user)
    expect(is_logged_in?).to be_truthy
    get edit_user_path(@user1)
    expect(response.status).to eq 302
    follow_redirect!
    expect(flash.empty?).to be_truthy
    expect(response).to render_template "static_pages/home"
  end

  it "should redirect update when logged in as wrong user" do
    log_in_as(@user)
    patch user_path(@user1), params: { user: { name: @user.name,
                                              email: @user.email } }
    expect(response.status).to eq 302
    follow_redirect!
    expect(flash.empty?).to be_truthy
    expect(response).to render_template "static_pages/home"
  end

  it "should redirect index when not logged in" do
    get users_path
    follow_redirect!
    expect(response).to render_template "sessions/new"
  end

  it "should redirect destroy when not logged in" do
    count = User.count
    delete user_path(@user1)
    expect(count).to eq User.count
    follow_redirect!
    expect(response).to render_template "sessions/new"
  end

  it "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user1)
    count = User.count
    delete user_path(@user)
    expect(count).to eq User.count
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

end

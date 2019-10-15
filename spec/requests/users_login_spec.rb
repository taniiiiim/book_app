require "rails_helper"

RSpec.describe "login/logout", type: :request do

  before do
    @user = User.create(name: "Example User", email: "user@example.com",
                        password: "password", password_confirmation: "password")
  end

  it "login with invalid information" do
    get login_path
    expect(response).to render_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    expect(response).to render_template 'sessions/new'
    expect(flash.empty?).to be_falsey
    get root_path
    expect(flash.empty?).to be_truthy
  end

  it "login with valid information" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    expect(response.status).to eq 302
    follow_redirect!
    expect(response).to render_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    expect(is_logged_in?).to be_truthy

    delete logout_path
    expect(is_logged_in?).to be_falsey
    expect(response.status).to eq 302
    #delete again at other tab
    delete logout_path
    follow_redirect!
    expect(response).to render_template 'static_pages/home'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  it "login with remembering" do
    log_in_as(@user, remember_me: '1')
    expect(cookies['remember_token'].empty?).to be_falsey
  end

  it "login without remembering" do
    log_in_as(@user, remember_me: '1')
    delete logout_path
    log_in_as(@user, remember_me: '0')
    expect(cookies['remember_token'].empty?).to be_truthy
  end


end

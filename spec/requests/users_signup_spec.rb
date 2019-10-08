require "rails_helper"

RSpec.describe "signup", type: :request do

  it "invalid signup information" do
    get signup_path
    count = User.count
    post users_path, params: { user: { name:  "",
                                       email: "user@invalid",
                                       password:              "foo",
                                       password_confirmation: "bar" } }
    expect(count).to eq User.count
    expect(response).to render_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  it "valid signup information" do
    get signup_path
    count = User.count
    post users_path, params: { user: { name:  "Example User",
                                       email: "user@example.com",
                                       password:              "password",
                                       password_confirmation: "password" } }
    expect(count).not_to eq User.count
    expect(response.status).to eq 302
    follow_redirect!
    expect(response).to render_template 'users/show'
    expect(flash.empty?).to be_falsey
    assert_select 'div.alert'
  end

end

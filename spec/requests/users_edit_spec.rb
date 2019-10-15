require "rails_helper"

RSpec.describe "edit user" do

  before do
    @user = User.create(name: "Example User", email: "user@example.com",
                        password: "password", password_confirmation: "password")
  end

  it "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    expect(response).to render_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    expect(response).to render_template 'users/edit'
  end

  it "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    expect(response).to render_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    expect(response.status).to eq 302
    follow_redirect!
    expect(response).to render_template 'users/show'
    expect(flash.empty?).to be_falsey
    @user.reload
    expect(@user.name).to eq name
    expect(@user.email).to eq email
  end

  it "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    expect(response.status).to eq 302
    follow_redirect!
    expect(response).to render_template "users/edit"
  end

end

require "rails_helper"

RSpec.describe "User index", type: :request do

  before do

    30.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create(name:  name,
                   email: email,
                   password:              password,
                   password_confirmation: password)
    end

  end

  it "index as admin including pagination and delete links" do
    admin = User.create(name:  "Example User",
                 email: "user@example.com",
                 password:              "password",
                 password_confirmation: "password",
                 admin: true)
    log_in_as(admin)
    non_admin = User.first
    expect(is_logged_in?).to be_truthy
    get users_path
    expect(response).to render_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    count = User.count
      delete user_path(non_admin)
    expect(count).not_to eq User.count
  end

end

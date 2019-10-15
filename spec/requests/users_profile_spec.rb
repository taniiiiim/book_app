require "rails_helper"

RSpec.describe "User profile", type: :request do

  include ApplicationHelper
  

  before do
    @user = User.create(name:  "Example User",
                 email: "user@example.com",
                 password:              "password",
                 password_confirmation: "password",
                 admin: true)
    @book = @user.books.create!(book_name: "Example", first_name: "Example", last_name: "User",
                     published: 2000, price: 1100, category: "Example",
                     abstract: "This is a sample book.", isbn: "123-4-567-89000-0")
    @book1 = @user.books.create!(book_name: "Example", first_name: "Example", last_name: "User",
                     published: 1999, price: 1100, category: "Example",
                     abstract: "This is a sample book.", isbn: "123-4-567-89000-1")
    30.times do |i|
        @user.books.create!(book_name: "Example", first_name: "Example", last_name: "User",
                            published: 2000, price: 1100, category: "Example", 
                            abstract: "This is a sample book.",
                            isbn: "123-4-567-890" + (i + 10).to_s + "-0")
    end
  end

  it "profile display" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    get user_path(@user)
    expect(response).to render_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_match @user.books.count.to_s, response.body
    assert_select 'div.pagination'
    @user.books.paginate(page: 1).each do |book|
      assert_match book.abstract, response.body
    end
  end

end

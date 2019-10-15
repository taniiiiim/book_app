require "rails_helper"

RSpec.describe "books_controller", type: :request do

  before do
    @user = User.create(name:  "Example User",
                 email: "user@example.com",
                 password:              "password",
                 password_confirmation: "password",
                 admin: true)
    @user1 = User.create(name:  "Example User1",
                 email: "user1@example.com",
                 password:              "password",
                 password_confirmation: "password",
                 admin: false)
    @book = @user.books.create!(book_name: "Example", first_name: "Example", last_name: "User",
                     published: 2000, price: 1100, category: "Example",
                     abstract: "This is a sample book.", isbn: "123-4-567-89000-0")
    30.times do |i|
        @user.books.create!(book_name: "Example", first_name: "Example", last_name: "User",
                            published: 2000, price: 1100, category: "Example", 
                            abstract: "This is a sample book.",
                            isbn: "123-4-567-890" + (i + 10).to_s + "-0")
        @user1.books.create!(book_name: "Example", first_name: "Example", last_name: "User",
                            published: 2000, price: 1100, category: "Example", 
                            abstract: "This is a sample book.",
                            isbn: "123-4-567-891" + (i + 10).to_s + "-0")
    end
  end

  it "should redirect create when not logged in" do
    count = Book.count
    post books_path, params: { book: { book_name: "Example", first_name: "Example",
                     last_name: "User", published: 2000, price: 1100, category: "Example",
                     abstract: "This is a sample book.", isbn: "123-4-567-89100-0" } }
    expect(count).to eq Book.count
    follow_redirect!
    expect(response).to render_template "sessions/new"
  end

  it "should redirect destroy when not logged in" do
    count = Book.count
    delete book_path(@book)
    expect(count).to eq Book.count
    follow_redirect!
    expect(response).to render_template "sessions/new"
  end

  it "should redirect destroy for wrong micropost" do
    log_in_as(@user)
    count = Book.count
    delete book_path(@user1.books.first)
    expect(count).to eq Book.count
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

end

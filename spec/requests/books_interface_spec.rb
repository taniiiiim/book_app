require "rails_helper"

RSpec.describe "Books interface", type: :request do

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

  it "book interface" do
    log_in_as(@user)
    get user_path(@user)
    assert_select 'div.pagination'
    count = Book.count
    post books_path, params: { book: { book_name: "", first_name: "Example", last_name: "User",
                               published: 2000, price: 1100, category: "Example",
                               abstract: "Instance", isbn: "123-4-5678-9031-1" } }
    expect(count).to eq Book.count
    expect(flash[:danger].nil?).to be_falsey
    count = Book.count
    post books_path, params: { book: { book_name: "Example", first_name: "Example", last_name: "User",
                               published: 2000, price: 1100, category: "Example",
                               abstract: "Instance", isbn: "123-4-5678-9031-1" } }
    expect(count).not_to eq Book.count
    follow_redirect!
    expect(response).to render_template "users/show"
    assert_match "Abstract", response.body
    assert_select 'a', text: 'Delete'
    @book2 = @user.books.first
    count = Book.count
    delete book_path(@book2)
    expect(count).not_to eq Book.count
    get user_path(@user1)
    assert_select 'a', text: 'Delete', count: 0
  end

end

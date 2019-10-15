require "rails_helper"

RSpec.describe "Search controller", type: :request do

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

  it "redirect if not logged in" do
    get search_path
    follow_redirect!
    expect(response).to render_template "sessions/new"
    post search_path, params: {book_name: "Example", first_name: "Example", last_name: "User",
                              published: 2000, price: 1100, category: "Example",
                              isbn: "123-4-567-8911-0"}
    follow_redirect!
    expect(response).to render_template "sessions/new"
  end

  it "redirect if get" do
    log_in_as(@user)
    get search_path
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

  it "render search if all blank" do
    log_in_as(@user)
    post search_path, params: {book_name: "", first_name: "", last_name: "",
                              published: "", price: "", category: "",
                              isbn: ""}
    expect(response).to render_template "static_pages/home"
  end

  it "show nothing when no results" do
    log_in_as(@user)                  
    post search_path, params: {book_name: "aaa", first_name: "", last_name: "",                               published: "", price: "", category: "", isbn: ""}
    expect(response).to render_template "static_pages/home"
    assert_select "div.pagination", count: 0
   end

  it "show feeds when successful" do
    log_in_as(@user)                  
    post search_path, params: {book_name: "Example", first_name: "", last_name: "",
                      published: "", price: "", category: "",
                      abstract: "", isbn: ""}
    expect(response).to render_template "static_pages/home"
    assert_select "div.pagination"
  end

end

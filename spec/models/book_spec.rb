require 'rails_helper'

RSpec.describe Book, type: :model do

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
    @book1 = @user.books.create!(book_name: "Example", first_name: "Example", last_name: "User",
                     published: 1999, price: 1100, category: "Example",
                     abstract: "This is a sample book.", isbn: "123-4-567-89000-1")

  end

  it "should be valid" do
    expect(@book).to be_valid
  end

  it "user_id should be present" do
    @book.user_id = nil
    expect(@book).not_to be_valid
  end

  it "book_name should be present and should not be too long" do
    @book.book_name = nil
    expect(@book).not_to be_valid
    @book.book_name = "a" * 512
    expect(@book).not_to be_valid
  end

  it "first_name should be present and should not be too long" do
    @book.first_name = nil
    expect(@book).not_to be_valid
    @book.first_name = "a" * 51
    expect(@book).not_to be_valid
  end

  it "last_name should be present and should not be too long" do
    @book.last_name = nil
    expect(@book).not_to be_valid
    @book.last_name = "a" * 51
    expect(@book).not_to be_valid
  end

  it "published should be present and should not be later" do
    @book.published = nil
    expect(@book).not_to be_valid
    @book.published = Time.now + 1
    expect(@book).not_to be_valid
  end

  it "price should not be present" do
    @book.price = nil
    expect(@book).not_to be_valid
    @book.price = -1
    expect(@book).not_to be_valid
  end

  it "category should be present and should not be too long" do
    @book.category = nil
    expect(@book).not_to be_valid
    @book.category = "a" * 51
    expect(@book).not_to be_valid
  end

  it "abstract should be present and should not be too long" do
    @book.abstract = nil
    expect(@book).not_to be_valid
    @book.abstract = "a" * 512
    expect(@book).not_to be_valid
  end

  it "isbn should be unique, present, 17 letters and must include 3 -" do
    @book1 = @user.books.build(book_name: "Example", first_name: "Example", last_name: "User",
                     published: 2000, price: 1100, category: "Example",
                     abstract: "This is a sample book.", isbn: "123-4-567-89000-0")
    expect(@book1.save).to be_falsey
    @book2 = @user1.books.build(book_name: "Example", first_name: "Example", last_name: "User",
                     published: 2000, price: 1100, category: "Example",
                     abstract: "This is a sample book.", isbn: "123-4-567-89000-0")
    expect(@book2.save).to be_truthy
    @book.isbn = nil
    expect(@book).not_to be_valid
    @book.isbn = "111-1-11-11111-1-"
    expect(@book).not_to be_valid
    @book.isbn = "111-1-11-1111111-"
    expect(@book).not_to be_valid
  end

  it "order should be most recent first" do
    expect(@book).to eq Book.first
  end

end

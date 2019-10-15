require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  it "should be valid" do
    expect(@user).to be_valid
  end

  it "name should be present" do
    @user.name = "     "
    expect(@user).not_to be_valid
  end

  it "email should be present" do
    @user.email = "     "
    expect(@user).not_to be_valid
  end

  it "name should not be too long" do
    @user.name = "a"*51
    expect(@user).not_to be_valid
  end

  it "email should not be too long" do
    @user.email = "a"*244 + "@example.com"
    expect(@user).not_to be_valid
  end

  it "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user).not_to be_valid
    end
  end

  it "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    expect(duplicate_user).not_to be_valid
  end

  it "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    expect(mixed_case_email.downcase).to eq @user.reload.email
  end

  it "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    expect(@user).not_to be_valid
  end

  it "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    expect(@user).not_to be_valid
  end

  it "authenticated? should return false for a user with nil digest" do
   expect(@user.authenticated?('')).to be_falsey
  end

  it "associated books should be destroyed" do
    @user.save
    @user.books.create!(book_name: "Example", first_name: "Example", last_name: "User", published: "2019", price: 500, category: "Example", abstract: "example", isbn: "111-1-11-111111-1")
    count = Book.count
    @user.destroy
    expect(count).not_to eq Book.count
  end

  it "feed should have the right posts" do


  end

end

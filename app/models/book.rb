class Book < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :book_name, presence: true, length: {maximum: 511}
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  validates :published, presence: true, numericality: {less_than_or_equal_to: Time.now.year.to_i} 
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :category, presence: true, length: {maximum: 50}
  validates :abstract, presence: true, length: {maximum: 511}
  VALID_EMAIL_REGEX = /\A\d{3}-\d{1}-\d{2,7}-\d{1,6}-\d{1}$\z/
  validates :isbn, presence: true, length: {is: 17},
            format: {with: VALID_EMAIL_REGEX},
            :uniqueness => {:scope => :user_id}


    def Book.search(params)
      search_params = {"book_name"=> params[:book_name], "first_name"=> params[:first_name], "last_name"=> params[:last_name], "published"=> params[:published], "price"=> params[:price], "isbn"=> params[:isbn], "category"=> params[:category]}
      book_ids = "SELECT id FROM books WHERE"
      search_params.each do |p|
        if !(p.empty?)
          book_ids = book_ids + " #{p[0]} = #{p[1]} and"
        end
      end
      book_ids = book_ids.slice!(book_ids.length-1)
      book_ids = book_ids.slice!(book_ids.length-1)
      book_ids = book_ids.slice!(book_ids.length-1)
      Book.where("id IN (#{book_ids})")
    end

end

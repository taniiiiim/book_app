class SearchController < ApplicationController
  before_action :logged_in_user
  protect_from_forgery :except => ["create"]

  def new
    redirect_to root_url
  end

  def create
    if search_params?
      @feed_items = Book.where("book_name = :book_name OR first_name = :first_name OR last_name = :last_name OR published = :published OR price = :price OR isbn = :isbn OR category = :category", book_name: params[:book_name], first_name: params[:first_name], last_name: params[:last_name], published: params[:published], price: params[:price], isbn: params[:isbn], category: params[:category]).paginate(page: params[:page])    
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
      render "static_pages/home"
  end
end

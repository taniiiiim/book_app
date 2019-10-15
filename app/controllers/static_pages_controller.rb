class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @book = current_user.books.build if logged_in?
      @books = current_user.books.paginate(page: params[:page])
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end

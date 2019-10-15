class BooksController < ApplicationController
  before_action :logged_in_user, only: [:search, :edit, :update, :create, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def search
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:success] = "Book updated"
      redirect_to current_user
    else
      render 'edit'
    end

  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      flash[:success] = "Book added!"
      redirect_to current_user
    else
      flash[:danger] = "Book add failed!"
      redirect_to current_user
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    flash[:success] = "Book deleted"
    redirect_to request.referrer || root_url
  end

  private

  def book_params
    params.require(:book).permit(:book_name, :first_name, :last_name, :published, :price, :category, :abstract, :isbn)
  end

    def correct_user
      @user = Book.find_by(id: params[:id]).user
      redirect_to root_url if current_user != @user
    end

end

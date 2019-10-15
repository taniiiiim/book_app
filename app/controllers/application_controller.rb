class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def search_params?
      !(params[:book_name].empty? && params[:first_name].empty? && params[:last_name].empty? && params[:published].empty? && params[:price].empty? && params[:isbn].empty? && params[:category].empty?)
    end

end

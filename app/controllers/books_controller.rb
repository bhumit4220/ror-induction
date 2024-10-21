class BooksController < ApplicationController
  load_and_authorize_resource
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = if params[:search].present?
      Book.search_books(params[:search])
    else
      Book.all
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  def edit
    can? :edit, @post
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  def favorite
    type = params[:type]
    if type == "favorite"
      current_user.favorite_books << @book
      message = "#{@book.name} marked as favorite."
      render json: { success: true, message: message }, status: :ok
    elsif type == "unfavorite"
      current_user.favorite_books.delete(@book)
      message = "#{@book.name} removed from favorites."
      render json: { success: true, message: message }, status: :ok
    else
      render json: { success: false, message: "Unable to update favorite status."}, status: :unprocessable_entity
    end
  end

  def report
    @favorite_books = Book.unscoped
      .select('books.*, COUNT(favorites.id) AS favorites_count')
      .left_joins(:favorites)
      .group('books.id')
      .order('favorites_count DESC')
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:name, :author_name, :description, :category_id, :image)
  end
end

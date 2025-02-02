class CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_category, only: [:show, :edit, :update, :destroy]


  def index
    @categories = Category.includes(:books)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def edit
    can? :edit, @category
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: 'Category was successfully destroyed.'
  end


  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(Category::PERMITTED_PARAMS)
  end
end

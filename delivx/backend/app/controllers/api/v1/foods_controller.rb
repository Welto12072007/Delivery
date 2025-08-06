class Api::V1::FoodsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :set_food, only: [:show, :update, :destroy]
  before_action :set_restaurant, only: [:index, :create], if: -> { params[:restaurant_id].present? }
  
  # GET /api/v1/foods or /api/v1/restaurants/:restaurant_id/foods
  def index
    if @restaurant
      @foods = @restaurant.foods.available.includes(:category)
    else
      @foods = Food.available.includes(:restaurant, :category)
      @foods = @foods.where('name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
      @foods = @foods.where(category_id: params[:category_id]) if params[:category_id].present?
    end
    
    @foods = @foods.page(params[:page]).per(12)
    
    render json: {
      foods: @foods.map { |food| food_json(food) },
      pagination: {
        current_page: @foods.current_page,
        total_pages: @foods.total_pages,
        total_count: @foods.total_count
      }
    }
  end
  
  # GET /api/v1/foods/1
  def show
    render json: { food: food_detailed_json(@food) }
  end
  
  # POST /api/v1/foods or /api/v1/restaurants/:restaurant_id/foods
  def create
    if @restaurant
      @food = @restaurant.foods.build(food_params)
    else
      @food = Food.new(food_params)
    end
    
    if @food.save
      render json: { food: food_json(@food) }, status: :created
    else
      render json: { errors: @food.errors }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /api/v1/foods/1
  def update
    if @food.update(food_params)
      render json: { food: food_json(@food) }
    else
      render json: { errors: @food.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/foods/1
  def destroy
    @food.destroy
    head :no_content
  end
  
  private
  
  def set_food
    @food = Food.find(params[:id])
  end
  
  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
  
  def food_params
    params.require(:food).permit(:name, :description, :price, :available, :image, :category_id, :restaurant_id)
  end
  
  def food_json(food)
    {
      id: food.id,
      name: food.name,
      description: food.description,
      price: food.price,
      formatted_price: food.formatted_price,
      available: food.available,
      image_url: food.image.attached? ? url_for(food.image) : nil,
      category: { id: food.category.id, name: food.category.name },
      restaurant: { id: food.restaurant.id, name: food.restaurant.name }
    }
  end
  
  def food_detailed_json(food)
    food_json(food).merge({
      created_at: food.created_at,
      updated_at: food.updated_at
    })
  end
end

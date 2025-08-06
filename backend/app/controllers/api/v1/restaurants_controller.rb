class Api::V1::RestaurantsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :set_restaurant, only: [:show, :update, :destroy]
  
  # GET /api/v1/restaurants
  def index
    @restaurants = Restaurant.active.includes(:categories)
    @restaurants = @restaurants.where('name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    @restaurants = @restaurants.joins(:categories).where(categories: { id: params[:category_id] }) if params[:category_id].present?
    @restaurants = @restaurants.page(params[:page]).per(10)
    
    render json: {
      restaurants: @restaurants.map { |restaurant| restaurant_json(restaurant) },
      pagination: {
        current_page: @restaurants.current_page,
        total_pages: @restaurants.total_pages,
        total_count: @restaurants.total_count
      }
    }
  end
  
  # GET /api/v1/restaurants/1
  def show
    render json: { 
      restaurant: restaurant_detailed_json(@restaurant),
      foods: @restaurant.foods.available.map { |food| food_json(food) }
    }
  end
  
  # POST /api/v1/restaurants
  def create
    @restaurant = current_user.restaurants.build(restaurant_params)
    
    if @restaurant.save
      render json: { restaurant: restaurant_json(@restaurant) }, status: :created
    else
      render json: { errors: @restaurant.errors }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /api/v1/restaurants/1
  def update
    if @restaurant.update(restaurant_params)
      render json: { restaurant: restaurant_json(@restaurant) }
    else
      render json: { errors: @restaurant.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/restaurants/1
  def destroy
    @restaurant.destroy
    head :no_content
  end
  
  private
  
  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
  
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :address, :city, :state, :zip_code, 
                                       :phone, :delivery_time, :delivery_fee, :minimum_order, 
                                       :active, :image, category_ids: [])
  end
  
  def restaurant_json(restaurant)
    {
      id: restaurant.id,
      name: restaurant.name,
      description: restaurant.description,
      address: restaurant.full_address,
      phone: restaurant.phone,
      delivery_time: restaurant.delivery_time,
      delivery_fee: restaurant.delivery_fee,
      minimum_order: restaurant.minimum_order,
      rating: restaurant.average_rating.round(1),
      active: restaurant.active,
      image_url: restaurant.image.attached? ? url_for(restaurant.image) : nil,
      categories: restaurant.categories.map { |cat| { id: cat.id, name: cat.name } }
    }
  end
  
  def restaurant_detailed_json(restaurant)
    restaurant_json(restaurant).merge({
      city: restaurant.city,
      state: restaurant.state,
      zip_code: restaurant.zip_code,
      created_at: restaurant.created_at,
      updated_at: restaurant.updated_at
    })
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
      category: { id: food.category.id, name: food.category.name }
    }
  end
end

class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]
  
  # GET /api/v1/users
  def index
    @users = User.all.page(params[:page]).per(10)
    render json: {
      users: @users.map { |user| user_json(user) },
      pagination: {
        current_page: @users.current_page,
        total_pages: @users.total_pages,
        total_count: @users.total_count
      }
    }
  end
  
  # GET /api/v1/users/1
  def show
    render json: { user: user_json(@user) }
  end
  
  # POST /api/v1/users
  def create
    @user = User.new(user_params)
    
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { 
        user: user_json(@user), 
        token: token 
      }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /api/v1/users/1
  def update
    if @user.update(user_params)
      render json: { user: user_json(@user) }
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/users/1
  def destroy
    @user.destroy
    head :no_content
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :address, :city, :state, :zip_code, :role)
  end
  
  def user_json(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      city: user.city,
      state: user.state,
      zip_code: user.zip_code,
      role: user.role,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end

class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request
  
  # POST /api/v1/auth/login
  def login
    @user = User.find_by(email: params[:email])
    
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { 
        user: user_json(@user), 
        token: token,
        message: 'Login realizado com sucesso!'
      }
    else
      render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
    end
  end
  
  # POST /api/v1/auth/register
  def register
    @user = User.new(user_params)
    
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { 
        user: user_json(@user), 
        token: token,
        message: 'Conta criada com sucesso!'
      }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/auth/logout
  def logout
    # No Rails API, o logout é normalmente feito no frontend removendo o token
    render json: { message: 'Logout realizado com sucesso!' }
  end
  
  private
  
  def user_params
    params.permit(:name, :email, :password, :phone, :address, :city, :state, :zip_code)
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
      role: user.role
    }
  end
end

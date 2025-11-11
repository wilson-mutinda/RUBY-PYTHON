class Api::V1::UsersController < ApplicationController
  # create_user
  def create_user
    begin
      service = UserService.new(user_params)
      result = service.create_user
      if result[:success]
        serialized = UserSerializer.new(result[:info])
        render json: { message: result[:message], info: serialized }, status: :created
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # single_user
  def single_user
    begin
      service = UserService.new(slug: params[:slug])
      result = service.single_user
      if result[:success]
        render json: result[:info], serializer: UserSerializer, status: :ok
      else
        render json: result[:errors], status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # all_users
  def all_users
    begin
      service = UserService.new
      result = service.all_users
      if result[:success]
        render json: { info: result[:info]}, status: :ok
      else
        render json: { errors: success[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_user
  def update_user
    begin
      service = UserService.new(user_params.merge(slug: params[:slug]))
      result = service.update_user
      if result[:success]
        serialized = UserSerializer.new(result[:info])
        render json: { message: result[:message], info: serialized }, status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wromg!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_user
  def delete_user
    begin
      service = UserService.new(slug: params[:slug])
      result = service.delete_user
      if result[:success]
        render json: { message: result[:message]}, status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # restore_user
  def restore_user
    begin
      service = UserService.new(slug: params[:slug])
      result = service.restore_user
      if result[:success]
        render json: { message: result[:message]}, status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # privately hold user_params
  private
  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation, :role)
  end
end

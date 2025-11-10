class Api::V1::CategoriesController < ApplicationController

  # create_category
  def create_category
    begin
      service = CategoryService.new(category_params)
      result = service.create_category
      if result[:success]
        render json: { message: result[:message], info: result[:info]}, status: :created
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # single_category
  def single_category
    begin
      service = CategoryService.new(slug: params[:slug])
      result = service.single_category
      if result[:success]
        render json: result[:info], serializer: CategorySerializer, status: :ok
      else
        render json: result[:errors], status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # all_categories
  def all_categories
    begin
      service = CategoryService.new
      result = service.all_categories
      if result[:success]
        render json: result[:info], status: :ok
      else
        render json: result[:errors], status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_category
  def update_category
    begin
      service = CategoryService.new(category_params.merge(slug: params[:slug]))
      result = service.update_category
      if result[:success]
        render json: { message: result[:message], info: result[:info]}, status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_category
  def delete_category
    begin
      service = CategoryService.new(slug: params[:slug])
      result = service.delete_category
      if result[:success]
        render json: { message: result[:message]}, status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # restore_category
  def restore_category
    begin
      service = CategoryService.new(slug: params[:slug])
      result = service.restore_category
      if result[:success]
        render json: { message: result[:message]}, status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # privately hold category_params
  private

  def category_params
    params.require(:category).permit(:category_name)
  end
end

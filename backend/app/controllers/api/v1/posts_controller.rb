class Api::V1::PostsController < ApplicationController

  # create_post
  def create_post
    begin
      service = PostService.new(post_params)
      result = service.create_post

      puts "DEBUG params #{result}"
      
      if result[:success]
        render json: result[:info], serializer: PostSerializer, status: :created
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # single_post
  def single_post
    begin
      service = PostService.new(slug: params[:slug])
      result = service.single_post

      if result[:success]
        render json: result[:info], serializer: PostSerializer, status: :ok
      else
        render json: result[:errors], status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # all_posts
  def all_posts
    begin
      service = PostService.new
      result = service.all_posts
      if result[:success]
        render json: result[:info], status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_post
  def update_post
    begin
      service = PostService.new(post_params.merge(slug: params[:slug]))
      result = service.update_post
      if result[:success]
        render json: result[:info], status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_post
  def delete_post
    begin
      service = PostService.new(slug: params[:slug])
      result = service.delete_post
      if result[:success]
        render json: { message: result[:message]}, status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # restore_post
  def restore_post
    begin
      service = PostService.new(slug: params[:slug])
      result = service.restore_post
      if result[:success]
        render json: { message: result[:message]}, status: :ok
      else
        render json: { errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # privately hold post_params
  private
  def post_params
    params.require(:post).permit(:description, :category_id, :post_image)
  end
end

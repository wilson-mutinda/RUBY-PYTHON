class PostService

  include SearchHelper

  def initialize(params = {})
    @params = params || {}
    @posts = Post.all.order(:id).to_a
    @target_param = params[:slug]
  end

  # create_post
  def create_post
    # description_param
    description_param = normalize_description_param
    if description_param.is_a?(Hash) && description_param.key?(:errors)
      return description_param
    end

    # category_id_param
    category_id_param = normalize_category_id_param
    if category_id_param.is_a?(Hash) && category_id_param.key?(:errors)
      return category_id_param
    end

    # post_image_param
    post_image_param = normalize_post_image
    if post_image_param.is_a?(Hash) && post_image_param.key?(:errors)
      return post_image_param
    end

    puts "DEBUG data {#{category_id_param}, #{description_param}}"

    # create_post
    created_post = Post.new(
      description: description_param,
      category_id: category_id_param
    )

    # attach post_image
    created_post.post_image.attach(post_image_param)

    if created_post.save
      { success: true, message: "Post created successfully!", info: created_post }
    else
      { success: false, errors: created_post.errors.full_messages }
    end
  end

  # single_post
  def single_post
    post = search_post_by_slug(@posts, @target_param)
    if post.is_a?(Hash) && post.key?(:errors)
      return { success: false, errors: post }
    else
      { success: true, info: post }
    end
  end

  # all_posts
  def all_posts
    posts = Post.all.order(:slug).to_a
    if posts.empty?
      { success: false, errors: "Empty List!"}
    else
      { success: true, info: posts }
    end
  end

  # update_post
  def update_post
    @post = search_post_by_slug(@posts, @target_param)
    if @post.is_a?(Hash) && @post.key?(:errors)
      return @post
    end

    updated_post_params = {}

    if @params.key?(:description)
      # description_param
      description_param = normalize_description_param
      updated_post_params[:description] = description_param
    end

    if @params.key?(:category_id)
      # category_id_param
      category_id_param = normalize_update_category_id
      if category_id_param.is_a?(Hash) && category_id_param.key?(:errors)
        return category_id_param
      end
      updated_post_params[:category_id] = category_id_param
    end
    
    # update_post
    updated_post = @post.update(updated_post_params)
    if updated_post

      if @params.key?(:post_image)
        # post_image_param
        post_image_param = normalize_update_post_image
        updated_post_params[:post_image] = @post.post_image.attach(post_image_param)
      end
      { success: true, info: @post }
    else
      { success: false, errors: @post.errors.full_messages }
    end
  end

  # delete_post
  def delete_post
    @post = search_post_by_slug(@posts, @target_param)

    if @post.is_a?(Hash) && @post.key?(:errors)
      return @post
    end

    deleted = @post.soft_delete
    if deleted
      { success: true, message: "Post soft deleted successfully!"}
    else
      { success: false, errors: @post.errors.full_messages }
    end
  end

  # restore_post
  def restore_post
    post = Post.unscoped.find_by(slug: @params[:slug])

    if post.nil?
      return { success: false, errors: "Post not found!"}
    end

    unless post.post_deleted?
      return { success: false, errors: "Post is not deleted!"}
    end

    post.restore
    { success: true, message: "Post restored successfully!"}
  end

  private

  # normalize_update_category_id
  def normalize_update_category_id
    category_id_param = @params[:category_id]
    if category_id_param.present?

      # check whether category exists
      existing = Category.find_by(id: category_id_param)
      if existing.nil?
        return { errors: { category: "Category does not exist!"}}
      end
      category_id_param
    end
  end

  # normalize_update_post_image
  def normalize_update_post_image
    post_image_param = @params[:post_image]
    if post_image_param.present?
      post_image_param
    end
  end

  # normalize_update_description
  def normalize_update_description
    description_param = @params[:description].to_s.downcase
    if description_param.present?
      description_param.titleize
    end
  end

  # normalize_post_image
  def normalize_post_image
    post_image_param = @params[:post_image]
    if post_image_param.blank?
      return { errors: { post_image: "Please select image!"}}
    end
    post_image_param
  end

  # normalize_category_id_param
  def normalize_category_id_param
    category_id_param = @params[:category_id].to_i
    if category_id_param.blank?
      return { errors: { category: "Please select category!"}}
    end

    # check whether category exists
    existing = Category.find_by(id: category_id_param)
    if existing.nil?
      return { errors: { category: "Category does not exist!"}}
    end
    category_id_param
  end

  # normalize_description_param
  def normalize_description_param
    description_param = @params[:description].to_s.downcase
    if description_param.blank?
      return { errors: { description: "Please input description!"}}
    end
    description_param.titleize
  end
end
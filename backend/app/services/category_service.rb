class CategoryService

  include SearchHelper

  def initialize(params = {})
    @params = params || {}
    @categories = Category.all.order(:id).to_a
    @target_param = params[:slug]
  end

  # create_category
  def create_category
    # name_param
    name_param = normalize_name_param
    if name_param.is_a?(Hash) && name_param.key?(:errors)
      return name_param
    end

    # create_category
    created_category = Category.create(
      category_name: name_param
    )
    if created_category
      { success: true, message: "Category record created", info: created_category }
    else
      { success: false, errors: created_category.errors.full_messages }
    end
  end

  # view single_category
  def single_category
    category = search_category_by_slug(@categories, @target_param)
    if category.is_a?(Hash) && category.key?(:errors)
      return { success: false, errors: category }
    else
      { success: true, info: category }
    end
  end

  # all_categories
  def all_categories
    categories = Category.all.order(:category_name).to_a
    if categories.empty?
      return { errors: "Empty List!"}
    else
      { success: true, info: categories }
    end
  end

  # update_category
  def update_category
    @category = search_category_by_slug(@categories, @target_param)
    if @category.is_a?(Hash) && @category.key?(:errors)
      return @category
    end

    updated_category_params = {}

    # name_param
    name_param = normalize_update_name_param
    if name_param.is_a?(Hash) && name_param.key?(:errors)
      return name_param
    end
    updated_category_params[:category_name] = name_param

    # update_category
    updated_category = @category.update(updated_category_params)
    if updated_category
      { success: true, message: "Category updated successfully!", info: @category }
    else
      { success: false, errors: @category.errors.full_messages }
    end
  end

  # delete_category
  def delete_category
    @category = search_category_by_slug(@categories, @target_param)
    if @category.is_a?(Hash) && @category.key?(:errors)
      return @category
    end

    deleted = @category.soft_delete
    if deleted
      { success: true, message: "Successfully deleted '#{@category.category_name}'"}
    else
      { success: false, errors: @category.errors.full_messages }
    end
  end

  # restore_category
  def restore_category
    category = Category.unscoped.find_by(slug: @target_param)
    if category
      # check if it was deleted
      deleted = category.category_deleted?
      if deleted
        # restore
        category.restore_category
        { success: true, message: "Category restored."}
      else
        { success: false, errors: "Category was not deleted!"}
      end
    else
      { success: false, errors: "Category not found!"}
    end
  end

  private

  # normalize_update_name_param
  def normalize_update_name_param
    name_param = @params[:category_name].to_s.downcase
    if name_param.present?
      # name should not exist
      existing = unique_category_name(@categories, name_param, @category.id)
      if existing.is_a?(Hash) && existing.key?(:errors)
        return existing
      end

      name_param
    end
  end

  # normalize_name_param
  def normalize_name_param
    name_param = @params[:category_name].to_s.downcase
    if name_param.blank?
      return { errors: { name: "Please input category name!"}}
    end

    # name should not exist!
    existing = search_category_name(@categories, name_param)
    if existing.is_a?(Hash) && existing.key?(:errors)
      return existing
    end
    name_param.titleize
  end
end
class CategorySerializer < ActiveModel::Serializer
  attributes :id, :category_name, :slug, :generated_on, :category_count

  def generated_on
    object.created_at.strftime("%B %d, %Y")
  end

  def category_count
    Category.count
  end
end

class PostSerializer < ActiveModel::Serializer

  include Rails.application.routes.url_helpers

  attributes :id, :description, :category_name, :generated_on, :image_url, :slug, :category_id

  def category_name
    object.category.category_name
  end

  def generated_on
    object.created_at.strftime("%B %d, %Y")
  end

  def image_url
    if object.post_image.attached?
      rails_blob_url(object.post_image, only_path: true)
    end
  end
end

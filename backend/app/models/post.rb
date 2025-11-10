class Post < ApplicationRecord

  default_scope { where(deleted_at: nil)}

  # soft_delete
  def soft_delete
    update(deleted_at: Time.current)
  end

  # deleted?
  def post_deleted?
    deleted_at.present?
  end

  # restore
  def restore
    update(deleted_at: nil)
  end

  belongs_to :category

  has_one_attached :post_image

  before_save :generate_slug

  # validations
  validates :description, presence: true, if: -> { new_record? || description.present? }
  validates :post_image, presence: true, if: -> { new_record? || post_image.present? }

  private
  def generate_slug
    if description.present?
      self.slug = description.parameterize
    end
  end
end

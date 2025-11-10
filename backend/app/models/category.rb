class Category < ApplicationRecord

  has_many :posts

  # all_categories by default
  default_scope { where(deleted_at: nil)}

  # soft_delete
  def soft_delete
    update(deleted_at: Time.current)
  end

  # deleted?
  def category_deleted?
    deleted_at.present?
  end

  # restore_category
  def restore_category
    update(deleted_at: nil)
  end

  before_save :generate_slug
  # validations
  validates :category_name, presence: true, uniqueness: true, if: -> { new_record? || category_name.present? }
  private
  def generate_slug
    if category_name.present?
      self.slug = category_name.parameterize
    end
  end
end

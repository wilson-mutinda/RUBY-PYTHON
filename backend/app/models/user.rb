class User < ApplicationRecord

  default_scope{ where(deleted_at: nil)}

  # soft_delete_user
  def soft_delete_user
    update(deleted_at: Time.current)
  end

  # check user_deleted
  def user_deleted?
    deleted_at.present?
  end

  # restore_user
  def restore_user
    update(deleted_at: nil)
  end

  before_save :generate_slug

  has_secure_password

  # validations
  validates :email, presence: true, uniqueness: true, if: -> { new_record? || email.present? }
  validates :phone, presence: true, uniqueness: true, if: -> { new_record? || phone.present? }
  validates :password, presence: true, confirmation: true, if: -> { new_record? || password.present? }
  validates :password_confirmation, presence: true, if: -> { new_record? || password.present? }

  private
  def generate_slug
    if email.present?
      self.slug = email.parameterize
    end
  end
end

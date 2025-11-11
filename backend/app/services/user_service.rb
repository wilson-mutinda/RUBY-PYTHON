class UserService

  include RegexHelper
  include SearchHelper

  def initialize(params = {})
    @params = params || {}
    @users = User.all.order(:id).to_a
    @target_param = params[:slug]
  end

  # create_user
  def create_user
    # email_param
    email_param = normalize_email_param
    if email_param.is_a?(Hash) && email_param.key?(:errors)
      return email_param
    end

    # phone_param
    phone_param = normalize_phone_param
    if phone_param.is_a?(Hash) && phone_param.key?(:errors)
      return phone_param
    end

    # password_param and password_confirmation_param
    password_param = normalize_password_and_password_confirmation_param
    if password_param.is_a?(Hash) && password_param.key?(:errors)
      return password_param
    end

    # create_user
    created_user = User.create(
      email: email_param,
      phone: phone_param,
      password: password_param[:password],
      password_confirmation: password_param[:password_confirmation],
      role: 'Admin'
    )
    if created_user
      { success: true, message: "User created successfully!", info: created_user }
    else
      { success: false, errors: created_user.errors.full_messages }
    end
  end

  # single_user
  def single_user
    user = search_user_by_slug(@users, @target_param)
    if user.is_a?(Hash) && user.key?(:errors)
      return { success: false, errors: user }
    else
      { success: true, info: user }
    end
  end

  # all_users
  def all_users
    users = User.all.order(:slug).to_a
    if users.empty?
      { success: false, errors: "Empty List!" }
    else
      { success: true, info: users    }
    end
  end

  # update_user
  def update_user
    @user = search_user_by_slug(@users, @target_param)
    if @user.is_a?(Hash) && @user.key?(:errors)
      return @user
    end

    updated_user_params = {}

    # email_param
    if @params.key?(:email)
      email_param = normalize_update_email_param
      if email_param.is_a?(Hash) && email_param.key?(:errors)
        return email_param
      end
      updated_user_params[:email] = email_param
    end

    # phone_param
    if @params.key?(:phone)
      phone_param = normalize_update_phone_param
      if phone_param.is_a?(Hash) && phone_param.key?(:errors)
        return phone_param
      end
      updated_user_params[:phone] = phone_param
    end

    # password_param
    if @params.key?(:password) || @params.key?(:password_confirmation)
      password_param = normalize_update_password_param
      if password_param.is_a?(Hash) && password_param.key?(:errors)
        return password_param
      end
      updated_user_params[:password] = password_param[:password]
      updated_user_params[:password_confirmation] = password_param[:password_confirmation]
    end

    # update_user
    updated_user = @user.update(updated_user_params)
    if updated_user
      { success: true, message: "User updated successfully!", info: @user }
    else
      { success: false, errors: @user.errors.full_messages }
    end
  end

  # delete_user
  def delete_user
    @user = search_user_by_slug(@users, @target_param)
    if @user.is_a?(Hash) && @user.key?(:errors)
      return @user
    end

    # check whether user was deleted
    user_del = @user.user_deleted?
    if user_del
      { success: false, errors: "User was alredy deleted"}
    else
      @user.soft_delete_user
      { success: true, message: "User deleted successfully!"}
    end
  end

  # restore_user
  def restore_user
    user = User.unscoped.find_by(slug: @target_param)
    if user.nil?
      return { errors: { user: "USer was not found!"}}
    end

    # check whether user was deleted
    deleted = user.user_deleted?
    unless deleted
      return { errors: { user: "USer was not deleted!"}}
    end
    user.restore_user
    { success: true, message: "User restored successfully!"}
  end

  private

  # normalize_update_password_param
  def normalize_update_password_param
    password_param = @params[:password]
    password_confirmation_param = @params[:password_confirmation]

    normalized = password_regex(password_param, password_confirmation_param)
    if normalized.is_a?(Hash) && normalized.key?(:errors)
      return normalized
    end

    normalized
  end

  # normalize_update_phone_param
  def normalize_update_phone_param
    phone_param = @params[:phone].to_s.gsub(/\s+/, '')

    if phone_param.present?

      # phone_format
      phone_format = phone_regex(phone_param)
      if phone_format.is_a?(Hash) && phone_format.key?(:errors)
        return phone_format
      end

      # phone should not exist
      existing = unique_phone_search(@users, phone_format, @user.id)
      if existing.is_a?(Hash) && existing.key?(:errors)
        return existing
      end

      phone_format

    end
  end

  # normalize_update_email_param
  def normalize_update_email_param
    email_param = @params[:email].to_s.gsub(/\s+/, '').downcase
    if email_param.present?

      # email_format
      email_format = email_regex(email_param)
      if email_format.is_a?(Hash) && email_format.key?(:errors)
        return email_format
      end

      # email_should not exist
      existing = unique_email_search(@users, email_format, @user.id)
      if existing.is_a?(Hash) && existing.key?(:errors)
        return existing
      end
      email_format
    end
  end

  # normalize_password_and_password_confirmation_param
  def normalize_password_and_password_confirmation_param

    password_param = @params[:password]
    password_confirmation_param = @params[:password_confirmation]

    normalized = password_regex(password_param, password_confirmation_param)
    if normalized.is_a?(Hash) && normalized.key?(:errors)
      return normalized
    end

    normalized

  end

  # normalize_phone_param
  def normalize_phone_param

    phone_param = @params[:phone].to_s.gsub(/\s+/, '')
    if phone_param.blank?
      return { errors: { phone: "Please input phone!"}}
    end

    # phone_format
    phone_format = phone_regex(phone_param)
    if phone_format.is_a?(Hash) && phone_format.key?(:errors)
      return phone_format
    end

    # phone should not exist
    existing = search_user_phone(@users, phone_format)
    if existing.is_a?(Hash) && existing.key?(:errors)
      return existing
    end

    phone_format
  end

  # normalize_email_param
  def normalize_email_param
    email_param = @params[:email].to_s.gsub(/\s+/, '').downcase
    if email_param.blank?
      return { errors: { email: "Please input email!"}}
    end

    # email_format
    email_format = email_regex(email_param)
    if email_format.is_a?(Hash) && email_format.key?(:errors)
      return email_format
    end

    # email should not exist
    existing = search_user_email(@users, email_param)
    if existing.is_a?(Hash) && existing.key?(:errors)
      return existing
    end

    email_format
  end
end
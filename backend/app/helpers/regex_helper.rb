module RegexHelper
  def email_regex(email_param)
    email_param = email_param.to_s.gsub(/\s+/, '').downcase

    email_format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    unless email_param.match?(email_format)
      return { errors: { email: "Invalid email format!"}}
    end

    email_param
  end

  def phone_regex(phone_param)
    phone_param = phone_param.to_s.gsub(/\s+/, '')

    unless phone_param.match?(/\A0(1|7)\d{8}\z/) || phone_param.match?(/\A254(1|7)\d{8}\z/)
      return { errors: { phone: "Invalid phone format!"}}
    end

    if phone_param.match?(/\A0(1|7)\d{8}\z/)
      phone_param = phone_param.sub(/\A(0)/, '254')
    end

    phone_param
    
  end

  def password_regex(password_param, password_confirmation_param)

    if password_param.present? && password_confirmation_param.blank?
      return { errors: { password_confirmation: "Please input password confirmation!"}}
    elsif password_param.blank? && password_confirmation_param.present?
      return { errors: { password: "Please input password!"}}
    elsif password_param.blank? && password_confirmation_param.blank?
      return { errors: { password: "Please input password!"}, password_confirmation: "Please input password confirmation!"}
    end

    unless password_param.length >= 8
      return { errors: { password: "Password should have at least 8 characters!"}}
    end

    unless password_param.match?(/\d/) && password_param.match?(/[a-z]/)
      return { errors: { password: "Password should have at both characters and digits!"}}
    end

    unless password_param == password_confirmation_param
      return { errors: { password_confirmation: "Password Mismatch!"}}
    end

    { password: password_param, password_confirmation: password_confirmation_param}
  end
end
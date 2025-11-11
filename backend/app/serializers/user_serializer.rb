class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :phone, :role, :generated_on

  def generated_on
    object.created_at&.strftime("%B %d, %Y")
  end

end

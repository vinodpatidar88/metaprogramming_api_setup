class User < ApplicationRecord
   has_secure_password
   enum :status, { inactive: 0, active: 1 }
   validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

   PERMITTED_PARAMS = [
      :password, 
      :password_confirmation, 
      :limit, 
      :page,
      :name,
      :user_name, 
      :email,
      :mobile_number,
      :status
   ]
end
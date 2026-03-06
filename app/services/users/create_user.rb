module Users
 class CreateUser
   def initialize(params)
     @params = params
   end

   def call
     create_users
   end

   def create_users
      User.create!(@params) 
   end
 end
end
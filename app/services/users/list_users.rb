module Users
  class ListUsers
    def initilalize(params)
      @params = params
    end

    def call
      get_list_users
    end

    def get_list_users
      User.all
    end
  end
end
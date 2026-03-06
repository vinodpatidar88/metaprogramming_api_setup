module Users
  class ListUsers
    def initialize(params)
      @limit = params[:limit] || 10
      @page = params[:page] || 1
    end

    def call
      @users = get_list_users
      return {
        data:  @users,
        meta: {
          current_page: @users.current_page,
          total_pages: @users.total_pages,
          total_count: @users.total_count
        }
      }
    end

    def get_list_users
      @lists = User.where(status: :active).page(@page).per(@limit)
    end
  end
end
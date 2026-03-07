module Posts
  class ListPosts
    def initialize(permitted_params)
  
      @limit = permitted_params[:limit] || 10
      @page = permitted_params[:page] || 1
    end

    def call
      posts = get_user_posts
      return {
        data: posts,
        meta: {
          current_page: posts.current_page,
          total_page: posts.total_pages,
          total_count: posts.total_count
        }
      }
    end

    def get_user_posts
      binding.pry
      Post.where(status: :active).includes(:user).page(@page).per(@limit)
    end
  end
end
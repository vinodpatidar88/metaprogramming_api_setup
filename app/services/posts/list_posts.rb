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
        # meta: {
        #   current_page: posts.current_page,
        #   total_page: posts.total_pages,
        #   total_count: posts.total_count
        # }
      }
    end

    def get_user_posts
      posts  = Post.includes(:user).where(status: :active)
      posts.map { |t| { title: t.title, subtitle: t.subtitle, created_at: t.created_at, updated_at: t.updated_at, images: t.images.map { |img| rails_blob_url(img) }, videos: t.videos.map { |vid| rails_blob_url(vid) } }}
    end
  end
end
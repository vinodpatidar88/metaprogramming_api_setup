module Posts
  class ListPosts
    def initialize(params)
      @params = params
    end

    def call
      get_user_posts
    end

    def get_user_post
      posts = Post.where(status: :active)
    end
  end
end
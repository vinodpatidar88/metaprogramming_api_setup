module Posts
  class CreatePosts
    def initialize(permitted_params)
      @params = permitted_params
    end

    def call
      post = create_post
      return {
        data: post
      }
    end

    def create_post
      binding.pry
      Post.create!(@params)
    end
  end
end
class Post < ApplicationRecord
  enum :status, { inactive: 0, active: 1, pending: 2 }
  belongs_to :user

  has_many_attached :images, dependent: :destroy
  has_many_attached :videos, dependent: :destroy

  PERMITTED_PARAMS = [
    :limit,
    :page,
    :user_id,
    :title,
    :subtitle,
    :url,
    :status,
  ].freeze
end
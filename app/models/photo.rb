class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :event

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :default, resize_to_fill: [800, 800]
  end

  validates :image,
    content_type: %w[image/jpeg image/png image/gif],
    size: { less_than: 5.megabytes }

  scope :persisted, -> { where 'id IS NOT NULL' }
end

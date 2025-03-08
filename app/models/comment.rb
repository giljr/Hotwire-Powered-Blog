class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true
  validates :user, presence: true
  
  broadcasts_to :post
end

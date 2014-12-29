class Relationship < ActiveRecord::Base
  # follower, followedはRelationshipモデルから見たUserモデルとの関係
  belongs_to :follower, class_name: "User"  # 1
  belongs_to :followed, class_name: "User"  # 2
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end

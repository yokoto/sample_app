class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # 与えられたユーザーがフォローしているユーザー達のマイクロポストを返す。
  # Relationship.followed_id ≒ User.id == Micropost.user_id
  def self.from_users_followed_by(user) 
	followed_user_ids = "SELECT followed_id FROM relationships
							WHERE follower_id = :user_id" 
	# Micropost.					
	where("user_id IN (#{followed_user_ids} ) OR user_id = :user_id",
		 user_id: user.id)  # user_id = フォローしているユーザー OR 与えられたユーザー。 ORは、２つの条件のどちらかを満たすものであれば結果として返す。
  end
end

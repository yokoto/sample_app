class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy  # 2つのモデルの間の「第3のモデル」(結合モデル)の介在
  has_many :followed_users, through: :relationships, source: :followed  # 自己結合
  # belongs_to :relationships

  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy  # has_many :relationshipsの逆
  has_many :followers, through: :reverse_relationships#, source: :follower  # 自己結合
  # belongs_to :reverse_relationships

  has_secure_password
  before_save { email.downcase! }
  # User生成のタイミングでコールバック
  before_create :create_remember_token 
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  # ログイン時はSessionHelpersから呼び出すことになるのでpublic
  # 16桁のランダムな文字列の作成
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # 同上
  # 記憶トークンの暗号化
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
	end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    # User生成時、before_createコールバックから呼び出す。
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end

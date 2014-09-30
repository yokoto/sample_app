class User < ActiveRecord::Base
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

  private

    # User生成時、before_createコールバックから呼び出す。
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end

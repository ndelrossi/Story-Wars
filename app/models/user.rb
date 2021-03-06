class User < ActiveRecord::Base
    has_many :friendships
    has_many :friends, through: :friendships
    has_many :votes, dependent: :destroy
    has_many :upvoted_chapters, through: :votes, source: :chapter
    has_many :chapters, dependent: :destroy
    has_many :stories, dependent: :destroy
    before_save { self.email = email.downcase }
    before_create :create_remember_token
    validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: true }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, length: { minimum: 6 }
    def User.new_remember_token
        SecureRandom.urlsafe_base64
    end

    def User.digest(token)
        Digest::SHA1.hexdigest(token.to_s)
    end

    def is_admin
        is_admin = false
    end

    private

        def create_remember_token
            self.remember_token = User.digest(User.new_remember_token)
        end
end

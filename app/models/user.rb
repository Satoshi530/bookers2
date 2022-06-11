class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
   # 与フォロー関係を通じてテーブル参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
  
  #自分がフォローされる(被フォロー)側の関係性

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  #被フォロー関係を通じてテーブルを参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_one_attached :profile_image


validates :email, presence:true
validates :name, presence:true, length: {minimum: 2, maximum: 20 }
validates :name, uniqueness: true
validates :introduction, length: {maximum: 50}


#フォローした時の処理
def follow(user_id)
  relationships.create(followed_id: user_id)
end

#フォロー外す時の処理
def unfollow(user_id)
  relationships.find_by(followed_id: user_id).destroy
end

#フォローしているか確認
def followed_by?(user)
  followings.include?(user)
end

def get_profile_image(width,height)
  unless profile_image.attached?
    file_path =Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io:File.open(file_path),filename:'default-image.jpg', content_type: 'image/jepg')
  end
    profile_image.variant(resize_to_limit:[width,height]).processed
end

end
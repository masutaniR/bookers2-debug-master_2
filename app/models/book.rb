class Book < ApplicationRecord
	belongs_to :user

	validates :title, presence: true
	validates :body, presence: true,
	                 length: {maximum: 200}
	has_many :book_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy

	def favorited_by?(user)
	  favorites.where(user_id: user.id).exists?
	end

	# 検索用メソッド
	def self.search_for(content, method)
	  if method == 'perfect'
	  	Book.where('title LIKE? OR body LIKE?', "#{content}", "#{content}")
	  elsif method == 'forward'
	  	Book.where('title LIKE? OR body LIKE?', "#{content}%", "#{content}%")
	  elsif method == 'backward'
	  	Book.where('title LIKE? OR body LIKE?', "%#{content}", "%#{content}")
	  else
	  	Book.where('title LIKE? OR body LIKE?', "%#{content}%", "%#{content}%")
	  end
	end
end

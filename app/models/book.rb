class Book < ApplicationRecord
	belongs_to :user

	validates :title, presence: true
	validates :body, presence: true,
	                 length: {maximum: 200}
	has_many :book_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy
	has_many :notifications, dependent: :destroy

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
	
	# いいね通知
	def create_notification_like(current_user)
	  temp = Notification.where(["visitor_id = ? and visited_id = ? and book_id = ? and action = ?", current_user.id, user_id, id, 'like'])
	  if temp.blank?
	  	notification = current_user.active_notifications.new(
	  		book_id: id,
	  		visited_id: user_id,
	  		action: 'like'
	  		)
	  	if notification.visitor_id == notification.visited_id
	  		notification.checked = true
	  	end
	  	notification.save if notification.valid?
	  end
	end
	
	# コメント通知
	def create_notification_comment(current_user, comment_id)
	  temp_ids = Comment.select(:user_id),where(book_id: id).where.not(user_id: current_user.id).distinct
	  temp_ids.each do |temp_id|
	    save_notification_comment(current_user, comment_id, temp_id['user_id'])
	  end
	  save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
	end
	
	def save_notification_comment(current_user, comment_id, visited_id)
	  notification = current_user.active_notifications.new(
	  	book_id: id,
	  	book_comment_id: comment_id,
	  	visited_id: visited_id,
	  	action: 'comment'
	  	)
	  if notification.visitor_id == notification.visited_id
	  	notification.checked = true
	  end
	  notification.save if notification.valid?
	end
end

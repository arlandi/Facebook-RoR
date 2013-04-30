class Friendship < ActiveRecord::Base
	belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  	belongs_to :user


	def self.exists?(user, friend)
		not find_by_user_id_and_friend_id(user, friend).nil?
	end

	def self.request(user, friend)
		unless user == friend or Friendship.exists?(user, friend)
			transaction do
				create(:user => friend, :friend => user, :status => 'requested')
				create(:user => user, :friend => friend, :status => 'pending')
			end
		end
	end

	def self.accept(user, friend)
		transaction do
			accepted_at = Time.now
			accept_one_side(user, friend, accepted_at)
			accept_one_side(friend, user, accepted_at)
			user.follow!(friend)
			friend.follow!(user)
		end
	end

	def self.breakup(user, friend)
		transaction do
			destroy(find_by_user_id_and_friend_id(user, friend))
			destroy(find_by_user_id_and_friend_id(friend, user))
		end
	end

	def self.accept_one_side(user, friend, accepted_at)
		request = find_by_user_id_and_friend_id(user, friend)
		request.status = 'accepted'
		request.accepted_at = accepted_at
		request.save!
	end

end

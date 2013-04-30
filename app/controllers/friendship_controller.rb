class FriendshipController < ApplicationController
	before_action :signed_in_user
	before_filter :setup_friends

	def index
		Friendship.request(@user,@friend)
		flash[:notice] = "Friend request sent."
		redirect_to url_for(@friend)
	end

	def setup_friends
		@user = User.find(@current_user.id)
		@friend = User.find(params[:id])
	end

	def accept
		if @user.requested_friends.include?(@friend)
			Friendship.accept(@user, @friend)
			flash[:notice] = "You have accepted #{@friend.name}'s friend request."
		else
			flash[:notice] = "No friendship request from #{@friend.name}."
		end
		redirect_to root_path
	end

end

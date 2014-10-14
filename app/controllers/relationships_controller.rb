class RelationshipsController < ApplicationController
	before_action :signed_in_user

	respond_to :html, :js

	def create
		@user = User.find(params[:relationship][:followed_id])  # これらフォローするユーザーの取り出し
		current_user.follow!(@user)
		# respond_to do |format|  #  ページを移動しない
		#	  format.html { redirect_to @user }
		#	  format.js
		# end
		respond_with @user  # アクションに対応するテンプレートを探して表示
	end

	def destroy
		@user = Relationship.find(params[:id]).followed  # フォローしているユーザーの取り出し
		current_user.unfollow!(@user)
		# respond_to do |format|
		#	  format.html { redirect_to @user }
		#	  format.js
		# end
		respond_with @user
	end
end

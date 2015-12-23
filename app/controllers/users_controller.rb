require 'paypal_permission'

class UsersController < ApplicationController
  include ActivityManager

  before_action :authenticate_user!
  before_action :set_user, only: [:show, :follow, :unfollow, :payment_setup, :request_access] 

  def index
    if current_user.author? || current_user.user?
      @users = Author.all
    else
      @users = User.all 
    end
  end

  def search 
    @users = Author.where('name iLIKE :q OR email iLIKE :q', q: "%#{params[:q].to_s.downcase}%")
  end
  
  def follow
    current_user.follow!(@user) 

    redirect_to user_path(@user), flash: { notice: 'User has been followed' }
  end
  
  def unfollow
    current_user.unfollow!(@user) 
    
    redirect_to user_path(@user), flash: { error: 'User has been unfollowed' }
  end

  def view_notifications
    current_user.unviewed_notifications.update_all(viewed: true)
    
    render json: current_user.unviewed_notifications.count
  end
  

private
  def set_user
    @user = User.find params[:id]
  end
end

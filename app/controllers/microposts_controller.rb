class MicropostsController < ApplicationController
  before_action :authenticate_user!
  
  include ActivityManager
  
  def create
    micropost = current_user.microposts.new micropost_params
    
    if micropost.save
      set_activity(micropost, followers)
      
      redirect_to user_path(current_user), flash: { notice: 'Micropost has been created' }
    else
      redirect_to user_path(current_user), flash: { error: 'Failed to create micropost' }
    end
  end

private
  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def followers
    if current_user.needs_subscription?
      current_user.followers.select do |follower|
        current_user.subscribed?(follower) 
      end
    else
      current_user.followers
    end
  end
end

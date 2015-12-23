module UsersHelper
  def gravatar_for(email, options = {})
    gravatar_id = Digest::MD5::hexdigest(email.downcase)
    
    "https://secure.gravatar.com/avatar/#{gravatar_id}"
  end

  def can_view_post?(author)
    viewing_permission = (author.needs_subscription? && author.paypal_email.present?) ? current_user.followed?(author) && author.subscribed?(current_user) : current_user.followed?(author)
    viewing_permission || current_user.admin? || current_user == author 
  end

  def render_custom_activity(activity)
    render 'activities/' + activity.key.gsub('.', '/'), activity: activity
  end
end

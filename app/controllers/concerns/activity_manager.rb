module ActivityManager
  extend ActiveSupport::Concern

  def set_activity(object, receivers, key = nil)
    key = "#{object.class.to_s.downcase}.#{params[:action]}" unless key.present?
    
    receivers.each do |receiver|
      PublicActivity::Activity.create(trackable: object,
                                      owner:     current_user,
                                      recipient: receiver, 
                                      key:       key)
    end
  end

  def delete_activity(object, recipients)
    PublicActivity::Activity.where(trackable: object, recipient: recipients).delete_all
  end

  def table
    PublicActivity::Activity.arel_table
  end

end



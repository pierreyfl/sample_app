module HasActivities 
  extend ActiveSupport::Concern

  included do
    has_many :activities, as: :owner, class_name: PublicActivity::Activity, dependent: :destroy
    has_many :histories, as: :trackable, class_name: PublicActivity::Activity, dependent: :destroy
    has_many :notifications, -> { order('created_at DESC') }, as: :recipient, class_name: PublicActivity::Activity, dependent: :destroy
  end
end

class LeadObserver < ActiveRecord::Observer
  def after_create(lead)
    LeadNotifier.deliver_lead_notification(lead)
  end
end

class LeadNotifier < ActionMailer::Base
  def lead_notification(lead)
    recipients      "info@brickellmiamicondos.com"
    from            "Leads notifier <leads@brickellmiamicondos.com>"
    sent_on         Time.now
    content_type    "text/html"
    subject         'A new lead has been created'
    body[:lead] = lead
  end
  
end

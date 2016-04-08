class Notifier < ActionMailer::Base

  def multipart_alternative(recipient, name, sent_at = Time.now)
    @subject    = 'Something for everyone'    
    @recipients = recipient
    @from       = 'info@brickellmiamicondos.com'
    @sent_on    = sent_at
    content_type "multipart/alternative"
    # @headers    = {}
    
    part :content_type => "text/plain",
    	:body => render_message("multipart_alternative_plain", :name => name)
    
    part :content_type => "text/html",
    	:body => render_message("multipart_alternative", :name => name)
  end
end

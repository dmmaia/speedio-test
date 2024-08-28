require "./"+ File.dirname(__FILE__) + "/environment.rb"

set :output, "#{path}/log/cron.log" #logs

@automations = Automation.where( sent_at: nil, :programmed_to => { :$lte => Time.now.advance(minutes: 1440) } )
@automations.each do |automation|
  every 1.minutes do
    if (automation.programmed_to - Time.now) / 1.minutes < 1

      company = Company.find(automation.company_id)
      
      case automation.tipo
      when "email"
        runner "Communicate.send_mail("+automation.company_id+", "+automation.message+", "+company.user_id+")"
      when "linkedin_message"
        runner "Communicate.send_linkedin_message("+automation.company_id+", "+automation.message+", "+company.user_id+")"
      when "linkedin_connection"
        runner "Communicate.send_linkedin_connection("+automation.company_id+", "+automation.message+", "+company.user_id+")"
      end

      automation.update(sent_at:Time.now)
    end
  end
end
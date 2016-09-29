require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '5s' do
  Monitoring::Report.publish
end

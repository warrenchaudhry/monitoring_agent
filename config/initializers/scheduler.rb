require 'rufus-scheduler'
require_dependency '../lib/monitoring/report'
scheduler = Rufus::Scheduler.new

scheduler.every '5s' do
  Monitoring::Report.publish
end

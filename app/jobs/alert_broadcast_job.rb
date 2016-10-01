class AlertBroadcastJob < ApplicationJob
  queue_as :default

  def perform(data)
    $redis.set("alert", data)
    ActionCable.server.broadcast "alerts_channel",
                                 message: render_message(data)

  end
  private

  def render_message(data)
    "Your CPU usage at #{data['time'].to_datetime.to_s(:long)} is #{data['value']}%"
  end

end

class MetricsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(metrics)
    $redis.set("metrics", metrics)
    metrics = JSON.parse(metrics)
    ActionCable.server.broadcast "metrics_channel",
                                 message: render_message(metrics)
                         
  end
  private

  def render_message(metrics)
    MetricsController.render partial: 'metrics/metrics', locals: {metrics: metrics}
  end
end

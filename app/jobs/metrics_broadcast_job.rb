class MetricsBroadcastJob < ApplicationJob
  require 'rest-client'
  queue_as :default

  def perform(metrics)
    $redis.set("metrics", metrics)
    metrics = JSON.parse(metrics)
    push_data(metrics)
    ActionCable.server.broadcast "metrics_channel",
                                 message: render_message(metrics)

  end
  private

  def render_message(metrics)
    MetricsController.render partial: 'metrics/metrics', locals: {metrics: metrics}
  end

  def push_data(metrics)
    url = ENV['METRICS_URL']
    if (url =~ URI::regexp && ENV['SERVER_TOKEN'])
      uri = URI.join(url, 'api/v1/metrics')
      RestClient.post uri.to_s, {metric: metrics}, content_type: :json, accept: :json, authorization: ENV['SERVER_TOKEN']
    end
  end
end

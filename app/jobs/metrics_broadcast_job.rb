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
    url = ENV['server_url']
    if (url =~ URI::regexp && ENV['server_token'])
      uri = URI.join(url, 'api/v1/metrics')
      RestClient.post uri.to_s, {metric: metrics}, content_type: :json, accept: :json, authorization: ENV['server_token']
    end
  end
end

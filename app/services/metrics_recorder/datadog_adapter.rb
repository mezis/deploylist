require 'dogapi'

class MetricsRecorder::DatadogAdapter
  def initialize
    @client = Dogapi::Client.new(ENV.fetch('DATADOG_API_KEY'))
  end

  def track(label, value, at: Time.now.utc)
    @client.emit_point(
      _label(label),
      value.to_f,
      host: _host,
      device: 'deploylist'
    )
  end

  private

  def _label(name)
    safe_label = name.downcase.gsub(/[^a-z]+/, '_')
    ENV.fetch("DATADOG_LABEL_#{safe_label.upcase}", safe_label)
  end

  def _host
    @_host ||= ENV.fetch('HEROKU_APP').downcase.gsub(/[^a-z]+/, '_')
  end
end

require 'singleton'
require 'forwardable'

class MetricsRecorder
  include Singleton
  extend Forwardable

  def intitialize
    adapter_type = ENV.fetch('METRICS_SERVICE', '')
    klass = case adapter_type.downcase
            when ''
              require 'metrics_recorder/null_adapter'
              NullAdapter
            when 'datadog'
              require 'metrics_recorder/datadog_adapter'
              DatadogAdapter
            else
              raise ArgumentError, "Unknown metrics adapter '#{adapter_type}'"
            end

    @adapter = klass.new
  end

  # @param label [String] The label of the metric
  # @param value [#to_f] The value of the metric at this time
  # @param :at [Time] (Time.now.utc) The time at which the value was set
  def_delegator :@adapter, :track
end



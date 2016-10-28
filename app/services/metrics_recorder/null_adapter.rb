class MetricsRecorder::NullAdapter
  def track(_label, _value, at: Time.now.utc)
    # No action
  end
end

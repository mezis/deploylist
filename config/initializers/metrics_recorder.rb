# Load the Metrics recorder instance at startup, rather than at first metric
MetricsRecorder.instance.use_adapter(ENV.fetch('METRICS_SERVICE', ''))

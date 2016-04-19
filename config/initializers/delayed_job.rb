# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.sleep_delay = 5
Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 10.minutes
Delayed::Worker.read_ahead = 1
Delayed::Worker.default_queue_name = 'default'


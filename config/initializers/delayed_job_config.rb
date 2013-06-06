Delayed::Worker.max_attempts = 3
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.default_queue_name = 'default'
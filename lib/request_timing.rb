class RequestTiming
  def initialize(app)
    @app = app
  end

  def call(env)
    received = Time.now.to_f
    start = (env["HTTP_X_REQUEST_START"] && env["HTTP_X_REQUEST_START"].respond_to?(:to_f)) ? env["HTTP_X_REQUEST_START"].to_f : received
    queued = (received - start) * 1000
    queued = 0 if queued < 0
    @app.call(env.merge!({
      "request_timing.start" => start,
      "request_timing.received" => received,
      "request_timing.queued" => queued
    }))
  end

end
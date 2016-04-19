class DeploysController < ApplicationController
  include ActionController::Live

  protect_from_forgery with: :exception, except: [ :deploy ]

  def index
    @deploys = Deploy.production.includes(:stories).limit(50)
  end

  def all
    @deploys = Deploy.production.includes(:stories)
    render :index
  end

  def ping
    render text: 'pong'
  end

  def deploy
    unless Delayed::Job.exists?
      ImportDeploysJob.perform_later
    end
    render nothing: true
  end

  def denied
    render text: "No access", status: 403
  end

  private

  def seconds_taken_to(&blk)
    before = Time.now
    yield
    after = Time.now
    (after - before).to_i
  end
end

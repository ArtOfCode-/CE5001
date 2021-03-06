class AdminController < ApplicationController
  before_action :require_admin

  def db_dump
    DatabaseDumpJob.perform_later
    # flash[:success] = 'A database dump task has been queued'
    respond_to do |format|
      format.json { render json: {status: 'success'}, status: :ok }
      format.html { redirect_back fallback_location: comment_path }
    end
  end

  def past_reviews
    @post_reviews = PostReview.where(user:current_user).where.not(review_completed: nil).order(review_completed: :asc)
    @skips = PostReview.where(user:current_user).where(review_completed: nil).count
  end

  private

  def require_admin
    unless current_user && current_user.admin
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

  def current_user
    if session[:user_id]
       User.find(session[:user_id])
    else
      nil
    end
  end
end

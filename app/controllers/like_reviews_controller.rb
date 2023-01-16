class LikeReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def create
    @like_review = current_user.like_reviews.create(review_id: params[:review_id])
    render "create_and_destroy"
  end

  def destroy
    @like_review = LikeReview.find(params[:id])
    @like_review.destroy
    render "create_and_destroy"
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end
end

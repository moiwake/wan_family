class LikeReviewsController < ApplicationController
  def create
    @like_review = current_user.like_reviews.create(review_id: params[:review_id])
    set_review
    render "create_and_destroy"
  end

  def destroy
    @like_review = LikeReview.find(params[:id])
    @like_review.destroy
    set_review
    render "create_and_destroy"
  end

  private

  def set_review
    @review = @like_review.review
  end
end

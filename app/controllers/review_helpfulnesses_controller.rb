class ReviewHelpfulnessesController < ApplicationController
  before_action :set_review

  def create
    @review_helpfulness = @review.review_helpfulnesses.create(user: current_user)
    render "create_and_destroy"
  end

  def destroy
    @review_helpfulness = ReviewHelpfulness.find(params[:id])
    @review_helpfulness.destroy
    render "create_and_destroy"
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end
end

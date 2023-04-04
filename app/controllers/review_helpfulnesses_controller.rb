class ReviewHelpfulnessesController < ApplicationController
  def create
    @review_helpfulness = current_user.review_helpfulnesses.create(review_id: params[:review_id])
    set_review
    render "create_and_destroy"
  end

  def destroy
    @review_helpfulness = ReviewHelpfulness.find(params[:id])
    @review_helpfulness.destroy
    set_review
    render "create_and_destroy"
  end

  private

  def set_review
    @review = @review_helpfulness.review
  end
end

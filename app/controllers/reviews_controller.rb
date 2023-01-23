class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_spot, except: [:show]
  before_action :set_like_review, only: [:show]

  def index
    @reviews = ReviewsForSpotQuery.call(parent_record: @spot, params: params)
  end

  def new
    @review_poster_form = ReviewPosterForm.new
  end

  def create
    @review_poster_form = ReviewPosterForm.new(attributes: form_params)

    if @review_poster_form.save
      flash[:notice] = "新規のレビューを投稿しました。"
      redirect_to spot_review_path(@spot, @review_poster_form.review)
    else
      render "new"
    end
  end

  def show
    @review = Review.find(params[:id])
    @blobs = ImageBlobsQuery.call(parent_image: @review.image, variant: true)
  end

  def edit
    @review = Review.find(params[:id])
    @review_poster_form = ReviewPosterForm.new(review: @review, image: @review.image)
  end

  def update
    @review = Review.load_variant_image.find(params[:id])
    @review_poster_form = ReviewPosterForm.new(attributes: form_params, review: @review, image: @review.image)

    if @review_poster_form.save && delete_image_file
      flash[:notice] = "#{@spot.name}のレビューを変更しました。"
      redirect_to spot_review_path(@spot, @review_poster_form.review)
    else
      render "edit"
    end
  end

  def destroy
    @review = Review.load_variant_image.find(params[:id])
    @review.destroy
    flash[:notice] = "#{@spot.name}のレビュー「#{@review.title}」を削除しました。"
    redirect_to users_review_index_path
  end

  private

  def form_params
    review_params = [:user_id, :spot_id, :dog_score, :human_score, :comment, :title]
    params.require(:review_poster_form).permit(
      review_attributes: review_params, image_attributes: [:user_id, :spot_id, :review_id, files: []]
    )
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def set_like_review
    if current_user
      @like_review = LikeReview.find_by(user_id: current_user.id, review_id: params[:id])
    end
  end

  def delete_image_file
    file_ids = params.dig(:review_poster_form, :image_attributes, :file_ids)

    if file_ids
      file_ids.each do |file_id|
        removed_file = @review.image.files.find { |file| file.id == file_id.to_i }
        removed_file.purge
      end
    end

    return true
  end
end

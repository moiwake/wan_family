class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_spot

  def index
    @reviews = Review.where(spot_id: params[:spot_id]).includes_image.includes(:user)
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
    @review = Review.includes_image.find(params[:id])
  end

  def edit
    @review = Review.includes_image.find(params[:id])
    @review_poster_form = ReviewPosterForm.new(review: @review, image: @review.image)
  end

  def update
    @review = Review.includes_image.find(params[:id])
    @review_poster_form = ReviewPosterForm.new(attributes: form_params,review: @review, image: @review.image)

    if @review_poster_form.save && delete_image_file
      flash[:notice] = "#{@spot.name}のレビューを変更しました。"
      redirect_to spot_review_path(@spot, @review_poster_form.review)
    else
      render "edit"
    end
  end

  def destroy
    @review = Review.includes_image.includes(:spot).find(params[:id])
    @review.destroy
    flash[:notice] = "#{@review.spot.name}のレビュー「#{@review.title}」を削除しました。"
    redirect_to users_review_index_path
  end

  private

  def form_params
    review_params = [:user_id, :spot_id, :dog_score, :human_score, :comment, :title]
    params.require(:review_poster_form).permit(review_attributes: review_params, image_attributes: [:user_id, :spot_id, :review_id, files: []])
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def delete_image_file
    if params[:review_poster_form][:image_attributes]
      files_blob_ids_params = params[:review_poster_form][:image_attributes][:files_blob_ids]

      files_blob_ids_params.each do |file_id|
        removed_file = @review.image.files.find { |file| file.id == file_id.to_i }
        removed_file.purge
      end
    end

    return true
  end
end

class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_spot
  before_action :set_favorite_spot, :set_tags_user_put_on_spot, :set_review_helpfulness, only: [:index]

  def index
    @reviews = Reviews::OrderedQuery.call(parent_record: @spot, order_params: params)
              .page(params[:page])
              .load_all_associations
  end

  def new
    @review_poster_form = ReviewPosterForm.new
  end

  def create
    @review_poster_form = ReviewPosterForm.new(attributes: form_params)

    if @review_poster_form.save
      flash[:notice] = "レビューを投稿しました。"
      redirect_to spot_reviews_path(@spot)
    else
      render "new"
    end
  end

  def edit
    @review = Review.find(params[:id])
    @review_poster_form = ReviewPosterForm.new(review: @review)
  end

  def update
    @review = Review.load_active_storage_associations.find(params[:id])
    @review_poster_form = ReviewPosterForm.new(attributes: form_params, review: @review)

    if @review_poster_form.save && delete_image_file
      flash[:notice] = "#{@spot.name}のレビューを変更しました。"
      redirect_to users_mypage_review_index_path
    else
      render "edit"
    end
  end

  def destroy
    @review = Review.load_active_storage_associations.find(params[:id])
    @review.destroy
    flash[:notice] = "#{@spot.name}のレビュー「#{@review.title}」を削除しました。"
    redirect_to users_mypage_review_index_path
  end

  private

  def form_params
    review_params = [:user_id, :spot_id, :dog_score, :human_score, :comment, :title, :visit_date]
    params.require(:review_poster_form).permit(
      review_attributes: review_params, image_attributes: [:user_id, :spot_id, :review_id, files: []]
    )
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def set_review_helpfulness
    if current_user
      @review_helpfulness = ReviewHelpfulness.find_by(user_id: current_user.id, review_id: params[:id])
    end
  end

  def set_favorite_spot
    if current_user.present?
      @favorite_spot = current_user.favorite_spots.find_by(spot_id: @spot.id)
    end
  end

  def set_tags_user_put_on_spot
    if current_user.present?
      @tags_user_put_on_spot = SpotTag.get_tags_user_put_on_spot(user_id: current_user.id, spot_id: @spot.id)
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

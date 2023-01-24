module ReviewHelper
  def get_files_for_edit(review:)
    if review.present? && review.persisted?
      set_default_files(files: review.image.reload.files)
    else
      nil
    end
  end

  def set_default_files(files:)
    files.eager_load(:blob).order("blob.created_at desc, blob.id desc")
  end
end

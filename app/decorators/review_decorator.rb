class ReviewDecorator < Draper::Decorator
  delegate_all

  def get_files_ordered_by_blob_creation_date
    if object.persisted? && object.reload.image.present?
      object.image.files.eager_load(:blob).order("blob.created_at desc, blob.id desc")
    else
      []
    end
  end
end

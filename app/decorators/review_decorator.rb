class ReviewDecorator < Draper::Decorator
  delegate_all

  def get_files_for_edit
    if object.present? && object.persisted?
      object.image.reload.files.eager_load(:blob).order("blob.created_at desc, blob.id desc")
    else
      nil
    end
  end
end

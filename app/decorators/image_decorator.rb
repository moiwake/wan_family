class ImageDecorator < Draper::Decorator
  delegate_all

  def reject_invalid_files
    object.default_files.reject { |file| file.id == nil }
  end
end

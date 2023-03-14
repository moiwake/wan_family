Image.all.reverse_each.with_index do |image, i|
  LikeImage.seed do |s|
    s.user_id = i + 1
    s.image_id = image.id
    s.blob_id = image.files.blobs[0].id
  end
end

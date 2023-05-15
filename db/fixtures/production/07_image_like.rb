Image.all.reverse_each.with_index do |image, i|
  ImageLike.seed do |s|
    s.id = i + 1
    s.user_id = i + 1
    s.image_id = image.id
    s.blob_id = image.files_blobs[0].id
  end
end

User.first(10).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 1
    s.user_id = user.id
    s.image_id = 10
    s.blob_id = Image.find(10).files_blobs[0].id
  end
end

User.first(9).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 11
    s.user_id = user.id
    s.image_id = 9
    s.blob_id = Image.find(9).files_blobs[0].id
  end
end

User.first(8).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 20
    s.user_id = user.id
    s.image_id = 8
    s.blob_id = Image.find(8).files_blobs[0].id
  end
end

User.first(7).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 28
    s.user_id = user.id
    s.image_id = 7
    s.blob_id = Image.find(7).files_blobs[0].id
  end
end

User.first(6).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 35
    s.user_id = user.id
    s.image_id = 6
    s.blob_id = Image.find(6).files_blobs[0].id
  end
end

User.first(5).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 41
    s.user_id = user.id
    s.image_id = 5
    s.blob_id = Image.find(5).files_blobs[0].id
  end
end

User.first(4).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 46
    s.user_id = user.id
    s.image_id = 4
    s.blob_id = Image.find(4).files_blobs[0].id
  end
end

User.first(3).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 50
    s.user_id = user.id
    s.image_id = 3
    s.blob_id = Image.find(3).files_blobs[0].id
  end
end

User.first(2).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 53
    s.user_id = user.id
    s.image_id = 2
    s.blob_id = Image.find(2).files_blobs[0].id
  end
end

User.first(1).each_with_index do |user, i|
  ImageLike.seed do |s|
    s.id = i + 55
    s.user_id = user.id
    s.image_id = 1
    s.blob_id = Image.find(1).files_blobs[0].id
  end
end

dummmy_image_blob_ary = [
  ["dogrun0", "dogrun1", "dogrun2"],
  ["park0", "park1", "park2"],
  ["cafe0", "cafe1"],
  ["hotel0", "hotel1", "hotel2", "hotel3", "hotel4"],
  ["wearshop0", "wearshop1"],
  ["amusement_park0", "amusement_park1", "amusement_park2", "amusement_park3"],
  ["cinema0"],
  ["seaside_cafe0", "seaside_cafe1", "seaside_cafe2"],
  ["lodge0", "lodge1"],
  ["flower_garden0", "flower_garden1", "flower_garden2"],
]

dummmy_image_blob_ary.each_with_index do |image_blobs, i|
  ary = image_blobs.reduce([]) do |ary, image_blob|
    ary << { io: File.open(Rails.root.join("db/fixtures/development/images/#{i}/#{image_blob}.jpg")), filename: "#{image_blob}.jpg", metadata: { identified: true, width: 1500, height: 1096, analyzed: true } }
  end

  Image.all[i].files.attach(ary)
end

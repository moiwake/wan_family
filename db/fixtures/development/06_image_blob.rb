dummmy_filename_ary = [
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

dummmy_filename_ary.each_with_index do |filenames, i|
  blob_ary = filenames.reduce([]) do |ary, filename|
    ary << {
      io: File.open(Rails.root.join("db/fixtures/development/images/#{i}/#{filename}.jpg")),
      filename: "#{filename}.jpg",
      metadata: { identified: true, width: 1500, height: 1096, analyzed: true },
    }
  end

  Image.all[i].files.attach(blob_ary)
end

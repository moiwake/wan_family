require 'rails_helper'

RSpec.describe "ImagesSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  let!(:image_0) { create(:image, :attached, spot_id: spot.id) }
  let!(:image_1) { create(:image, :attached_1, spot_id: spot.id) }
  let!(:image_2) { create(:image, :attached_2, spot_id: spot.id) }

  let!(:likes_for_most_liked_file) { create_list(:image_like, 3, image_id: image_1.id, blob_id: most_liked_file.blob.id) }
  let!(:likes_for_second_liked_file) { create_list(:image_like, 2, image_id: image_2.id, blob_id: second_liked_file.blob.id) }
  let(:most_liked_file) { image_1.files.last }
  let(:second_liked_file) { image_2.files.first }

  let(:filenames) do
    filenames_0 = image_0.files.map { |file| file.filename.to_s }
    filenames_1 = image_1.files.map { |file| file.filename.to_s }
    filenames_2 = image_2.files.map { |file| file.filename.to_s }
    filenames = filenames_0.push(filenames_1, filenames_2).flatten
  end
  let(:filenames_desc) { filenames.reverse }
  let(:filenames_asc) { filenames }
  let(:filenames_image_like) do
    most_liked_filename = most_liked_file.filename.to_s
    second_liked_filename = second_liked_file.filename.to_s
    not_liked_files = filenames_desc.excluding(most_liked_filename, second_liked_filename)
    [most_liked_filename, second_liked_filename].push(not_liked_files).flatten
  end

  describe "スポットに投稿されたすべての画像一覧ページ" do
    before { visit spot_images_path(spot.id) }

    it "投稿されたすべての画像が、作成日（同じ場合はID）の降順に表示される" do
      filenames_desc.each_with_index do |filename, i|
        expect(page.all("img")[i][:src]).to include(filename)
      end
    end

    it "画像を作成日（同じ場合はID）の降順表示にできる" do
      click_link "新しい順"

      filenames_desc.each_with_index do |filename, i|
        expect(page.all("img")[i][:src]).to include(filename)
      end
    end

    it "画像を作成日（同じ場合はID）の昇順表示にできる" do
      click_link "古い順"

      filenames_asc.each_with_index do |filename, i|
        expect(page.all("img")[i][:src]).to include(filename)
      end
    end

    it "画像をCute（いいね）の多い順に、Cuteが付いていないときは作成日（同じ場合はID）の降順に表示できる" do
      click_link "Cuteが多い順"

      filenames_image_like.each_with_index do |filename, i|
        expect(page.all("img")[i][:src]).to include(filename)
      end
    end

    it "画像が詳細ページへのリンクとなっている" do
      [image_0, image_1, image_2].reverse_each do |image|
        image.files.blobs.reverse_each do |blob|
          expect(find("#image-list")).to have_link(href: spot_image_path(spot, image, blob_id: blob.id))
        end
      end
    end

    it "スポット詳細ページへのリンクがある" do
      expect(page).to have_link("#{spot.name}", href: spot_path(spot.id))
    end
  end

  describe "画像詳細ページ", js: true do
    let(:displayed_file) { second_liked_file }
    let(:displayed_filename) { displayed_file.filename.to_s }

    before { visit spot_images_path(spot) }

    describe "拡大画像の表示" do
      before { find("img[src$='#{displayed_filename}']").click }

      it "ページ遷移しない" do
        expect(current_path).to eq(spot_images_path(spot))
      end

      it "拡大した画像が表示される" do
        within("#image-overlay") do
          expect(find("#enlarged-image")[:src]).to include(displayed_filename)
        end
      end

      it "バツ印アイコンをクリックすると、拡大画像の表示が消える" do
        find(".fa-xmark").click
        expect(page).not_to have_selector("#enlarged-image")
      end
    end

    describe "表示画像の変更" do
      context "表示画像が一覧ページの１番目、または最後の画像ではないとき" do
        context "一覧ページを新しい順で表示している場合" do
          let(:prev_filename) { filenames_desc[filenames_desc.index(displayed_filename) + 1] }
          let(:next_filename) { filenames_desc[filenames_desc.index(displayed_filename) - 1] }

          before do
            click_link "新しい順"
            find("img[src$='#{displayed_filename}']").click
          end

          it "右矢印をクリックすると、拡大表示の画像が表示順の１つ前の画像に変わる" do
            find(".fa-chevron-right").click

            within("#image-overlay") do
              expect(find("#enlarged-image")[:src]).not_to include(displayed_filename)
              expect(find("#enlarged-image")[:src]).to include(prev_filename)
            end
          end

          it "左矢印をクリックすると、拡大表示の画像が表示順の１つ先の画像に変わる" do
            find(".fa-chevron-left").click

            within("#image-overlay") do
              expect(find("#enlarged-image")[:src]).not_to include(displayed_filename)
              expect(find("#enlarged-image")[:src]).to include(next_filename)
            end
          end
        end

        context "一覧ページを古い順で表示している場合" do
          let(:prev_filename) { filenames_asc[filenames_asc.index(displayed_filename) + 1] }
          let(:next_filename) { filenames_asc[filenames_asc.index(displayed_filename) - 1] }

          before do
            click_link "古い順"
            find("img[src$='#{displayed_filename}']").click
          end

          it "右矢印をクリックすると、拡大表示の画像が表示順の１つ前の画像に変わる" do
            find(".fa-chevron-right").click

            within("#image-overlay") do
              expect(find("#enlarged-image")[:src]).not_to include(displayed_filename)
              expect(find("#enlarged-image")[:src]).to include(prev_filename)
            end
          end

          it "左矢印をクリックすると、拡大表示の画像が表示順の１つ先の画像に変わる" do
            find(".fa-chevron-left").click

            within("#image-overlay") do
              expect(find("#enlarged-image")[:src]).not_to include(displayed_filename)
              expect(find("#enlarged-image")[:src]).to include(next_filename)
            end
          end
        end

        context "一覧ページをCuteが多い順で表示している場合" do
          let(:prev_filename) { filenames_image_like[filenames_image_like.index(displayed_filename) + 1] }
          let(:next_filename) { filenames_image_like[filenames_image_like.index(displayed_filename) - 1] }

          before do
            click_link "Cuteが多い順"
            find("img[src$='#{displayed_filename}']").click
          end

          it "右矢印をクリックすると、拡大表示の画像が表示順の１つ前の画像に変わる" do
            find(".fa-chevron-right").click

            within("#image-overlay") do
              expect(find("#enlarged-image")[:src]).not_to include(displayed_filename)
              expect(find("#enlarged-image")[:src]).to include(prev_filename)
            end
          end

          it "左矢印をクリックすると、拡大表示の画像が表示順の１つ先の画像に変わる" do
            find(".fa-chevron-left").click

            within("#image-overlay") do
              expect(find("#enlarged-image")[:src]).not_to include(displayed_filename)
              expect(find("#enlarged-image")[:src]).to include(next_filename)
            end
          end
        end
      end

      context "表示画像が一覧ページの１番目の画像であるとき" do
        it "左矢印がない" do
          page.all("img").first.click
          expect(page).not_to have_selector(".fa-chevron-left")
        end
      end

      context "表示画像が一覧ページの最後の画像であるとき" do
        it "右矢印がない" do
          page.all("img").last.click
          expect(page).not_to have_selector(".fa-chevron-right")
        end
      end
    end
  end
end

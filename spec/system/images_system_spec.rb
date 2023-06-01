require 'rails_helper'

RSpec.describe "ImagesSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot, impressions_count: 2) }
  let!(:image_0) { create(:image, :attached, spot: spot) }
  let!(:image_1) { create(:image, :attached_1, spot: spot) }
  let!(:filenames) { ActiveStorage::Blob.pluck(:filename) }
  let!(:filenames_desc) { filenames.reverse }
  let!(:filenames_asc) { filenames }
  let!(:filenames_image_like) { [most_liked_blob, second_liked_blob, image_1.files_blobs[0], image_0.files_blobs[0]].pluck(:filename) }
  let(:most_liked_blob) { image_1.files_blobs[1] }
  let(:second_liked_blob) { image_0.files_blobs[1] }

  before do
    create_list(:image_like, 3, image: image_1, blob_id: most_liked_blob.id)
    create_list(:image_like, 2, image: image_0, blob_id: second_liked_blob.id)
  end

  describe "スポットに投稿されたすべての画像一覧ページ" do
    before { visit spot_images_path(spot) }

    describe "画像の表示" do
      it "画像が詳細ページへのリンクとなっている" do
        Image.all.each do |image|
          image.files_blobs.each do |blob|
            expect(find(".image-list-wrap")).to have_link(href: spot_image_path(spot, image, image_blob_id: blob.id))
          end
        end
      end
    end

    describe "画像の表示順序" do
      shared_examples "画像の表示順序" do
        it "画像が指定した順序で表示される" do
          within(".image-list-wrap") do
            ordered_filenames.each_with_index do |filename, i|
              expect(page.all("img")[i][:src]).to include(filename)
            end
          end
        end
      end

      context "表示の順番を指定していないとき" do
        let(:ordered_filenames) { filenames_desc }

        it_behaves_like "画像の表示順序"
      end

      context "表示を新しい順にしたとき" do
        let(:ordered_filenames) { filenames_desc }

        before { click_link "新しい順" }

        it_behaves_like "画像の表示順序"
      end

      context "表示を古い順にしたとき" do
        let(:ordered_filenames) { filenames_asc }

        before { click_link "古い順" }

        it_behaves_like "画像の表示順序"
      end

      context "表示をいいねが多い順にしたとき" do
        let(:ordered_filenames) { filenames_image_like }

        before { click_link "いいねが多い順" }

        it_behaves_like "画像の表示順序"
      end
    end

    describe "ページヘッダーの表示" do
      include_context "ページヘッダーの表示", "spot_images_path"
      include_context "画像一覧ページのページヘッダーのタブ"
    end

    describe "ページネーション" do
      context "表示画像が指定個数以上のとき" do
        let!(:per_page) { stub_const("Image::PER_PAGE", 3) }

        before { visit spot_images_path(spot) }

        it "ページ割りされる" do
          expect(find(".image-list-wrap").all("img").length).to eq(3)
          expect(page).to have_selector(".pagination")
        end
      end
    end
  end

  describe "画像詳細", js: true do
    let(:displayed_filename) { displayed_file.filename.to_s }

    before { visit spot_images_path(spot) }

    describe "拡大画像の表示" do
      let(:displayed_file) { image_0.files_blobs[1] }

      before do
        sleep 0.2
        find("a[href$='#{displayed_file.id}']").click
      end

      it "拡大した画像が表示される" do
        within(".enlarged-image-display") do
          expect(find("img")[:src]).to include(displayed_filename)
        end
      end

      it "バツ印アイコンをクリックすると、拡大画像の表示が消える" do
        within(".enlarged-image-display") do
          find(".delete").click
          expect(page).not_to have_selector(".modal")
        end
      end
    end

    describe "表示画像の変更" do
      context "表示画像が一覧ページの１番目、または最後の画像ではないとき" do
        let!(:displayed_file) { image_0.files_blobs[1] }
        let(:prev_btn) { find(".prev-image-btn") }
        let(:next_btn) { find(".next-image-btn") }

        shared_examples "指定画像の拡大" do
          it "指定した画像が拡大表示される" do
            sleep 1
            find("a[href$='#{displayed_file.id}']").click
            btn.click

            within(".enlarged-image-display") do
              expect(find("img")[:src]).to include(filename)
            end
          end
        end

        context "一覧ページを新しい順で表示している場合" do
          let(:prev_file_index) { filenames_desc.index(displayed_filename) - 1 }
          let(:next_file_index) { filenames_desc.index(displayed_filename) + 1 }

          before { click_link "新しい順" }

          context "１つ前の画像を表示するアイコンをクリックしたとき" do
            let(:filename) { filenames_desc[prev_file_index] }
            let(:btn) { prev_btn }

            it_behaves_like "指定画像の拡大"
          end

          context "１つ先の画像を表示するアイコンをクリックしたとき" do
            let(:filename) { filenames_desc[next_file_index] }
            let(:btn) { next_btn }

            it_behaves_like "指定画像の拡大"
          end
        end

        context "一覧ページを古い順で表示している場合" do
          let(:prev_file_index) { filenames_asc.index(displayed_filename) - 1 }
          let(:next_file_index) { filenames_asc.index(displayed_filename) + 1 }

          before { click_link "古い順" }

          context "１つ前の画像を表示するアイコンをクリックしたとき" do
            let(:filename) { filenames_asc[prev_file_index] }
            let(:btn) { prev_btn }

            it_behaves_like "指定画像の拡大"
          end

          context "１つ先の画像を表示するアイコンをクリックしたとき" do
            let(:filename) { filenames_asc[next_file_index] }
            let(:btn) { next_btn }

            it_behaves_like "指定画像の拡大"
          end
        end

        context "一覧ページをいいねが多い順で表示している場合" do
          let(:prev_file_index) { filenames_image_like.index(displayed_filename) - 1 }
          let(:next_file_index) { filenames_image_like.index(displayed_filename) + 1 }

          before { click_link "いいねが多い順" }

          context "１つ前の画像を表示するアイコンをクリックしたとき" do
            let(:filename) { filenames_image_like[prev_file_index] }
            let(:btn) { prev_btn }

            it_behaves_like "指定画像の拡大"
          end

          context "１つ先の画像を表示するアイコンをクリックしたとき" do
            let(:filename) { filenames_image_like[next_file_index] }
            let(:btn) { next_btn }

            it_behaves_like "指定画像の拡大"
          end
        end
      end

      context "表示画像が一覧ページの１番目の画像であるとき" do
        it "１つ前の画像を表示するアイコンがない" do
          sleep 0.2
          find(".image-list-wrap").all("img").first.click
          expect(page).not_to have_selector(".prev-image-link-icon")
        end
      end

      context "表示画像が一覧ページの最後の画像であるとき" do
        it "１つ先の画像を表示するアイコンがない" do
          find(".image-list-wrap").all("img").last.click
          expect(page).not_to have_selector(".next-image-link-icon")
        end
      end
    end
  end
end

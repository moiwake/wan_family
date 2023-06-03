require 'rails_helper'

RSpec.describe "ImagesSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot, impressions_count: 2) }
  let!(:image_0) { create(:image, :attached, spot: spot, review: create(:review, spot: spot)) }
  let!(:image_1) { create(:image, :attached_1, spot: spot, review: create(:review, spot: spot)) }
  let!(:filenames) { ActiveStorage::Blob.pluck(:filename) }
  let!(:filenames_desc) { filenames.reverse }
  let!(:filenames_asc) { filenames }

  describe "スポットに投稿されたすべての画像一覧ページ" do
    describe "画像の表示" do
      before { visit spot_images_path(spot) }

      it "画像が詳細ページへのリンクとなっている" do
        Image.all.each do |image|
          image.files_blobs.each do |blob|
            expect(find(".image-list-wrap")).to have_link(href: spot_image_path(spot, image, image_blob_id: blob.id))
          end
        end
      end
    end

    describe "画像の表示順序" do
      let!(:filenames_image_like) { [most_liked_blob, second_liked_blob, image_1.files_blobs[0], image_0.files_blobs[0]].pluck(:filename) }
      let(:most_liked_blob) { image_1.files_blobs[1] }
      let(:second_liked_blob) { image_0.files_blobs[1] }

      before do
        create_list(:image_like, 3, image: image_1, blob_id: most_liked_blob.id)
        create_list(:image_like, 2, image: image_0, blob_id: second_liked_blob.id)
        visit spot_images_path(spot)
      end

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

        include_examples "画像の表示順序"
      end

      context "表示を新しい順にしたとき" do
        let(:ordered_filenames) { filenames_desc }

        before { click_link "新しい順" }

        include_examples "画像の表示順序"
      end

      context "表示を古い順にしたとき" do
        let(:ordered_filenames) { filenames_asc }

        before { click_link "古い順" }

        include_examples "画像の表示順序"
      end

      context "表示をいいねが多い順にしたとき" do
        let(:ordered_filenames) { filenames_image_like }

        before { click_link "いいねが多い順" }

        include_examples "画像の表示順序"
      end
    end

    describe "ページヘッダーの表示" do
      it_behaves_like "ページヘッダーの表示", "spot_images_path"
      it_behaves_like "画像一覧ページのページヘッダーのタブ"
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

    describe "拡大画像の表示" do
      let(:displayed_file) { image_0.files_blobs[1] }

      shared_examples "拡大画像の表示・非表示" do
        before do
          sign_in user
          visit send(path, target_spot)
          sleep 0.1
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

      context "トップページで実行するとき" do
        let(:path) { "root_path" }
        let(:target_spot) { nil }

        it_behaves_like "拡大画像の表示・非表示"
      end

      context "スポット詳細ページで実行するとき" do
        let(:path) { "spot_path" }
        let(:target_spot) { spot }

        it_behaves_like "拡大画像の表示・非表示"
      end

      context "スポットの画像一覧ページで実行するとき" do
        let(:path) { "spot_images_path" }
        let(:target_spot) { spot }

        it_behaves_like "拡大画像の表示・非表示"
      end

      context "スポットのレビュー一覧ページで実行するとき" do
        let(:path) { "spot_reviews_path" }
        let(:target_spot) { spot }

        it_behaves_like "拡大画像の表示・非表示"
      end

      context "スポットのレビュー一覧ページで実行するとき" do
        let(:path) { "spot_reviews_path" }
        let(:target_spot) { spot }

        it_behaves_like "拡大画像の表示・非表示"
      end

      context "ユーザーの投稿画像一覧ページで実行するとき" do
        let(:path) { "users_mypage_image_index_path" }
        let(:target_spot) { nil }
        let!(:image) { create(:image, :attached, user: user) }
        let(:displayed_file) { image.files_blobs[1] }

        before { create(:image, :attached, user: user) }

        it_behaves_like "拡大画像の表示・非表示"
      end

      context "ユーザーの投稿レビュー一覧ページで実行するとき" do
        let(:path) { "users_mypage_review_index_path" }
        let(:target_spot) { nil }
        let!(:review) { create(:review, :with_image, user: user) }
        let(:displayed_file) { review.image.files_blobs[1] }

        before { create(:review, :with_image, user: user) }

        it_behaves_like "拡大画像の表示・非表示"
      end
    end

    describe "表示画像の変更" do
      context "表示画像が一覧ページの１番目、または最後の画像ではないとき" do
        let!(:displayed_file) { image_0.files_blobs[1] }
        let(:prev_btn) { find(".prev-image-btn") }
        let(:next_btn) { find(".next-image-btn") }
        let(:prev_file_index) { ordered_filenames.index(displayed_filename) - 1 }
        let(:next_file_index) { ordered_filenames.index(displayed_filename) + 1 }

        before { image_0.files.attach({ io: File.open('spec/fixtures/images/test3.png'), filename: 'test3.png' }) }

        shared_examples "拡大画像を前後の画像に変更" do
          context "１つ前の画像を表示するアイコンをクリックしたとき" do
            let(:filename) { ordered_filenames[prev_file_index] }
            let(:btn) { prev_btn }

            it_behaves_like "指定画像の拡大"
          end

          context "１つ先の画像を表示するアイコンをクリックしたとき" do
            let(:filename) { ordered_filenames[next_file_index] }
            let(:btn) { next_btn }

            it_behaves_like "指定画像の拡大"
          end
        end

        shared_examples "指定画像の拡大" do
          it "指定した画像が拡大表示される" do
            sign_in user
            visit send(path, target_spot)
            click_link order if order
            sleep 0.1
            binding.pry
            find("a[href$='#{displayed_file.id}']").click
            btn.click

            within(".enlarged-image-display") do
              expect(find("img")[:src]).to include(filename)
            end
          end
        end

        context "新しい順に並んでいる画像の場合" do
          let(:prev_file_index) { ordered_filenames.index(displayed_filename) - 1 }
          let(:next_file_index) { ordered_filenames.index(displayed_filename) + 1 }
          let(:ordered_filenames) { filenames_desc }

          context "スポットの画像一覧ページで実行するとき" do
            let(:path) { "spot_images_path" }
            let(:target_spot) { spot }
            let(:order) { "新しい順" }

            it_behaves_like "拡大画像を前後の画像に変更"
          end

          context "ユーザーの投稿画像一覧ページで実行するとき" do
            let!(:image_0) { create(:image, :attached, user: user) }
            let!(:image_1) { create(:image, :attached_1, user: user) }
            let(:path) { "users_mypage_image_index_path" }
            let(:target_spot) { nil }
            let(:order) { "新しい順" }

            it_behaves_like "拡大画像を前後の画像に変更"
          end
        end

        context "古い順に並んでいる画像の場合" do
          let(:ordered_filenames) { filenames_asc }

          context "スポット詳細ページで実行するとき" do
            let(:path) { "spot_path" }
            let(:target_spot) { spot }
            let(:order) { nil }

            it_behaves_like "拡大画像を前後の画像に変更"
          end

          context "スポットのレビュー一覧ページで実行するとき" do
            let(:path) { "spot_reviews_path" }
            let(:target_spot) { spot }
            let(:order) { nil }

            it_behaves_like "拡大画像を前後の画像に変更"
          end

          context "ユーザーの投稿レビュー一覧ページで実行するとき" do
            let(:path) { "users_mypage_review_index_path" }
            let(:target_spot) { nil }
            let(:order) { nil }
            let!(:review) { create(:review, image: image_0, user: user) }
            let(:displayed_file) { review.image.files_blobs[1] }

            before { create(:review, :with_image, user: user) }

            it_behaves_like "拡大画像を前後の画像に変更"
          end
        end

        context "いいねが多い順に並んでいる画像の場合" do
          let!(:filenames_image_like) { [most_liked_blob, second_liked_blob, image_1.files_blobs[1]].pluck(:filename) }
          let(:most_liked_blob) { image_0.files_blobs[2] }
          let(:second_liked_blob) { image_0.files_blobs[1] }
          let(:ordered_filenames) { filenames_image_like }

          before do
            create_list(:image_like, 3, image: image_0, blob_id: most_liked_blob.id)
            create_list(:image_like, 2, image: image_0, blob_id: second_liked_blob.id)
          end

          context "トップページで実行するとき" do
            let(:path) { "root_path" }
            let(:target_spot) { nil }
            let(:order) { nil }

            it_behaves_like "拡大画像を前後の画像に変更"
          end
        end
      end

      context "表示画像が一覧ページの１番目、または最後の画像であるとき" do
        before do
          sign_in user
          visit send(path, target_spot)
          sleep 0.2
        end

        shared_examples "１番目の画像を拡大したときのアイコンの表示" do
          it "１つ前の画像を表示するアイコンがない" do
            all(".image-link-list-item")[0].all("img").first.click
            expect(page).not_to have_selector(".prev-image-link-icon")
          end
        end

        shared_examples "最後の画像を拡大したときのアイコンの表示" do
          it "１つ後の画像を表示するアイコンがない" do
            all(".image-link-list-item")[0].all("img").last.click
            expect(page).not_to have_selector(".next-image-link-icon")
          end
        end

        context "スポットの画像一覧ページで実行するとき" do
          let(:path) { "spot_images_path" }
          let(:target_spot) { spot }

          it_behaves_like "１番目の画像を拡大したときのアイコンの表示"
          it_behaves_like "最後の画像を拡大したときのアイコンの表示"
        end

        context "ユーザーの投稿画像一覧ページで実行するとき" do
          let!(:image_0) { create(:image, :attached, user: user) }
          let(:path) { "users_mypage_image_index_path" }
          let(:target_spot) { nil }

          it_behaves_like "１番目の画像を拡大したときのアイコンの表示"
          it_behaves_like "最後の画像を拡大したときのアイコンの表示"
        end

        context "スポット詳細ページで実行するとき" do
          let(:path) { "spot_path" }
          let(:target_spot) { spot }

          it_behaves_like "１番目の画像を拡大したときのアイコンの表示"
          it_behaves_like "最後の画像を拡大したときのアイコンの表示"
        end

        context "スポットのレビュー一覧ページで実行するとき" do
          let(:path) { "spot_reviews_path" }
          let(:target_spot) { spot }

          it_behaves_like "１番目の画像を拡大したときのアイコンの表示"
          it_behaves_like "最後の画像を拡大したときのアイコンの表示"
        end

        context "ユーザーの投稿レビュー一覧ページで実行するとき" do
          let(:path) { "users_mypage_review_index_path" }
          let(:target_spot) { nil }

          before do
            create(:image, :attached, user: user, review: create(:review, user: user))
            visit send(path, target_spot)
          end

          it_behaves_like "１番目の画像を拡大したときのアイコンの表示"
          it_behaves_like "最後の画像を拡大したときのアイコンの表示"
        end

        context "トップページで実行するとき" do
          let(:path) { "root_path" }
          let(:target_spot) { nil }

          it_behaves_like "１番目の画像を拡大したときのアイコンの表示"
          it_behaves_like "最後の画像を拡大したときのアイコンの表示"
        end
      end
    end
  end
end

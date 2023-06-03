require 'rails_helper'

RSpec.describe "SpotTagsSystemSpecs", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  shared_examples "スポット詳細ページのタグ表示" do
    context "ログインしているとき" do
      let!(:spot_tags) { create_list(:spot_tag, 4, user: user, spot: spot).reverse }

      before do
        sign_in user
        visit send(path, target_spot)
      end

      it "登録したタグ名が新しい順に３つまで表示される" do
        spot_tags.first(3).each_with_index do |spot_tag, i|
          expect(all(".header-created-tag")[i]).to have_content(spot_tag.name)
        end

        expect(all(".header-created-tag").length).to eq(3)
      end

      context "タグを３つ以上登録しているとき" do
        it "表示しているタグとの差分の数を表示する" do
          expect(find(".other-tags-number")).to have_content(spot_tags.length - 3)
        end
      end
    end

    context "ログインしていないとき" do
      before { visit send(path, target_spot) }

      it "ログインページへのリンクが表示される" do
        expect(find(".mark-spot-btns-wrap")).to have_link(href: new_user_session_path)
      end

      it "マウスオーバーすると、メッセージが表示される" do
        find('.mark-spot-btns-wrap').hover
        expect(page).to have_content("ログインが\n必要です")
      end
    end
  end

  shared_examples "登録タグの一覧表示" do
    let!(:spot_tags) { create_list(:spot_tag, 3, user: user, spot: spot).reverse }

    before do
      sign_in user
      visit send(path, target_spot)
      find("#open-tag-list").click
    end

    it "このスポットで登録したタグが新しい順に一覧表示される" do
      spot_tags.each_with_index do |spot_tag, i|
        expect(all(".tag-list-content-wrap")[i]).to have_content(spot_tag.name)
        expect(all(".tag-list-content-wrap")[i]).to have_link(href: edit_spot_spot_tag_path(spot, spot_tag))
        expect(all(".tag-list-content-wrap")[i]).to have_link(href: spot_spot_tag_path(spot, spot_tag))
      end
    end

    it "タグごとにメモを表示できる" do
      spot_tags.each.with_index do |spot_tag, i|
        all(".tag-expand-btn")[i].click
        expect(all(".tag-list-content-wrap")[i]).to have_content(spot_tag.memo)
      end
    end
  end

  shared_examples "タグ登録フォームの表示" do
    let!(:another_spot) { create(:spot) }
    let!(:spot_tags) { create_list(:spot_tag, 5, user: user, spot: spot) }
    let!(:another_spot_tags) { create_list(:spot_tag, 6, user: user, spot: another_spot) }
    let(:all_tags) { user.spot_tags.order(created_at: :desc) }
    let(:max_number) { SpotTag::MAX_CREATED_NAME_DISPLAY_NUMBER }

    before do
      sign_in user
      visit send(path, target_spot)
      find("#open-tag-list").click
      find(".new-tag-link").click
    end

    it "追加リンクが非表示になる" do
      expect(page).not_to have_link(href: new_spot_spot_tag_path(spot))
    end

    it "タグ編集のボタンが非表示になる" do
      spot_tags.each do |spot_tag|
        expect(page).not_to have_link(href: edit_spot_spot_tag_path(spot, spot_tag))
      end
    end

    it "タグ名の入力フォームにデフォルト値が設定されている" do
      expect(find("#tag-name-input").value).to eq("行ってみたい")
    end

    it "ログインユーザーの過去に登録したタグ名が、新しい順に上限数まで表示される" do
      all_tags.each_with_index do |spot_tag, i|
        break i == (max_number - 1)
        expect(all(".created-tag")[i]).to have_content(spot_tag.name)
      end

      expect(all(".created-tag").length).to eq(max_number)
    end

    it "入力をキャンセルすると、フォームが閉じ、タグ追加・編集のリンクが表示される" do
      find("#cancel-btn").click
      expect(page).not_to have_selector(".tag-form-wrap")
      expect(page).to have_link(href: new_spot_spot_tag_path(spot))

      spot_tags.each do |spot_tag|
        expect(page).to have_link(href: edit_spot_spot_tag_path(spot, spot_tag))
      end
    end
  end

  shared_examples "タグ編集フォームの表示" do
    let!(:another_spot) { create(:spot) }
    let!(:spot_tags) { create_list(:spot_tag, 5, user: user, spot: spot).reverse }
    let!(:another_spot_tags) { create_list(:spot_tag, 6, user: user, spot: another_spot) }
    let(:all_tags) { user.spot_tags.order(created_at: :desc) }
    let(:tag_to_be_updated) { spot_tags.last }
    let(:max_number) { SpotTag::MAX_CREATED_NAME_DISPLAY_NUMBER }

    before do
      sign_in user
      visit send(path, target_spot)
      find("#open-tag-list").click
      all(".tag-edit-btn")[0].click
    end

    it "追加リンクが非表示になる" do
      expect(page).not_to have_link(href: new_spot_spot_tag_path(spot))
    end

    it "タグ編集のボタンが非表示になる" do
      spot_tags.each do |spot_tag|
        expect(page).not_to have_link(href: edit_spot_spot_tag_path(spot, spot_tag))
      end
    end

    it "編集するタグのデータが入力欄に表示される" do
      expect(find("#tag-name-input").value).to eq(spot_tags[0].name)
      expect(find("#tag-memo-input").value).to eq(spot_tags[0].memo)
    end

    it "ログインユーザーの過去に登録したタグ名が、新しい順に上限数まで表示される" do
      all_tags.each_with_index do |spot_tag, i|
        break i == (max_number - 1)
        expect(all(".created-tag")[i]).to have_content(spot_tag.name)
      end

      expect(all(".created-tag").length).to eq(max_number)
    end

    it "入力をキャンセルすると、フォームが閉じ、タグ追加・編集のリンクが表示される" do
      find("#cancel-btn").click
      expect(page).not_to have_selector(".tag-form-wrap")
      expect(page).to have_link(href: new_spot_spot_tag_path(spot))

      spot_tags.each do |spot_tag|
        expect(page).to have_link(href: edit_spot_spot_tag_path(spot, spot_tag))
      end
    end
  end

  shared_examples "スポットタグの登録" do
    let(:spot_tag) { build(:spot_tag) }
    let(:new_spot_tag) { SpotTag.last }

    before do
      sign_in user
      visit send(path, target_spot)
      find("#open-tag-list").click
      find(".new-tag-link").click
      fill_in "tag-name-input", with: spot_tag.name
      fill_in "tag-memo-input", with: spot_tag.memo
    end

    it "スポットタグの登録ができる" do
      expect do
        click_button "保存"
        expect(find(".tag-list-wrap")).to have_content(new_spot_tag.name)
        expect(find(".tag-list-wrap")).to have_link(href: edit_spot_spot_tag_path(spot, new_spot_tag))
        expect(find(".tag-list-wrap")).to have_link(href: spot_spot_tag_path(spot, new_spot_tag))
      end.to change { SpotTag.count }.by(1)

      expect(new_spot_tag.name).to eq(spot_tag.name)
      expect(new_spot_tag.memo).to eq(spot_tag.memo)
      expect(new_spot_tag.user_id).to eq(user.id)
      expect(new_spot_tag.spot_id).to eq(spot.id)
    end
  end

  shared_examples "スポットタグの更新" do
    let!(:spot_tag) { create(:spot_tag, user: user, spot: spot) }
    let(:updated_spot_tag) { build(:spot_tag) }

    before do
      sign_in user
      visit send(path, target_spot)
      find("#open-tag-list").click
      all(".tag-edit-btn")[0].click
      fill_in "tag-name-input", with: updated_spot_tag.name
      fill_in "tag-memo-input", with: updated_spot_tag.memo
    end

    it "スポットタグの更新ができる" do
      expect do
        click_button "保存"
        expect(find(".tag-list-wrap")).to have_content(updated_spot_tag.name)
      end.to change { SpotTag.count }.by(0)

      spot_tag.reload
      expect(spot_tag.user_id).to eq(user.id)
      expect(spot_tag.spot_id).to eq(spot.id)
      expect(spot_tag.name).to eq(updated_spot_tag.name)
      expect(spot_tag.memo).to eq(updated_spot_tag.memo)
    end
  end

  shared_examples "スポットタグの削除" do
    let!(:spot_tag) { create(:spot_tag, user: user, spot: spot) }

    before do
      sign_in user
      visit send(path, target_spot)
      find("#open-tag-list").click
    end

    it "スポットタグの削除ができる" do
      expect do
        all(".tag-delete-btn")[0].click
        expect(page.accept_confirm).to eq("タグを削除しますか？")
        expect(find(".tag-list-wrap")).not_to have_content(spot_tag.name)
      end.to change { SpotTag.count }.by(-1)
    end
  end

  context "スポット詳細ページで実行するとき" do
    let(:path) { "spot_path" }
    let(:target_spot) { spot }

    it_behaves_like "スポット詳細ページのタグ表示"
    it_behaves_like "登録タグの一覧表示"
    it_behaves_like "タグ登録フォームの表示"
    it_behaves_like "タグ編集フォームの表示"
    it_behaves_like "スポットタグの登録"
    it_behaves_like "スポットタグの更新"
    it_behaves_like "スポットタグの削除"
  end

  context "スポットのレビュー一覧ページで実行するとき" do
    let(:path) { "spot_reviews_path" }
    let(:target_spot) { spot }

    it_behaves_like "スポット詳細ページのタグ表示"
    it_behaves_like "登録タグの一覧表示"
    it_behaves_like "タグ登録フォームの表示"
    it_behaves_like "タグ編集フォームの表示"
    it_behaves_like "スポットタグの登録"
    it_behaves_like "スポットタグの更新"
    it_behaves_like "スポットタグの削除"
  end

  context "スポットの画像一覧ページで実行するとき" do
    let(:path) { "spot_images_path" }
    let(:target_spot) { spot }

    it_behaves_like "スポット詳細ページのタグ表示"
    it_behaves_like "登録タグの一覧表示"
    it_behaves_like "タグ登録フォームの表示"
    it_behaves_like "タグ編集フォームの表示"
    it_behaves_like "スポットタグの登録"
    it_behaves_like "スポットタグの更新"
    it_behaves_like "スポットタグの削除"
  end
end

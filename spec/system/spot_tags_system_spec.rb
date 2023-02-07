require 'rails_helper'

RSpec.describe "SpotTagsSystemSpecs", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  describe "スポット詳細ページのタグ表示" do
    context "ログインしているとき" do
      context "ログインユーザーがスポットにタグを登録しているとき" do
        let!(:spot_tags) { create_list(:spot_tag, 3, user_id: user.id, spot_id: spot.id) }
        let!(:current_tag_count) { SpotTag.where(user_id: user.id, spot_id: spot.id).count }

        before do
          sign_in user
          visit spot_path(spot)
        end

        it "登録しているタグの総計を表示する" do
          expect(find(".post-spot-tag")).to have_content(current_tag_count)
        end
      end

      context "ログインユーザーがスポットにタグを登録していないとき" do
        before do
          sign_in user
          visit spot_path(spot)
        end

        it "タグが登録されていない表示が出る" do
          expect(find(".post-spot-tag")).to have_content("このスポットにはタグがついていません")
        end
      end
    end

    context "ログインしていないとき" do
      before { visit spot_path(spot) }

      it "タグ登録のリンクが表示されない" do
        expect(find(".post-spot-tag")).not_to have_selector("a")
      end
    end
  end

  describe "作成タグの一覧表示" do
    let!(:spot_tags) { create_list(:spot_tag, 3, user_id: user.id, spot_id: spot.id) }

    before do
      sign_in user
      visit spot_path(spot)
      find("#open-tag-list").click
    end

    it "このスポットで作成したタグが一覧表示される" do
      spot_tags.each do |spot_tag|
        expect(find("#tag-list")).to have_content(spot_tag.name)
        expect(find("#tag-list")).to have_link(href: edit_spot_spot_tag_path(spot, spot_tag))
        expect(find("#tag-list")).to have_link(href: spot_spot_tag_path(spot, spot_tag))
      end
    end

    it "タグごとにメモを表示できる" do
      spot_tags.reverse_each.with_index do |spot_tag, i|
        page.all(".expand-tag-btn")[i].click
        expect(page.all("#tag-list li")[i]).to have_content(spot_tag.memo)
      end
    end

    context "タグにメモが保存されていないとき" do
      let!(:spot_tag) { create(:spot_tag, user_id: user.id, spot_id: spot.id, memo: nil) }

      it "メモが未保存である表示が出る" do
        page.all(".expand-tag-btn").first.click
        expect(page.all("#tag-list li").first).to have_content("このタグにメモはありません。")
      end
    end
  end

  describe "タグ登録フォームの表示" do
    let!(:another_spot) { create(:spot) }
    let!(:spot_tags) { create_list(:spot_tag, 5, user_id: user.id, spot_id: spot.id) }
    let!(:another_spot_tags) { create_list(:spot_tag, 6, user_id: user.id, spot_id: another_spot.id) }
    let(:all_tags) { user.spot_tags.order(created_at: :desc) }
    let(:max_number) { SpotTag::MAX_CREATED_NAME_DISPLAY_NUMBER }

    before do
      sign_in user
      visit spot_path(spot)
      find("#open-tag-list").click
      find("#new-tag-link a").click
    end

    it "追加リンクが非表示になる" do
      expect(find("#tag-list")).not_to have_link(href: new_spot_spot_tag_path(spot))
    end

    it "タグ編集のボタンが非表示になる" do
      spot_tags.each do |spot_tag|
        expect(find("#tag-list")).not_to have_link(href: edit_spot_spot_tag_path(spot, spot_tag))
      end
    end

    it "タグネームの入力フォームにデフォルト値が設定されている" do
      expect(find("#tag-name-form").value).to eq("行ってみたい")
    end

    it "ログインユーザーの過去に作成したタグネームが、新しい順に上限数まで表示される" do
      all_tags.limit(max_number).each do |spot_tag|
        expect(find(".tag-form")).to have_content(spot_tag.name)
      end

      expect(page.all(".tag-form li")[max_number]).not_to have_content(all_tags[max_number].name)
    end

    it "入力をキャンセルすると、フォームが閉じ、タグ追加のリンクが表示される" do
      find("#cancel-btn").click
      expect(find("#tag-list")).not_to have_selector(".tag-form")
      expect(find("#tag-list")).to have_link(href: new_spot_spot_tag_path(spot))
    end
  end

  describe "タグ編集フォームの表示" do
    let!(:another_spot) { create(:spot) }
    let!(:spot_tags) { create_list(:spot_tag, 5, user_id: user.id, spot_id: spot.id) }
    let!(:another_spot_tags) { create_list(:spot_tag, 6, user_id: user.id, spot_id: another_spot.id) }
    let(:all_tags) { user.spot_tags.order(created_at: :desc) }
    let(:tag_to_be_updated) { spot_tags.last }
    let(:max_number) { SpotTag::MAX_CREATED_NAME_DISPLAY_NUMBER }

    before do
      sign_in user
      visit spot_path(spot)
      find("#open-tag-list").click
      page.all(".edit-tag-btn a").first.click
    end

    it "追加リンクが非表示になる" do
      expect(find("#tag-list")).not_to have_link(href: new_spot_spot_tag_path(spot))
    end

    it "タグ編集のボタンが非表示になる" do
      spot_tags.each do |spot_tag|
        expect(find("#tag-list")).not_to have_link(href: edit_spot_spot_tag_path(spot, spot_tag))
      end
    end

    it "編集するタグの詳細が非表示になる" do
      expect(page.all(".tag-list-content").first).not_to have_selector(".tag_bar")
      expect(find("#tag-list")).not_to have_link(href: spot_spot_tag_path(spot, tag_to_be_updated))
    end

    it "ログインユーザーの過去に作成したタグネームが、新しい順に上限数まで表示される" do
      all_tags.limit(max_number).each do |spot_tag|
        expect(find(".tag-form")).to have_content(spot_tag.name)
      end

      expect(page.all(".tag-form li")[max_number]).not_to have_content(all_tags[max_number].name)
    end

    it "入力をキャンセルすると、フォームが閉じ、タグの詳細と追加リンクが表示される" do
      find("#cancel-btn").click
      expect(find("#tag-list")).not_to have_selector(".tag-form")
      expect(find("#tag-list")).to have_content(tag_to_be_updated.name)
      expect(find("#tag-list")).to have_link(href: edit_spot_spot_tag_path(spot, tag_to_be_updated))
      expect(find("#tag-list")).to have_link(href: spot_spot_tag_path(spot, tag_to_be_updated))
      expect(find("#tag-list")).to have_link(href: new_spot_spot_tag_path(spot))
    end
  end

  describe "スポットタグの登録" do
    let(:spot_tag) { build(:spot_tag) }
    let(:new_spot_tag) { SpotTag.last }

    before do
      sign_in user
      visit spot_path(spot)
      find("#open-tag-list").click
      find("#new-tag-link a").click
      fill_in "tag-name-form", with: spot_tag.name
      fill_in "tag-memo-form", with: spot_tag.memo
    end

    it "スポットタグの登録ができる" do
      expect do
        click_button "保存"
        expect(find("#display-created-tag-name")).to have_content(spot_tag.name)
      end.to change { SpotTag.count }.by(1)

      expect(new_spot_tag.user_id).to eq(user.id)
      expect(new_spot_tag.spot_id).to eq(spot.id)
      expect(new_spot_tag.name).to eq(spot_tag.name)
      expect(new_spot_tag.memo).to eq(spot_tag.memo)
    end

    it "タグ追加後、一覧に追加したタグが表示される" do
      click_button "保存"
      expect(find("#tag-list")).to have_content(new_spot_tag.name)
      expect(find("#tag-list")).to have_link(href: edit_spot_spot_tag_path(spot, new_spot_tag))
      expect(find("#tag-list")).to have_link(href: spot_spot_tag_path(spot, new_spot_tag))
    end
  end

  describe "スポットタグの更新" do
    let!(:spot_tag) { create(:spot_tag, user_id: user.id, spot_id: spot.id) }
    let(:updated_spot_tag) { build(:spot_tag) }

    before do
      sign_in user
      visit spot_path(spot)
      find("#open-tag-list").click
      page.all(".edit-tag-btn a").first.click
      fill_in "tag-name-form", with: updated_spot_tag.name
      fill_in "tag-memo-form", with: updated_spot_tag.memo
    end

    it "スポットタグの更新ができる" do
      expect do
        click_button "保存"
        expect(find("#display-created-tag-name")).to have_content(updated_spot_tag.name)
      end.to change { SpotTag.count }.by(0)

      spot_tag.reload
      expect(spot_tag.user_id).to eq(user.id)
      expect(spot_tag.spot_id).to eq(spot.id)
      expect(spot_tag.name).to eq(updated_spot_tag.name)
      expect(spot_tag.memo).to eq(updated_spot_tag.memo)
    end

    it "タグ更新後、一覧に更新したタグが表示される" do
      click_button "保存"
      expect(find("#tag-list")).to have_content(updated_spot_tag.name)
    end
  end

  describe "スポットタグの削除" do
    let!(:spot_tag) { create(:spot_tag, user_id: user.id, spot_id: spot.id) }

    before do
      sign_in user
      visit spot_path(spot)
      find("#open-tag-list").click
    end

    it "スポットタグの削除ができる" do
      expect do
        page.all(".delete-tag-btn a").first.click
        expect(page.accept_confirm).to eq("タグを削除しますか？")
        expect(find("#display-created-tag-name")).not_to have_content(spot_tag.name)
      end.to change { SpotTag.count }.by(-1)
    end

    it "タグ削除後、一覧に削除したタグが表示されない" do
      expect(find("#tag-list")).to have_content(spot_tag.name)
    end
  end
end

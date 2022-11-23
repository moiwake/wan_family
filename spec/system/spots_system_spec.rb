require 'rails_helper'

RSpec.describe "SpotsSystemSpecs", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:spot) { build(:spot, :real_spot) }
  let(:another_spot) { build(:spot, :another_real_spot) }

  let!(:rule_option) { create_list(:rule_option, 2) }
  let!(:allowed_areas) { create_list(:allowed_area, 2) }
  let!(:categories) { create_list(:category, 2) }

  describe "スポットの検索" do
    before do
      sign_in user
      visit root_path
      click_link "新しいお出かけスポットの登録"
    end

    context "ページにアクセスしてから1度目の検索" do
      context "マップに存在する特定の場所を検索したとき" do
        it "所在地・緯度経度が自動で入力される" do
          fill_in "form_search_spot", with: spot.name
          click_button "検索"
          sleep 0.1

          expect(find("#form_spot_address").value).to eq(spot.address)
          expect(find("#form_lat", visible: false).value).to eq(spot.latitude.to_s)
          expect(find("#form_lng", visible: false).value).to eq(spot.longitude.to_s)
        end
      end

      context "結果が出ない場所の検索" do
        shared_examples "display_alert" do
          it "アラートが表示される" do
            fill_in "form_search_spot", with: search_spot_name
            click_button "検索"

            expect(page.accept_alert).to eq(alert_message)
          end
        end

        context "マップに存在しない場所を検索したとき" do
          let(:search_spot_name) { "non_existent_spot" }
          let(:alert_message) { "該当するスポットがありませんでした。" }

          it_behaves_like "display_alert"
        end

        context "空文字で検索したとき" do
          let(:search_spot_name) { "" }
          let(:alert_message) { "検索ワードを入力してください。" }

          it_behaves_like "display_alert"
        end

        context "マップに存在するが、特定ができない場所を検索したとき" do
          let(:search_spot_name) { "東京" }
          let(:alert_message) { "スポットを特定できませんでした。検索ワードを変更してください。" }

          it_behaves_like "display_alert"
        end
      end
    end

    context "すでに検索の結果が出ている上で、別の場所を検索する" do
      context "マップに存在する特定の場所を検索したとき" do
        before do
          fill_in "form_search_spot", with: spot.name
          click_button "検索"
          sleep 0.1
        end

        it "最後に検索した場所の所在地・緯度経度が自動で入力される" do
          fill_in "form_search_spot", with: another_spot.name
          click_button "検索"
          sleep 0.1

          expect(find("#form_spot_address").value).to eq(another_spot.address)
          expect(find("#form_lat", visible: false).value).to eq(another_spot.latitude.to_s)
          expect(find("#form_lng", visible: false).value).to eq(another_spot.longitude.to_s)
        end
      end

      context "結果が出ない場所の検索" do
        shared_examples "results_clear" do
          it "アラートが表示され、検索結果がクリアされる" do
            fill_in "form_search_spot", with: search_spot_name
            click_button "検索"
            page.accept_alert alert_message

            expect(find("#form_spot_address").value).to be_empty
            expect(find("#form_lat", visible: false).value).to be_empty
            expect(find("#form_lng", visible: false).value).to be_empty
          end
        end

        context "マップに存在しない場所を検索したとき" do
          let(:search_spot_name) { "non_existent_spot" }
          let(:alert_message) { "該当するスポットがありませんでした。" }

          it_behaves_like "results_clear"
        end

        context "空文字で検索したとき" do
          let(:search_spot_name) { "" }
          let(:alert_message) { "検索ワードを入力してください。" }

          it_behaves_like "results_clear"
        end

        context "マップに存在するが、特定ができない場所を検索したとき" do
          let(:search_spot_name) { "東京" }
          let(:alert_message) { "スポットを特定できませんでした。検索ワードを変更してください。" }

          it_behaves_like "results_clear"
        end
      end
    end
  end

  describe "新しいスポットの登録" do
    before do
      sign_in user
      visit root_path
      click_link "新しいお出かけスポットの登録"
      fill_in "form_spot_name", with: spot.name
      fill_in "form_search_spot", with: spot.name
      click_button "検索"
      select "#{Category.first.name}", from: "スポットカテゴリー"
      select "#{AllowedArea.first.area}", from: "同伴可能エリア"
      fill_in "form_official_site", with: spot.official_site
      check "#{RuleOption.first.name}"
      click_button "登録"
    end

    context "登録内容の入力画面" do
      it "入力内容の確認画面へ遷移する" do
        expect(current_path).to eq(new_confirm_spots_path)
      end
    end

    context "入力内容の確認画面" do
      it "スポットを登録できる" do
        expect do
          click_button "登録を完了する"
        end.to change { Spot.count }.by(1)
      end

      it "スポットに紐づく同伴ルールを登録できる" do
        expect do
          click_button "登録を完了する"
        end.to change { Rule.count }.by(RuleOption.count)
      end

      it "入力画面に遷移できる" do
        click_button "入力画面に戻る"
        expect(current_path).to eq(back_new_spots_path)
      end
    end

    context "確認ページから入力画面に遷移したとき" do
      let(:unchecked_rule_opt) { RuleOption.first }
      let(:checked_rule_opt) { RuleOption.last }

      before do
        click_button "入力画面に戻る"
        fill_in "form_spot_name", with: another_spot.name
        fill_in "form_search_spot", with: another_spot.name
        click_button "検索"
        select "#{Category.last.name}", from: "スポットカテゴリー"
        select "#{AllowedArea.last.area}", from: "同伴可能エリア"
        fill_in "form_official_site", with: another_spot.official_site
        check "#{checked_rule_opt.name}"
        uncheck "#{unchecked_rule_opt.name}"
        click_button "登録"
      end

      it "再び入力内容確認画面へ遷移できる" do
        expect(current_path).to eq(new_confirm_spots_path)
      end

      it "入力内容を変更できる" do
        expect(page).to have_content(another_spot.name)
        expect(page).to have_content(another_spot.address)
        expect(page).to have_content(Category.last.name)
        expect(page).to have_content(AllowedArea.last.area)
        expect(page).to have_content(another_spot.official_site)
        expect(page).to have_content(checked_rule_opt.name)
      end
    end
  end

  describe "スポットの更新" do
    let!(:spot) { create(:spot, :real_spot, :with_rules) }
    let!(:updated_spot) { build(:spot, :another_real_spot) }

    let(:unchecked_rule_opt) do
      attached_rule = spot.rule.where(answer: "1").first
      RuleOption.find(attached_rule.rule_option_id)
    end
    let(:checked_rule_opt) do
      not_attached_rule = spot.rule.where(answer: "0").first
      RuleOption.find(not_attached_rule.rule_option_id)
    end

    before do
      sign_in user
      visit spot_path(spot.id)
      click_link "スポットの登録内容を更新する"
      fill_in "form_spot_name", with: updated_spot.name
      fill_in "form_search_spot", with: updated_spot.name
      click_button "検索"
      select "#{Category.last.name}", from: "スポットカテゴリー"
      select "#{AllowedArea.last.area}", from: "同伴可能エリア"
      fill_in "form_official_site", with: updated_spot.official_site
      check "#{checked_rule_opt.name}"
      uncheck "#{unchecked_rule_opt.name}"
      click_button "登録"
    end

    context "更新内容の入力画面" do
      it "入力内容の確認画面へ遷移する" do
        expect(current_path).to eq(edit_confirm_spot_path(spot.id))
      end
    end

    context "入力内容の確認画面" do
      let(:updated_checked_rule) { spot.rule.find_by(rule_option_id: checked_rule_opt.id) }
      let(:updated_unchecked_rule) { spot.rule.find_by(rule_option_id: unchecked_rule_opt.id) }

      it "スポットを更新できる" do
        expect do
          click_button "更新を完了する"
        end.to change { Spot.count }.by(0)

        expect(spot.reload.name).to eq(updated_spot.name)
        expect(spot.reload.address).to eq(updated_spot.address)
        expect(spot.reload.latitude).to eq(updated_spot.latitude)
        expect(spot.reload.longitude).to eq(updated_spot.longitude)
        expect(spot.reload.category_id).to eq(Category.last.id)
        expect(spot.reload.allowed_area_id).to eq(AllowedArea.last.id)
        expect(spot.reload.official_site).to eq(updated_spot.official_site)
      end

      it "スポットに紐づく同伴ルールを更新できる" do
        expect do
          click_button "更新を完了する"
        end.to change { Rule.count }.by(0)

        expect(updated_checked_rule.answer).to eq("1")
        expect(updated_unchecked_rule.answer).to eq("0")
      end

      it "入力画面に遷移できる" do
        click_button "入力画面に戻る"
        expect(current_path).to eq(back_edit_spot_path(spot.id))
      end
    end

    context "確認ページから入力画面に遷移したとき" do
      before do
        click_button "入力画面に戻る"
        click_button "登録"
      end

      it "再び入力内容確認画面へ遷移できる" do
        expect(current_path).to eq(edit_confirm_spot_path(spot.id))
      end
    end
  end
end

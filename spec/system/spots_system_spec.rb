require 'rails_helper'
require 'support/shared_examples/system_spec'

RSpec.describe "SpotsSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:categories) { create_list(:category, 3) }
  let!(:allowed_areas) { create_list(:allowed_area, 3) }
  let!(:option_titles) { create_list(:option_title, 3) }
  let!(:rule_options) { create_list(:rule_option, 3) }

  describe "新しいスポットの登録" do
    let!(:spot) { build(:spot) }

    shared_context "有効な登録内容の入力" do
      before do
        fill_in "form_spot_name", with: spot.name
        fill_in "form_spot_address", with: spot.address
        page.execute_script("document.getElementById('form_spot_lat').value = #{spot.latitude}")
        page.execute_script("document.getElementById('form_spot_lng').value = #{spot.longitude}")
        select categories[0].name, from: "スポットカテゴリー"
        select allowed_areas[0].area, from: "同伴可能エリア"
        fill_in "form_spot_official_site", with: spot.official_site
        check rule_options[0].name
        click_button "入力内容の確認へ"
      end
    end

    before do
      sign_in user
      visit root_path
      click_link "新しいお出かけスポットの登録"
    end

    describe "登録内容の入力ページ" do
      describe "入力項目の表示" do
        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_option_titles"
        it_behaves_like "displays_all_rule_options"
      end

      describe "登録内容の入力" do
        context "入力内容が妥当なとき", js: true do
          include_context "有効な登録内容の入力"

          it "確認ページへ遷移する" do
            expect(current_path).to eq(new_confirm_spots_path)
          end
        end

        context "入力内容が不正なとき", js: true do
          before do
            check rule_options[0].name
            click_button "入力内容の確認へ"
          end

          it "バリデーションエラーが表示される" do
            expect(page).to have_content("#{Spot.human_attribute_name(:name)}を入力してください")
            expect(page).to have_content("#{Spot.human_attribute_name(:address)}を入力してください")
            expect(page).to have_content("#{Spot.human_attribute_name(:category)}を入力してください")
            expect(page).to have_content("#{Spot.human_attribute_name(:allowed_area)}を入力してください")
          end

          it "addressカラムにエラーがあるとき、latitudeカラム、longitudeカラムのバリデーションエラーは表示されない" do
            expect(page).not_to have_content("#{Spot.human_attribute_name(:latitude)}を入力してください")
            expect(page).not_to have_content("#{Spot.human_attribute_name(:longitude)}を入力してください")
          end

          it "チェックを付けていた同伴ルールには、そのままチェックが付く" do
            expect(page).to have_checked_field(rule_options[0].name)
            expect(page).to have_unchecked_field(rule_options[1].name)
          end

          it_behaves_like "displays_all_categories"
          it_behaves_like "displays_all_allowed_areas"
          it_behaves_like "displays_all_option_titles"
          it_behaves_like "displays_all_rule_options"
        end
      end
    end

    describe "入力内容確認ページ", js: true do
      include_context "有効な登録内容の入力"

      describe "確認ページの表示" do
        it "入力した内容が表示される" do
          expect(page).to have_content(spot.name)
          expect(page).to have_content(spot.address)
          expect(page).to have_content(categories[0].name)
          expect(page).to have_content(allowed_areas[0].area)
          expect(page).to have_content(spot.official_site)
          expect(page).to have_content(rule_options[0].name)
          expect(page).not_to have_content(rule_options[1].name)
        end

        it "入力画面に戻るボタンがある" do
          expect(page).to have_button("入力画面に戻る")
        end
      end

      describe "登録の完了" do
        it "スポットを登録できる" do
          expect { click_button "登録を完了する"}.to change { Spot.count }.by(1)
          expect(Spot.last.name).to eq(spot.name)
          expect(Spot.last.latitude).to eq(spot.latitude)
          expect(Spot.last.longitude).to eq(spot.longitude)
          expect(Spot.last.address).to eq(spot.address)
          expect(Spot.last.official_site).to eq(spot.official_site)
          expect(Spot.last.allowed_area_id).to eq(allowed_areas[0].id)
          expect(Spot.last.category_id).to eq(categories[0].id)
        end

        it "スポットに紐づく同伴ルールを登録できる" do
          expect { click_button "登録を完了する"}.to change { Rule.count }.by(RuleOption.count)
          expect(Spot.last.rule.find_by(rule_option_id: rule_options[0].id).answer).to eq("1")
          expect(Spot.last.rule.find_by(rule_option_id: rule_options[1].id).answer).to eq("0")
        end
      end
    end

    describe "入力内容の訂正ページ", js: true do
      let(:corrected_spot) { build(:spot) }

      include_context "有効な登録内容の入力"

      before { click_button "入力画面に戻る" }

      describe "戻った入力画面の表示" do
        it "入力欄に、最初に入力した内容が入っている" do
          expect(find("#form_spot_name").value).to eq(spot.name)
          expect(find("#form_spot_lat", visible: false).value.to_f).to eq(spot.latitude)
          expect(find("#form_spot_lng", visible: false).value.to_f).to eq(spot.longitude)
          expect(find("#form_spot_address").value).to eq(spot.address)
          expect(find("#form_spot_official_site").value).to eq(spot.official_site)
          expect(page).to have_select("スポットカテゴリー", selected: categories[0].name)
          expect(page).to have_select("同伴可能エリア", selected: allowed_areas[0].area)
          expect(page).to have_checked_field(rule_options[0].name)
          expect(page).to have_unchecked_field(rule_options[1].name)
        end

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_option_titles"
        it_behaves_like "displays_all_rule_options"
      end
    end
  end

  describe "スポット詳細ページ" do
    let!(:spot) { create(:spot, :with_rules) }
    let(:attached_rules) { spot.rule.where(answer: "1") }
    let(:unattached_rules) { spot.rule.where(answer: "0") }

    before { visit spot_path(spot.id) }

    it "スポットのデータが表示される" do
      expect(page).to have_content(spot.name)
      expect(page).to have_content(spot.address)
      expect(page).to have_content(spot.category.name)
      expect(page).to have_content(spot.allowed_area.area)

      attached_rules.each do |attached_rule|
        expect(page).to have_content(attached_rule.rule_option.name)
      end

      unattached_rules.each do |unattached_rule|
        expect(page).not_to have_content(unattached_rule.rule_option.name)
      end
    end
  end

  describe "スポットの更新" do
    let!(:spot) { create(:spot, :with_rules) }
    let!(:rule_1) { create(:rule, spot_id: spot.id, rule_option_id: rule_options[0].id, answer: "1") }
    let!(:rule_2) { create(:rule, spot_id: spot.id, rule_option_id: rule_options[1].id, answer: "0") }
    let!(:rule_3) { create(:rule, spot_id: spot.id, rule_option_id: rule_options[2].id, answer: "0") }
    let!(:updated_spot) { build(:spot) }

    shared_context "有効な更新内容の入力" do
      before do
        sign_in user
        visit spot_path(spot.id)
        click_link "スポットの登録内容を更新する"
        fill_in "form_spot_name", with: updated_spot.name
        fill_in "form_spot_address", with: updated_spot.address
        page.execute_script("document.getElementById('form_spot_lat').value = #{updated_spot.latitude}")
        page.execute_script("document.getElementById('form_spot_lng').value = #{updated_spot.longitude}")
        select categories[1].name, from: "スポットカテゴリー"
        select allowed_areas[1].area, from: "同伴可能エリア"
        fill_in "form_spot_official_site", with: updated_spot.official_site
        check rule_options[1].name
        uncheck rule_options[0].name
        click_button "入力内容の確認へ"
      end
    end

    describe "更新内容の入力ページ" do
      describe "入力項目の表示" do
        before do
          sign_in user
          visit spot_path(spot.id)
          click_link "スポットの登録内容を更新する"
        end

        it "更新対象のスポットのデータが入力欄に入っている" do
          expect(find("#form_spot_name").value).to eq(spot.name)
          expect(find("#form_spot_lat", visible: false).value.to_f).to eq(spot.latitude)
          expect(find("#form_spot_lng", visible: false).value.to_f).to eq(spot.longitude)
          expect(find("#form_spot_address").value).to eq(spot.address)
          expect(find("#form_spot_official_site").value).to eq(spot.official_site)
          expect(page).to have_select("スポットカテゴリー", selected: spot.category.name)
          expect(page).to have_select("同伴可能エリア", selected: spot.allowed_area.area)
          expect(page).to have_checked_field(rule_options[0].name)
          expect(page).to have_unchecked_field(rule_options[1].name)
        end

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_option_titles"
        it_behaves_like "displays_all_rule_options"
      end

      describe "更新内容の入力" do
        context "入力内容が妥当なとき", js: true do
          include_context "有効な更新内容の入力"

          it "確認ページへ遷移する" do
            expect(current_path).to eq(edit_confirm_spot_path(spot.id))
          end
        end

        context "入力内容が不正なとき", js: true do
          before do
            sign_in user
            visit spot_path(spot.id)
            click_link "スポットの登録内容を更新する"
            fill_in "form_spot_name", with: nil
            fill_in "form_spot_address", with: nil
            page.execute_script("document.getElementById('form_spot_lat').value = null")
            page.execute_script("document.getElementById('form_spot_lng').value = null")
            fill_in "form_spot_official_site", with: nil
            check rule_options[1].name
            click_button "入力内容の確認へ"
          end

          it "バリデーションエラーが表示される" do
            expect(page).to have_content("#{Spot.human_attribute_name(:name)}を入力してください")
            expect(page).to have_content("#{Spot.human_attribute_name(:address)}を入力してください")
          end

          it "addressカラムにエラーがあるとき、latitudeカラム、longitudeカラムのバリデーションエラーは表示されない" do
            expect(page).not_to have_content("#{Spot.human_attribute_name(:latitude)}を入力してください")
            expect(page).not_to have_content("#{Spot.human_attribute_name(:longitude)}を入力してください")
          end

          it "チェックを追加した同伴ルールには、そのままチェックが付く" do
            expect(page).to have_checked_field(rule_options[1].name)
          end

          it_behaves_like "displays_all_categories"
          it_behaves_like "displays_all_allowed_areas"
          it_behaves_like "displays_all_option_titles"
          it_behaves_like "displays_all_rule_options"
        end
      end
    end

    describe "入力内容確認ページ", js: true do
      include_context "有効な更新内容の入力"

      describe "確認ページの表示" do
        it "入力した内容が表示される" do
          expect(page).to have_content(updated_spot.name)
          expect(page).to have_content(updated_spot.address)
          expect(page).to have_content(categories[1].name)
          expect(page).to have_content(allowed_areas[1].area)
          expect(page).to have_content(updated_spot.official_site)
          expect(page).to have_content(rule_options[1].name)
          expect(page).not_to have_content(rule_options[0].name)
        end

        it "入力画面に戻るボタンがある" do
          expect(page).to have_button("入力画面に戻る")
        end
      end

      describe "更新の完了" do
        it "スポットを更新できる" do
          expect { click_button "更新を完了する"}.to change { Spot.count }.by(0)
          expect(spot.reload.name).to eq(updated_spot.name)
          expect(spot.reload.latitude).to eq(updated_spot.latitude)
          expect(spot.reload.longitude).to eq(updated_spot.longitude)
          expect(spot.reload.address).to eq(updated_spot.address)
          expect(spot.reload.official_site).to eq(updated_spot.official_site)
          expect(spot.reload.allowed_area_id).to eq(allowed_areas[1].id)
          expect(spot.reload.category_id).to eq(categories[1].id)
        end

        it "スポットに紐づく同伴ルールを更新できる" do
          expect { click_button "更新を完了する"}.to change { Rule.count }.by(0)
          expect(spot.reload.rule.find_by(rule_option_id: rule_options[1].id).answer).to eq("1")
          expect(spot.reload.rule.find_by(rule_option_id: rule_options[0].id).answer).to eq("0")
        end
      end
    end

    describe "入力内容の訂正ページ", js: true do
      let(:corrected_spot) { build(:spot) }

      include_context "有効な更新内容の入力"

      before { click_button "入力画面に戻る" }

      describe "戻った入力画面の表示" do
        it "入力欄に、最初に入力した内容が入っている" do
          expect(find("#form_spot_name").value).to eq(updated_spot.name)
          expect(find("#form_spot_lat", visible: false).value.to_f).to eq(updated_spot.latitude)
          expect(find("#form_spot_lng", visible: false).value.to_f).to eq(updated_spot.longitude)
          expect(find("#form_spot_address").value).to eq(updated_spot.address)
          expect(find("#form_spot_official_site").value).to eq(updated_spot.official_site)
          expect(page).to have_select("スポットカテゴリー", selected: categories[1].name)
          expect(page).to have_select("同伴可能エリア", selected: allowed_areas[1].area)
          expect(page).to have_checked_field(rule_options[1].name)
          expect(page).to have_unchecked_field(rule_options[0].name)
        end

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_option_titles"
        it_behaves_like "displays_all_rule_options"
      end
    end
  end

  describe "スポットの検索", js: true do
    let!(:spot) { create(:spot, :real_spot) }

    before do
      sign_in user
      visit root_path
      click_link "新しいお出かけスポットの登録"
    end

    context "マップに存在する特定の場所を検索したとき" do
      it "所在地・緯度経度が自動で入力される" do
        fill_in "form_search_spot", with: spot.name
        click_button "検索"
        sleep 0.1

        expect(find("#form_spot_address").value).to eq(spot.address)
        expect(find("#form_spot_lat", visible: false).value).to eq(spot.latitude.to_s)
        expect(find("#form_spot_lng", visible: false).value).to eq(spot.longitude.to_s)
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
end

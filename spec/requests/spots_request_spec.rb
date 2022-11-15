require 'rails_helper'
require 'support/shared_examples_spot_display'

RSpec.describe "Spots", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot, :with_rules) }
  let!(:another_spot) { create(:spot) }

  let!(:categories) { create_list(:category, 3) }
  let!(:allowed_areas) { create_list(:allowed_area, 3) }
  let!(:option_titles) { create_list(:option_title, 3) }

  let(:attached_rules) { spot.rule.where(answer: "1") }
  let(:not_attached_rules) { spot.rule.where(answer: "0") }

  describe "GET" do
    describe "GET /index" do
      before do
        get spots_path
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(:success)
      end

      it "登録されているすべてのスポットのデータが表示される" do
        expect(response.body).to include(spot.name)
        expect(response.body).to include(spot.address)
        expect(response.body).to include(spot.category.name)

        expect(response.body).to include(another_spot.name)
        expect(response.body).to include(another_spot.address)
        expect(response.body).to include(another_spot.category.name)
      end

      it "各スポットの詳細ページへのリンクがある" do
        expect(css_select(".spot_detail").first.attributes["href"].value).to include(spot_path(spot.id))
        expect(css_select(".spot_detail").last.attributes["href"].value).to include(spot_path(another_spot.id))
      end
    end

    describe "GET /new" do
      context "ログインしているとき" do
        before do
          sign_in user
          get new_spot_path
        end

        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it_behaves_like "display_all_categories"
        it_behaves_like "display_all_allowed_areas"
        it_behaves_like "display_all_option_titles"
      end

      context "ログインしていないとき" do
        it "ログインページへリダイレクトする" do
          get new_spot_path
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    describe "GET /show" do
      context "ログインしているとき" do
        before do
          sign_in user
          get spot_path(spot.id)
        end

        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it "スポットのデータが表示される" do
          expect(response.body).to include(spot.name)
          expect(response.body).to include(spot.address)
          expect(response.body).to include(spot.category.name)
          expect(response.body).to include(spot.allowed_area.area)
        end

        context "スポットに適用される同伴条件の場合" do
          it "該当のルールが表示される" do
            attached_rules.each do |attached_rule|
              expect(response.body).to include(attached_rule.rule_option.name)
            end
          end
        end

        context "スポットに適用されない同伴条件の場合" do
          it "該当のルールは表示されない" do
            not_attached_rules.each do |not_attached_rule|
              expect(response.body).not_to include(not_attached_rule.rule_option.name)
            end
          end
        end
      end

      context "ログインしていないとき" do
        it "ログインページへリダイレクトする" do
          get new_spot_path
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    describe "GET /edit" do
      context "ログインしているとき" do
        before do
          sign_in user
          get edit_spot_path(spot.id)
        end

        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it "スポットのデータが入力欄に表示される" do
          def find_css_value(css_id)
            css_select(css_id).first.attributes["value"].value
          end

          def find_css_selected(css_id)
            css_select(css_id).first.children.each do |child|
              if child.attributes["selected"].present?
                return child.attributes["value"].value
              end
            end
          end

          expect(find_css_value("#form_spot_name")).to eq(spot.name)
          expect(find_css_value("#form_spot_address")).to eq(spot.address)
          expect(find_css_value("#form_lat")).to eq(spot.latitude.to_s)
          expect(find_css_value("#form_lng")).to eq(spot.longitude.to_s)
          expect(find_css_selected("#form_allowed_area")).to eq(spot.allowed_area_id.to_s)
          expect(find_css_selected("#form_spot_category")).to eq(spot.category_id.to_s)
          expect(find_css_value("#form_official_site")).to eq(spot.official_site)
        end

        context "登録スポットに適用される同伴条件として保存されているルール" do
          let(:attached_rule_opt_ids) { attached_rules.pluck(:rule_option_id) }

          it "該当のルールにはすべてにチェックが入っている" do
            attached_rule_opt_ids.each do |attached_rule_opt_id|
              expect(css_select("##{attached_rule_opt_id}").first.attributes["checked"].present?).to be(true)
            end
          end
        end

        context "登録スポットに適用されない同伴条件として保存されているルール" do
          let(:not_attached_rule_opt_ids) { not_attached_rules.pluck(:rule_option_id) }

          it "該当のルールにはチェックが入っていない" do
            not_attached_rule_opt_ids.each do |not_attached_rule_opt_id|
              expect(css_select("##{not_attached_rule_opt_id}").first.attributes["checked"].present?).to be(false)
            end
          end
        end

        it_behaves_like "display_all_categories"
        it_behaves_like "display_all_allowed_areas"
        it_behaves_like "display_all_option_titles"
      end

      context "ログインしていないとき" do
        it "ログイン画面にリダイレクトされる" do
          get edit_spot_path(spot.id)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end

  describe "POST" do
    let!(:allowed_area) { allowed_areas.first }
    let!(:category) { categories.first }

    let(:spot_params) do
      FactoryBot.attributes_for(:spot, :with_rules, allowed_area_id: allowed_area.id, category_id: category.id)
    end
    let(:answer_params) do
      keys = RuleOption.pluck(:id).map(&:to_s)
      values = Array.new(RuleOption.count - 2, "0")
      values.push("1", "1")

      return answer_params = keys.zip(values).to_h
    end
    let(:params) do
      {
        spot_attributes: spot_params,
        rule_attributes: { answer: answer_params }
      }
    end

    let(:session_spot_params) { session[:params]["spot_attributes"] }
    let(:session_rule_params) { session[:params]["rule_attributes"]["answer"] }

    let(:invalid_spot_params) { FactoryBot.attributes_for(:spot, :invalid_spot) }
    let(:invalid_params) do
      {
        spot_attributes: invalid_spot_params,
        rule_attributes: { answer: {} }
      }
    end

    describe "POST /new_confirm" do
      context "送信されたデータが妥当なとき" do
        before do
          sign_in user
          post new_confirm_spots_path, params: { spot_register_form: params }
        end

        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it "送信されたパラメータがセッションに保存されている" do
          spot_params_to_s = spot_params.transform_keys(&:to_s).transform_values(&:to_s)

          expect(session_spot_params.to_h).to eq(spot_params_to_s)
          expect(session_rule_params.to_h).to eq(answer_params)
        end

        it "送信されたパラメータのデータが表示される" do
          expect(response.body).to include(spot_params[:name])
          expect(response.body).to include(spot_params[:address])
          expect(response.body).to include(category.name)
          expect(response.body).to include(allowed_area.area)
        end

        context "パラメータに、登録スポットに適用される同伴条件として保存されているルール" do
          it "該当のルールが表示される" do
            answer_params.keys.each do |key|
              if answer_params[key] == "1"
                expect(response.body).to include(RuleOption.find(key).name)
              end
            end
          end
        end

        context "パラメータに、登録スポットに適用される同伴条件として保存されているルール" do
          it "該当のルールは表示されない" do
            answer_params.keys.each do |key|
              if answer_params[key] == "0"
                expect(response.body).not_to include(RuleOption.find(key).name)
              end
            end
          end
        end
      end

      context "送信されたデータが不正なとき" do
        before do
          sign_in user
          post new_confirm_spots_path, params: { spot_register_form: invalid_params }
        end

        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it "バリデーションエラーが表示される" do
          expect(response.body).to include("#{Spot.human_attribute_name(:name)}を入力してください")
          expect(response.body).to include("#{Spot.human_attribute_name(:address)}を入力してください")
          expect(response.body).to include("#{Spot.human_attribute_name(:category)}を入力してください")
          expect(response.body).to include("#{Spot.human_attribute_name(:allowed_area)}を入力してください")
        end

        it "addressカラムにエラーがあるとき、latitudeカラム、longitudeカラムのバリデーションエラーは表示されない" do
          expect(response.body).to include("#{Spot.human_attribute_name(:address)}を入力してください")
          expect(response.body).not_to include("#{Spot.human_attribute_name(:latitude)}を入力してください")
          expect(response.body).not_to include("#{Spot.human_attribute_name(:longitude)}を入力してください")
        end
      end
    end

    describe "POST /back_new" do
      before do
        sign_in user
        post new_confirm_spots_path, params: { spot_register_form: params }
        post back_new_spots_path
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(:success)
      end

      it "セッションに保存されているスポットのデータが表示される" do
        def find_css_value(css_id)
          css_select(css_id).first.attributes["value"].value
        end

        def find_css_selected(css_id)
          css_select(css_id).first.children.each do |child|
            if child.attributes["selected"].present?
              return child.attributes["value"].value
            end
          end
        end

        expect(find_css_value("#form_spot_name")).to eq(session_spot_params["name"])
        expect(find_css_value("#form_spot_address")).to eq(session_spot_params["address"])
        expect(find_css_value("#form_lat")).to eq(session_spot_params["latitude"])
        expect(find_css_value("#form_lng")).to eq(session_spot_params["longitude"])
        expect(find_css_selected("#form_allowed_area")).to eq(session_spot_params["allowed_area_id"])
        expect(find_css_selected("#form_spot_category")).to eq(session_spot_params["category_id"])
        expect(find_css_value("#form_official_site")).to eq(session_spot_params["official_site"])
      end

      context "セッションに、登録スポットに適用される同伴条件として保存されているルール" do
        let(:checked_rule_opt_ids_in_session) do
          session_rule_params.keys.select do |key|
            session_rule_params[key] == "1"
          end
        end

        it "該当のルールにはすべてにチェックが入っている" do
          checked_rule_opt_ids_in_session.each do |checked_rule_opt_id|
            expect(css_select("##{checked_rule_opt_id}").first.attributes["checked"].present?).to be(true)
          end
        end
      end

      context "セッションに、登録スポットに適用されない同伴条件として保存されているルール" do
        let(:unchecked_rule_opt_ids_in_session) do
          session_rule_params.keys.select do |key|
            session_rule_params[key] == "0"
          end
        end

        it "該当のルールにはチェックが入っていない" do
          unchecked_rule_opt_ids_in_session.each do |unchecked_rule_opt_id|
            expect(css_select("##{unchecked_rule_opt_id}").first.attributes["checked"].present?).to be(false)
          end
        end
      end

      it_behaves_like "display_all_categories"
      it_behaves_like "display_all_allowed_areas"
      it_behaves_like "display_all_option_titles"
    end

    describe "POST /create" do
      context "セッションに保存されたデータが妥当な場合" do
        before do
          sign_in user
          post new_confirm_spots_path, params: { spot_register_form: params }
        end

        it "HTTPリクエストが成功する" do
          post spots_path
          expect(response.status).to eq(302)
        end

        it "スポットを登録できる" do
          expect do
            post spots_path
          end.to change { Spot.count }.by(1)
        end

        it "スポットの同伴ルールが、ルールの選択肢分だけ登録される" do
          post spots_path
          expect(Spot.last.rule.count).to eq(RuleOption.count)
        end

        it "スポットの登録履歴が保存される" do
          expect do
            post spots_path
          end.to change { SpotHistory.count }.by(1)

          expect(SpotHistory.last.history).to eq("新規登録")
        end

        it "登録後、登録したスポットの詳細ページにリダイレクトする" do
          post spots_path
          expect(response).to redirect_to(spot_path(Spot.last))
        end
      end

      context "セッションに保存されたデータが不正な場合" do
        before do
          sign_in user
          post new_confirm_spots_path, params: { spot_register_form: invalid_params }
        end

        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it "スポットを登録できない" do
          expect do
            post spots_path
          end.to change { Spot.count }.by(0)
        end

        it "スポットの同伴ルールは登録されない" do
          expect do
            post spots_path
          end.to change { Rule.count }.by(0)
        end

        it "スポットの登録履歴は保存されない" do
          expect do
            post spots_path
          end.to change { SpotHistory.count }.by(0)
        end
      end
    end
  end

  describe "PATCH" do
    let!(:updated_allowed_area) { allowed_areas.last }
    let!(:updated_category) { categories.last }

    let(:updated_spot_params) do
      FactoryBot.attributes_for(:spot, :with_rules, allowed_area_id: updated_allowed_area.id, category_id: updated_category.id)
    end
    let(:updated_answer_params) do
      keys = RuleOption.pluck(:id).map(&:to_s)
      values = Array.new(RuleOption.count - 2, "1")
      values.push("1", "0")

      return answer_params = keys.zip(values).to_h
    end
    let(:updated_params) do
      {
        spot_attributes: updated_spot_params,
        rule_attributes: { answer: updated_answer_params }
      }
    end

    let(:session_updated_spot_params) { session[:params]["spot_attributes"] }
    let(:session_updated_rule_params) { session[:params]["rule_attributes"]["answer"] }

    let(:invalid_spot_params) { FactoryBot.attributes_for(:spot, :invalid_spot) }
    let(:invalid_params) do
      {
        spot_attributes: invalid_spot_params,
        rule_attributes: { answer: {} }
      }
    end

    describe "PATCH /edit_confirm" do
      before do
        sign_in user
        patch edit_confirm_spot_path(spot.id), params: { spot_register_form: updated_params }
      end

      context "送信されたデータが妥当なとき" do
        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it "送信されたパラメータがセッションに保存されている" do
          updated_spot_params_to_s = updated_spot_params.transform_keys(&:to_s).transform_values(&:to_s)

          expect(session_updated_spot_params.to_h).to eq(updated_spot_params_to_s)
          expect(session_updated_rule_params.to_h).to eq(updated_answer_params)
        end

        it "送信されたパラメータのデータが表示される" do
          expect(response.body).to include(updated_spot_params[:name])
          expect(response.body).to include(updated_spot_params[:address])
          expect(response.body).to include(updated_category.name)
          expect(response.body).to include(updated_allowed_area.area)
        end

        context "パラメータに、登録スポットに適用される同伴条件として保存されているルール" do
          it "該当のルールが表示される" do
            updated_answer_params.keys.each do |key|
              if updated_answer_params[key] == "1"
                expect(response.body).to include(RuleOption.find(key).name)
              end
            end
          end
        end

        context "パラメータに、登録スポットに適用される同伴条件として保存されているルール" do
          it "該当のルールは表示されない" do
            updated_answer_params.keys.each do |key|
              if updated_answer_params[key] == "0"
                expect(response.body).not_to include(RuleOption.find(key).name)
              end
            end
          end
        end
      end

      context "送信されたデータが不正なとき" do
        before do
          sign_in user
          post new_confirm_spots_path, params: { spot_register_form: invalid_params }
        end

        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it "バリデーションエラーが表示される" do
          expect(response.body).to include("#{Spot.human_attribute_name(:name)}を入力してください")
          expect(response.body).to include("#{Spot.human_attribute_name(:address)}を入力してください")
          expect(response.body).to include("#{Spot.human_attribute_name(:category)}を入力してください")
          expect(response.body).to include("#{Spot.human_attribute_name(:allowed_area)}を入力してください")
        end

        it "addressカラムにエラーがあるとき、latitudeカラム、longitudeカラムのバリデーションエラーは表示されない" do
          expect(response.body).to include("#{Spot.human_attribute_name(:address)}を入力してください")
          expect(response.body).not_to include("#{Spot.human_attribute_name(:latitude)}を入力してください")
          expect(response.body).not_to include("#{Spot.human_attribute_name(:longitude)}を入力してください")
        end
      end
    end

    describe "PATCH /back_edit" do
      before do
        sign_in user
        patch edit_confirm_spot_path(spot.id), params: { spot_register_form: updated_params }
        patch back_edit_spot_path(spot.id)
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(:success)
      end

      it "セッションに保存されているスポットのデータが表示される" do
        def find_css_value(css_id)
          css_select(css_id).first.attributes["value"].value
        end

        def find_css_selected(css_id)
          css_select(css_id).first.children.each do |child|
            if child.attributes["selected"].present?
              return child.attributes["value"].value
            end
          end
        end

        expect(find_css_value("#form_spot_name")).to eq(session_updated_spot_params["name"])
        expect(find_css_value("#form_spot_address")).to eq(session_updated_spot_params["address"])
        expect(find_css_value("#form_lat")).to eq(session_updated_spot_params["latitude"])
        expect(find_css_value("#form_lng")).to eq(session_updated_spot_params["longitude"])
        expect(find_css_selected("#form_allowed_area")).to eq(session_updated_spot_params["allowed_area_id"])
        expect(find_css_selected("#form_spot_category")).to eq(session_updated_spot_params["category_id"])
        expect(find_css_value("#form_official_site")).to eq(session_updated_spot_params["official_site"])
      end

      context "セッションに、登録スポットに適用される同伴条件として保存されているルール" do
        let(:checked_rule_opt_ids_in_session) do
          session_updated_rule_params.keys.select do |key|
            session_updated_rule_params[key] == "1"
          end
        end

        it "該当のルールにはすべてにチェックが入っている" do
          checked_rule_opt_ids_in_session.each do |checked_rule_opt_id|
            expect(css_select("##{checked_rule_opt_id}").first.attributes["checked"].present?).to be(true)
          end
        end
      end

      context "セッションに、登録スポットに適用されない同伴条件として保存されているルール" do
        let(:unchecked_rule_opt_ids_in_session) do
          session_updated_rule_params.keys.select do |key|
            session_updated_rule_params[key] == "0"
          end
        end

        it "該当のルールにはチェックが入っていない" do
          unchecked_rule_opt_ids_in_session.each do |unchecked_rule_opt_id|
            expect(css_select("##{unchecked_rule_opt_id}").first.attributes["checked"].present?).to be(false)
          end
        end
      end

      it_behaves_like "display_all_categories"
      it_behaves_like "display_all_allowed_areas"
      it_behaves_like "display_all_option_titles"
    end

    describe "PATCH /update" do
      context "セッションに保存されたデータが妥当な場合" do
        before do
          sign_in user
          patch edit_confirm_spot_path(spot.id), params: { spot_register_form: updated_params }
        end

        it "HTTPリクエストが成功する" do
          patch spot_path(spot.id)
          expect(response.status).to eq(302)
        end

        it "スポットを更新できる" do
          expect do
            patch spot_path(spot.id)

            expect(spot.reload.name).to eq(updated_spot_params[:name])
            expect(spot.reload.address).to eq(updated_spot_params[:address])
            expect(spot.reload.latitude).to eq(updated_spot_params[:latitude])
            expect(spot.reload.longitude).to eq(updated_spot_params[:longitude])
            expect(spot.reload.allowed_area_id).to eq(updated_spot_params[:allowed_area_id])
            expect(spot.reload.category_id).to eq(updated_spot_params[:category_id])
            expect(spot.reload.official_site).to eq(updated_spot_params[:official_site])
          end.to change { Spot.count }.by(0)
        end

        it "スポットの同伴ルールを変更できる" do
          patch spot_path(spot.id)

          updated_answer_params.keys.each do |key|
            expect(spot.rule.find_by(rule_option_id: key).answer).to eq(updated_answer_params["#{key}"])
          end
        end

        it "スポットの変更履歴が保存される" do
          expect do
            patch spot_path(spot.id)
          end.to change { SpotHistory.count }.by(1)

          expect(SpotHistory.last.history).to eq("更新")
        end

        it "更新後、更新したスポットの詳細ページにリダイレクトする" do
          patch spot_path(spot.id)
          expect(response).to redirect_to(spot_path(spot.id))
        end
      end

      context "セッションに保存されたデータが不正な場合" do
        before do
          sign_in user
          post new_confirm_spots_path, params: { spot_register_form: invalid_params }
        end

        it "HTTPリクエストが成功する" do
          expect(response).to have_http_status(:success)
        end

        it "スポットを変更できない" do
          expect do
            patch spot_path(spot.id)

            expect(spot.name_changed?).to eq(false)
            expect(spot.address_changed?).to eq(false)
            expect(spot.latitude_changed?).to eq(false)
            expect(spot.longitude_changed?).to eq(false)
            expect(spot.allowed_area_id_changed?).to eq(false)
            expect(spot.category_id_changed?).to eq(false)
            expect(spot.official_site_changed?).to eq(false)
          end.to change { Spot.count }.by(0)
        end

        it "スポットの同伴ルールは変更されない" do
          patch spot_path(spot.id)

          spot.rule.each do |rule|
            expect(rule.answer_changed?).to eq(false)
          end
        end

        it "スポットの登録履歴は保存されない" do
          expect do
            patch spot_path(spot.id)
          end.to change { SpotHistory.count }.by(0)
        end
      end
    end
  end
end


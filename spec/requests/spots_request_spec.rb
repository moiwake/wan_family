require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Spots", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot, :with_rules) }

  let!(:categories) { create_list(:category, 3) }
  let!(:allowed_areas) { create_list(:allowed_area, 3) }
  let!(:option_titles) { create_list(:option_title, 3) }
  let(:rule_options) { RuleOption.all.limit(4) }

  describe "GET" do
    describe "GET /new" do
      context "ログインしているとき" do
        before do
          sign_in user
          get new_spot_path
        end

        it "セッションにパラメータのデータが保存されてない" do
          expect(session["params"].to_h).to eq({})
        end

        it_behaves_like "returns http success"
      end

      context "ログインしていないとき" do
        before { get new_spot_path }

        it_behaves_like "redirects to login page"
      end
    end

    describe "GET /show" do
      before do
        sign_in user
        get spot_path(spot.id)
      end

      it_behaves_like "returns http success"
    end

    describe "GET /edit" do
      context "ログインしているとき" do
        before do
          sign_in user
          get edit_spot_path(spot.id)
        end

        it_behaves_like "returns http success"
      end

      context "ログインしていないとき" do
        before { get edit_spot_path(spot.id) }

        it_behaves_like "redirects to login page"
      end
    end
  end

  describe "POST" do
    let(:params) { { "spot_attributes" => spot_params, "rules_attributes" => rules_params } }
    let(:spot_params) do
      FactoryBot.attributes_for(:spot, allowed_area_id: allowed_areas[0].id, category_id: categories[0].id)
      .transform_keys(&:to_s).transform_values(&:to_s)
    end
    let(:rules_params) do
      {
        "#{rule_options[0].id}" => { "answer" => "1" },
        "#{rule_options[1].id}" => { "answer" => "1" },
        "#{rule_options[2].id}" => { "answer" => "0" },
        "#{rule_options[3].id}" => { "answer" => "0" },
      }
    end

    let(:invalid_params) { { spot_attributes: invalid_spot_params, rules_attributes: { nil => {} } } }
    let(:invalid_spot_params) { FactoryBot.attributes_for(:spot, :invalid_spot) }

    describe "POST /new_confirm" do
      context "ログインしているとき" do
        before { sign_in user }

        context "送信されたパラメータが妥当なとき" do
          before { post new_confirm_spots_path, params: { spot_register_form: params } }

          it "送信されたパラメータがセッションに保存されている" do
            expect(session[:params]["spot_attributes"]).to eq(spot_params)
            expect(session[:params]["rules_attributes"]).to eq(rules_params)
          end

          it_behaves_like "returns http success"
        end

        context "送信されたパラメータが不正なとき" do
          before { post new_confirm_spots_path, params: { spot_register_form: invalid_params } }

          it_behaves_like "returns http success"
        end

        context "ActionController::ParameterMissingのエラーが発生した場合"do
          before do
            allow_any_instance_of(SpotsController)
            .to receive(:form_params)
            .and_raise(ActionController::ParameterMissing, :spot_register_form)

            get new_confirm_spots_path
          end

          it "back_newへリダイレクトする" do
            expect(response).to redirect_to(back_new_spots_path)
          end
        end
      end

      context "ログインしていないとき" do
        before { post new_confirm_spots_path, params: { spot_register_form: params } }

        it_behaves_like "redirects to login page"
      end
    end

    describe "POST /back_new" do
      context "ログインしているとき" do
        before do
          sign_in user
          post new_confirm_spots_path, params: { spot_register_form: params }
          post back_new_spots_path
        end

        it "セッションに、入力画面で送信したデータが保存されている" do
          expect(session[:params]["spot_attributes"]).to eq(spot_params)
          expect(session[:params]["rules_attributes"]).to eq(rules_params)
        end

        it_behaves_like "returns http success"
      end

      context "ログインしていないとき" do
        before do
          post new_confirm_spots_path, params: { spot_register_form: params }
          post back_new_spots_path
        end

        it_behaves_like "redirects to login page"
      end
    end

    describe "POST /create" do
      subject { post spots_path }

      before { sign_in user }

      context "セッションに保存されたデータが妥当な場合" do
        let(:new_spot) { Spot.last }
        let(:new_rules) { new_spot.rules }

        before { post new_confirm_spots_path, params: { spot_register_form: params } }

        it "スポットを登録できる" do
          expect { subject }.to change { Spot.count }.by(1)
          expect(new_spot.name).to eq(spot_params["name"])
          expect(new_spot.latitude).to eq(spot_params["latitude"].to_i)
          expect(new_spot.longitude).to eq(spot_params["longitude"].to_i)
          expect(new_spot.address).to eq(spot_params["address"])
          expect(new_spot.official_site).to eq(spot_params["official_site"])
          expect(new_spot.allowed_area_id).to eq(spot_params["allowed_area_id"].to_i)
          expect(new_spot.category_id).to eq(spot_params["category_id"].to_i)
        end

        it "スポットの同伴ルールが、選択肢分だけ登録される" do
          subject
          expect(new_rules.count).to eq(rule_options.count)

          new_rules.each_with_index do |new_rule, i|
            expect(new_rule.rule_option_id).to eq(rules_params.keys[i].to_i)
            expect(new_rule.answer).to eq(rules_params.values[i]["answer"])
          end
        end

        it "スポットの登録履歴が保存される" do
          expect { subject }.to change { SpotHistory.count }.by(1)
          expect(SpotHistory.last.history).to eq("新規登録")
        end

        it "登録後、登録したスポットの詳細ページにリダイレクトする" do
          subject
          expect(response).to redirect_to(spot_path(new_spot))
        end
      end

      context "セッションに保存されたデータが不正な場合" do
        before { post new_confirm_spots_path, params: { spot_register_form: invalid_params } }

        it "スポットを登録できない" do
          expect { subject }.to change { Spot.count }.by(0)
        end

        it "スポットの同伴ルールは登録されない" do
          expect { subject }.to change { Rule.count }.by(0)
        end

        it "スポットの登録履歴は保存されない" do
          expect { subject }.to change { SpotHistory.count }.by(0)
        end

        it_behaves_like "returns http success"
      end

      context "create処理がすべて終わったとき" do
        before do
          post new_confirm_spots_path, params: { spot_register_form: params }
          subject
        end

        it "セッションにパラメータのデータが保存されてない" do
          expect(session["params"].to_h).to eq({})
        end
      end
    end
  end

  describe "PATCH" do
    let(:updated_params) { { spot_attributes: updated_spot_params, rules_attributes: updated_rules_params } }
    let(:updated_spot_params) do
      FactoryBot.attributes_for(:spot, allowed_area_id: allowed_areas[1].id, category_id: categories[1].id)
      .transform_keys(&:to_s).transform_values(&:to_s)
    end
    let(:updated_rules_params) do
      {
        "#{rule_options[0].id}" => { "answer" => "0" },
        "#{rule_options[1].id}" => { "answer" => "0" },
        "#{rule_options[2].id}" => { "answer" => "1" },
        "#{rule_options[3].id}" => { "answer" => "1" },
      }
    end

    let(:invalid_spot_params) { FactoryBot.attributes_for(:spot, :invalid_spot, allowed_area_id: nil, category_id: nil) }
    let(:invalid_params) { { spot_attributes: invalid_spot_params, rules_attributes: { nil => {} } } }

    describe "PATCH /edit_confirm" do
      context "ログインしているとき" do
        before { sign_in user }

        context "送信されたパラメータが妥当なとき" do
          before { patch edit_confirm_spot_path(spot.id), params: { spot_register_form: updated_params } }

          it "送信されたパラメータがセッションに保存されている" do
            expect(session[:params]["spot_attributes"]).to eq(updated_spot_params)
            expect(session[:params]["rules_attributes"]).to eq(updated_rules_params)
          end

          it_behaves_like "returns http success"
        end

        context "送信されたパラメータが不正なとき" do
          before { patch edit_confirm_spot_path(spot.id), params: { spot_register_form: invalid_params } }

          it_behaves_like "returns http success"
        end

        context "ActionController::ParameterMissingのエラーが発生した場合"do
          before do
            allow_any_instance_of(SpotsController)
            .to receive(:form_params)
            .and_raise(ActionController::ParameterMissing, :spot_register_form)

            get edit_confirm_spot_path(spot.id)
          end

          it "back_editへリダイレクトする" do
            expect(response).to redirect_to(back_edit_spot_path(spot.id))
          end
        end
      end

      context "ログインしていないとき" do
        before { patch edit_confirm_spot_path(spot.id), params: { spot_register_form: invalid_params } }

        it_behaves_like "redirects to login page"
      end
    end

    describe "PATCH /back_edit" do
      context "ログインしているとき" do
        before do
          sign_in user
          patch edit_confirm_spot_path(spot.id), params: { spot_register_form: updated_params }
          patch back_edit_spot_path(spot.id)
        end

        it_behaves_like "returns http success"
      end

      context "ログインしていないとき" do
        before do
          patch edit_confirm_spot_path(spot.id), params: { spot_register_form: invalid_params }
          patch back_edit_spot_path(spot.id)
        end

        it_behaves_like "redirects to login page"
      end
    end

    describe "PATCH /update" do
      subject { patch spot_path(spot.id) }

      before { sign_in user }

      context "セッションに保存されたデータが妥当な場合" do
        before { patch edit_confirm_spot_path(spot.id), params: { spot_register_form: updated_params } }

        it "スポットを更新できる" do
          expect { subject }.to change { Spot.count }.by(0)
          expect(spot.reload.name).to eq(updated_spot_params["name"])
          expect(spot.reload.latitude).to eq(updated_spot_params["latitude"].to_i)
          expect(spot.reload.longitude).to eq(updated_spot_params["longitude"].to_i)
          expect(spot.reload.address).to eq(updated_spot_params["address"])
          expect(spot.reload.official_site).to eq(updated_spot_params["official_site"])
          expect(spot.reload.allowed_area_id).to eq(updated_spot_params["allowed_area_id"].to_i)
          expect(spot.reload.category_id).to eq(updated_spot_params["category_id"].to_i)
        end

        it "スポットの同伴ルールを変更できる" do
          subject
          expect(spot.reload.rule.count).to eq(rule_options.count)

          spot.reload.rule.each_with_index do |rule, i|
            expect(rule.rule_option_id).to eq(updated_rules_params.keys[i].to_i)
            expect(rule.answer).to eq(updated_rules_params.values[i]["answer"])
          end
        end

        it "スポットの変更履歴が保存される" do
          expect { subject }.to change { SpotHistory.count }.by(1)
          expect(SpotHistory.last.history).to eq("更新")
        end

        it "更新後、更新したスポットの詳細ページにリダイレクトする" do
          subject
          expect(response).to redirect_to(spot_path(spot.id))
        end
      end

      context "セッションに保存されたデータが不正な場合" do
        before { post new_confirm_spots_path, params: { spot_register_form: invalid_params } }

        it "スポットを変更できない" do
          spot.reload
          expect { subject }.to change { Spot.count }.by(0)
          expect(spot.saved_change_to_name?).to eq(false)
          expect(spot.saved_change_to_latitude?).to eq(false)
          expect(spot.saved_change_to_longitude?).to eq(false)
          expect(spot.saved_change_to_address?).to eq(false)
          expect(spot.saved_change_to_official_site?).to eq(false)
          expect(spot.saved_change_to_allowed_area_id?).to eq(false)
          expect(spot.saved_change_to_category_id?).to eq(false)
        end

        it "スポットの同伴ルールは変更されない" do
          spot.reload
          subject

          spot.rules.each_with_index do |rule, i|
            expect(rule.saved_change_to_rule_option_id?).to eq(false)
            expect(rule.saved_change_to_answer?).to eq(false)
          end
        end

        it "スポットの登録履歴は保存されない" do
          expect { subject }.to change { SpotHistory.count }.by(0)
        end

        it_behaves_like "returns http success"
      end

      context "update処理がすべて終わったとき" do
        before do
          post new_confirm_spots_path, params: { spot_register_form: invalid_params }
          subject
        end

        it "セッションにパラメータのデータが保存されてない" do
          expect(session["params"].to_h).to eq({})
        end
      end
    end
  end
end


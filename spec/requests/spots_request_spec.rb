require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Spots", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot, :with_rules) }
  let!(:categories) { create_list(:category, 3) }
  let!(:allowed_areas) { create_list(:allowed_area, 3) }
  let!(:option_titles) { create_list(:option_title, 3) }
  let!(:prefecture) { create(:prefecture, :real_prefecture) }
  let!(:rule_option_ids) { spot.rules.pluck(:rule_option_id) }

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

        it_behaves_like "HTTPリクエストの成功"
      end

      context "ログインしていないとき" do
        before { get new_spot_path }

        it_behaves_like "ログイン画面へのリダイレクト"
      end
    end

    describe "GET /show" do
      before do
        sign_in user
        get spot_path(spot)
      end

      it_behaves_like "HTTPリクエストの成功"
    end

    describe "GET /edit" do
      context "ログインしているとき" do
        before do
          sign_in user
          get edit_spot_path(spot)
        end

        it_behaves_like "HTTPリクエストの成功"
      end

      context "ログインしていないとき" do
        before { get edit_spot_path(spot) }

        it_behaves_like "ログイン画面へのリダイレクト"
      end
    end
  end

  describe "POST" do
    let(:params) { { spot_attributes: spot_params, rules_attributes: rules_params } }
    let(:spot_params) do
      attributes_for(
        :spot, :real_spot, allowed_area_id: allowed_areas[0].id, category_id: categories[0].id
      ).stringify_keys.transform_values(&:to_s)
    end
    let(:rules_params) do
      {
        "#{rule_option_ids[0]}" => { "answer" => "0" },
        "#{rule_option_ids[1]}" => { "answer" => "1" },
        "#{rule_option_ids[2]}" => { "answer" => "0" },
        "#{rule_option_ids[3]}" => { "answer" => "1" },
      }
    end

    describe "POST /new_confirm" do
      context "ログインしているとき" do
        before { sign_in user }

        context "送信されたパラメータが妥当なとき" do
          before { post new_confirm_spots_path, params: { spot_register_form: params } }

          it "送信されたパラメータがセッションに保存されている" do
            expect(session[:params]["spot_attributes"]).to eq(spot_params)
            expect(session[:params]["rules_attributes"]).to eq(rules_params)
          end

          it_behaves_like "HTTPリクエストの成功"
        end

        context "送信されたスポットのパラメータが不正なとき" do
          before { post new_confirm_spots_path, params: { spot_register_form: { spot_attributes: attributes_for(:spot, :invalid_spot) } } }

          it_behaves_like "HTTPリクエストの成功"
        end

        context "送信された同伴ルールのパラメータが不正なとき" do
          before { post new_confirm_spots_path, params: { spot_register_form: { spot_attributes: spot_params, rules_attributes: { nil => {} } } } }

          it_behaves_like "HTTPリクエストの成功"
        end

        context "ActionController::ParameterMissingのエラーが発生した場合" do
          before do
            allow_any_instance_of(SpotsController).
              to receive(:form_params).
              and_raise(ActionController::ParameterMissing, :spot_register_form)

            get new_confirm_spots_path
          end

          it "back_newへリダイレクトする" do
            expect(response).to redirect_to(back_new_spots_path)
          end
        end
      end

      context "ログインしていないとき" do
        before { post new_confirm_spots_path, params: { spot_register_form: params } }

        it_behaves_like "ログイン画面へのリダイレクト"
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

        it_behaves_like "HTTPリクエストの成功"
      end

      context "ログインしていないとき" do
        before do
          post new_confirm_spots_path, params: { spot_register_form: params }
          post back_new_spots_path
        end

        it_behaves_like "ログイン画面へのリダイレクト"
      end
    end

    describe "POST /create" do
      subject { post spots_path }

      before { sign_in user }

      context "セッションに保存されたデータが妥当な場合" do
        let(:new_spot) { Spot.last }
        let(:new_rules) { new_spot.rules }
        let(:new_spot_history) { SpotHistory.last }

        before { post new_confirm_spots_path, params: { spot_register_form: params } }

        it "Spotレコードを保存できる" do
          expect { subject }.to change { Spot.count }.by(1)
          expect(new_spot.name).to eq(spot_params["name"])
          expect(new_spot.latitude).to eq(spot_params["latitude"].to_f)
          expect(new_spot.longitude).to eq(spot_params["longitude"].to_f)
          expect(new_spot.address).to eq(spot_params["address"])
          expect(new_spot.official_site).to eq(spot_params["official_site"])
          expect(new_spot.allowed_area_id).to eq(spot_params["allowed_area_id"].to_i)
          expect(new_spot.category_id).to eq(spot_params["category_id"].to_i)
          expect(new_spot.prefecture_id).to eq(prefecture.id)
        end

        it "Ruleレコードが、RuleOptionレコードの数だけ保存される" do
          subject
          expect(new_rules.count).to eq(rule_option_ids.length)

          rules_params.each.with_index do |(rule_opt_param, answer_param), i|
            expect(new_rules[i].rule_option_id).to eq(rule_opt_param.to_i)
            expect(new_rules[i].answer).to eq(answer_param["answer"])
          end
        end

        it "SpotHistoryレコードが保存される" do
          expect { subject }.to change { SpotHistory.count }.by(1)
          expect(new_spot_history.history).to eq("新規登録")
          expect(new_spot_history.user_id).to eq(user.id)
          expect(new_spot_history.spot_id).to eq(new_spot.id)
        end

        it "登録後、登録したスポットの詳細ページにリダイレクトする" do
          subject
          expect(response).to redirect_to(spot_path(new_spot))
        end
      end

      context "セッションに保存されたスポットのデータが不正な場合" do
        before { post new_confirm_spots_path, params: { spot_register_form: { spot_params: attributes_for(:spot, :invalid_spot) } } }

        it "Spotレコードを保存できない" do
          expect { subject }.to change { Spot.count }.by(0)
        end

        it "Ruleレコードを保存できない" do
          expect { subject }.to change { Rule.count }.by(0)
        end

        it "SpotHistoryレコードは保存されない" do
          expect { subject }.to change { SpotHistory.count }.by(0)
        end

        it_behaves_like "HTTPリクエストの成功"
      end

      context "セッションに保存された同伴ルールのデータが不正な場合" do
        let(:invalid_rule_params) { { rule_option_ids[0] => { "answer" => nil } } }

        before { post new_confirm_spots_path, params: { spot_register_form: { spot_attributes: spot_params, rules_attributes: invalid_rule_params } } }

        it "Spotレコードを保存できない" do
          expect { subject }.to change { Spot.count }.by(0)
        end

        it "Ruleレコードを保存できない" do
          expect { subject }.to change { Rule.count }.by(0)
        end

        it "SpotHistoryレコードは保存されない" do
          expect { subject }.to change { SpotHistory.count }.by(0)
        end

        it_behaves_like "HTTPリクエストの成功"
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
      attributes_for(
        :spot, address: "大阪府", allowed_area_id: allowed_areas[1].id, category_id: categories[1].id, prefecture_id: updated_prefecture_id
      ).stringify_keys.transform_values(&:to_s)
    end
    let(:updated_rules_params) do
      {
        "#{rule_option_ids[0]}" => { "answer" => "0" },
        "#{rule_option_ids[1]}" => { "answer" => "0" },
        "#{rule_option_ids[2]}" => { "answer" => "1" },
        "#{rule_option_ids[3]}" => { "answer" => "1" },
      }
    end
    let!(:updated_prefecture_id) { create(:prefecture, name: "大阪府", name_roma: "osaka").id }

    describe "PATCH /edit_confirm" do
      context "ログインしているとき" do
        before { sign_in user }

        context "送信されたパラメータが妥当なとき" do
          before { patch edit_confirm_spot_path(spot), params: { spot_register_form: updated_params } }

          it "送信されたパラメータがセッションに保存されている" do
            expect(session[:params]["spot_attributes"]).to eq(updated_spot_params)
            expect(session[:params]["rules_attributes"]).to eq(updated_rules_params)
          end

          it_behaves_like "HTTPリクエストの成功"
        end

        context "送信されたスポットのパラメータが不正なとき" do
          before { patch edit_confirm_spot_path(spot), params: { spot_register_form: { spot_attributes: attributes_for(:spot, :invalid_spot) } } }

          it_behaves_like "HTTPリクエストの成功"
        end

        context "送信された同伴ルールのパラメータが不正なとき" do
          let(:invalid_rule_params) { { rule_option_ids[0] => { "answer" => nil } } }

          before { patch edit_confirm_spot_path(spot), params: { spot_register_form: { spot_attributes: updated_spot_params, rules_attributes: invalid_rule_params } } }

          it_behaves_like "HTTPリクエストの成功"
        end

        context "ActionController::ParameterMissingのエラーが発生した場合" do
          before do
            allow_any_instance_of(SpotsController).
              to receive(:form_params).
              and_raise(ActionController::ParameterMissing, :spot_register_form)

            get edit_confirm_spot_path(spot)
          end

          it "back_editへリダイレクトする" do
            expect(response).to redirect_to(back_edit_spot_path(spot))
          end
        end
      end

      context "ログインしていないとき" do
        before { patch edit_confirm_spot_path(spot), params: { spot_register_form: updated_params } }

        it_behaves_like "ログイン画面へのリダイレクト"
      end
    end

    describe "PATCH /back_edit" do
      context "ログインしているとき" do
        before do
          sign_in user
          patch edit_confirm_spot_path(spot), params: { spot_register_form: updated_params }
          patch back_edit_spot_path(spot)
        end

        it "セッションに、入力画面で送信したデータが保存されている" do
          expect(session[:params]["spot_attributes"]).to eq(updated_spot_params)
          expect(session[:params]["rules_attributes"]).to eq(updated_rules_params)
        end

        it_behaves_like "HTTPリクエストの成功"
      end

      context "ログインしていないとき" do
        before do
          patch edit_confirm_spot_path(spot), params: { spot_register_form: updated_params }
          patch back_edit_spot_path(spot)
        end

        it_behaves_like "ログイン画面へのリダイレクト"
      end
    end

    describe "PATCH /update" do
      let(:new_spot_history) { SpotHistory.last }

      subject { patch spot_path(spot) }

      before { sign_in user }

      context "セッションに保存されたデータが妥当な場合" do
        before { patch edit_confirm_spot_path(spot), params: { spot_register_form: updated_params } }

        it "Spotレコードを更新できる" do
          expect { subject }.to change { Spot.count }.by(0)
          spot.reload
          expect(spot.name).to eq(updated_spot_params["name"])
          expect(spot.latitude).to eq(updated_spot_params["latitude"].to_f)
          expect(spot.longitude).to eq(updated_spot_params["longitude"].to_f)
          expect(spot.address).to eq(updated_spot_params["address"])
          expect(spot.official_site).to eq(updated_spot_params["official_site"])
          expect(spot.allowed_area_id).to eq(updated_spot_params["allowed_area_id"].to_i)
          expect(spot.category_id).to eq(updated_spot_params["category_id"].to_i)
          expect(spot.prefecture_id).to eq(updated_prefecture_id)
        end

        it "全てのRuleレコードを更新できる" do
          subject
          spot.reload
          expect(spot.rules.count).to eq(rule_option_ids.length)

          updated_rules_params.each.with_index do |(rule_opt_param, answer_param), i|
            expect(spot.rules[i].rule_option_id).to eq(rule_opt_param.to_i)
            expect(spot.rules[i].answer).to eq(answer_param["answer"])
          end
        end

        it "SpotHistoryレコードが保存される" do
          expect { subject }.to change { SpotHistory.count }.by(1)
          expect(new_spot_history.history).to eq("更新")
          expect(new_spot_history.user_id).to eq(user.id)
          expect(new_spot_history.spot_id).to eq(spot.id)
        end

        it "更新後、更新したスポットの詳細ページにリダイレクトする" do
          subject
          expect(response).to redirect_to(spot_path(spot))
        end
      end

      context "セッションに保存された同伴ルールのデータが不正な場合" do
        before { post new_confirm_spots_path, params: { spot_register_form: { spot_attributes: attributes_for(:spot, :invalid_spot) } } }

        it "Spotレコードを更新できない" do
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

        it "Ruleレコードを更新できない" do
          subject
          spot.reload

          spot.rules.each_with_index do |rule, i|
            expect(rule.saved_change_to_rule_option_id?).to eq(false)
            expect(rule.saved_change_to_answer?).to eq(false)
          end
        end

        it "SpotHistoryレコードは保存されない" do
          expect { subject }.to change { SpotHistory.count }.by(0)
        end

        it_behaves_like "HTTPリクエストの成功"
      end

      context "セッションに保存されたスポットのデータが不正な場合" do
        let(:invalid_rule_params) { { rule_option_ids[0] => { "answer" => nil } } }

        before { post new_confirm_spots_path, params: { spot_register_form: { spot_attributes: updated_spot_params, rules_attributes: invalid_rule_params } } }

        it "Spotレコードを更新できない" do
          expect { subject }.to change { Spot.count }.by(0)
          spot.reload
          expect(spot.saved_change_to_name?).to eq(false)
          expect(spot.saved_change_to_latitude?).to eq(false)
          expect(spot.saved_change_to_longitude?).to eq(false)
          expect(spot.saved_change_to_address?).to eq(false)
          expect(spot.saved_change_to_official_site?).to eq(false)
          expect(spot.saved_change_to_allowed_area_id?).to eq(false)
          expect(spot.saved_change_to_category_id?).to eq(false)
        end

        it "Ruleレコードを更新できない" do
          subject
          spot.reload

          spot.rules.each_with_index do |rule, i|
            expect(rule.saved_change_to_rule_option_id?).to eq(false)
            expect(rule.saved_change_to_answer?).to eq(false)
          end
        end

        it "SpotHistoryレコードは保存されない" do
          expect { subject }.to change { SpotHistory.count }.by(0)
        end

        it_behaves_like "HTTPリクエストの成功"
      end

      context "update処理がすべて終わったとき" do
        before do
          post new_confirm_spots_path, params: { spot_register_form: updated_params }
          subject
        end

        it "セッションにパラメータのデータが保存されてない" do
          expect(session["params"].to_h).to eq({})
        end
      end
    end
  end
end

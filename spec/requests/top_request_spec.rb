require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Top", type: :request do
  describe "GET /index" do
    before { get root_path }

    it_behaves_like "returns http success"
  end

  describe "GET /map_search" do
    before { get map_search_path }

    it_behaves_like "returns http success"
  end

  describe "GET /word_search" do
    let!(:categories) { create_list(:category, 3) }
    let!(:allowed_areas) { create_list(:allowed_area, 3) }
    let!(:tokyo) { create(:prefecture) }
    let!(:osaka) { create(:prefecture) }
    let!(:spot_1) do
      create(:spot, name: "東京ドッグパーク", address: "東京都新宿区", category: categories[0], allowed_area: allowed_areas[0], prefecture: tokyo)
    end
    let!(:spot_2) do
      create(:spot, name: "犬カフェ", address: "東京都渋谷区", category: categories[0], allowed_area: allowed_areas[1], prefecture: tokyo)
    end
    let!(:spot_3) do
      create(:spot, name: "おおさかキャンプ場", address: "大阪府大阪市", category: categories[2], allowed_area: allowed_areas[1], prefecture: osaka)
    end

    before { get word_search_path, params: { q: search_params } }

    describe "詳細検索" do
      let(:search_params) do
        { "and" => {
          "name_or_address_cont" => name_or_address_word,
          "category_id_matches_any" => category_ids,
          "allowed_area_id_matches_any" => allowed_area_ids,
          "prefecture_id_eq" => prefecture_id,
        } }
      end
      let(:name_or_address_word) { "" }
      let(:category_ids) { [""] }
      let(:allowed_area_ids) { [""] }
      let(:prefecture_id) { "" }

      context "施設名をキーワード検索したとき" do
        let!(:name_or_address_word) { "ドッグパーク" }

        it "施設名にキーワードを含むスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_1])
        end
      end

      context "施設の住所をキーワード検索したとき" do
        let!(:name_or_address_word) { "東京都" }

        it "住所にキーワードを含むスポットを取得できる" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_1.id, spot_2.id])
        end
      end

      context "複数のキーワードで検索したとき" do
        let!(:name_or_address_word) { "キャンプ 大阪" }

        it "and検索をして、すべてのキーワードを名前か住所に含むスポットを取得できる" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_3.id])
        end
      end

      context "１つのカテゴリーを選択して検索したとき" do
        let!(:category_ids) { [categories[0].id] }

        it "選択したカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_1.id, spot_2.id])
        end
      end

      context "複数のカテゴリーを選択して検索したとき" do
        let!(:category_ids) { [categories[0].id, categories[2].id] }

        it "or検索をして、選択したそれぞれのカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_1.id, spot_2.id, spot_3.id])
        end
      end

      context "１つの同伴可能エリアを選択して検索したとき" do
        let!(:allowed_area_ids) { [allowed_areas[1].id] }

        it "選択したカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_2.id, spot_3.id])
        end
      end

      context "複数の同伴可能エリアを選択して検索したとき" do
        let!(:allowed_area_ids) { [allowed_areas[0].id, allowed_areas[1].id] }

        it "or検索をして、選択したカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_1.id, spot_2.id, spot_3.id])
        end
      end

      context "都道府県を指定して検索したとき" do
        let!(:prefecture_id) { tokyo.id }

        it "選択した都道府県に属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_1.id, spot_2.id])
        end
      end

      context "すべての検索項目を合わせて検索したとき" do
        let!(:name_or_address_word) { "カフェ" }
        let!(:category_ids) { [categories[0].id] }
        let!(:allowed_area_ids) { [allowed_areas[1].id] }
        let!(:prefecture_id) { tokyo.id }

        it "and検索をして、すべての条件に合うスポットを取得できる" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_2.id])
        end
      end

      context "検索条件を指定せずに検索したとき" do
        it "すべてのスポットを取得する" do
          expect(controller.instance_variable_get("@results").ids).to match_array([spot_1.id, spot_2.id, spot_3.id])
        end
      end

      context "検索条件に合うスポットが存在しないとき" do
        let!(:name_or_address_word) { "カフェ" }
        let!(:prefecture_id) { osaka.id }

        it "検索結果はでない" do
          expect(controller.instance_variable_get("@results").ids).to match_array([])
        end
      end

      it_behaves_like "returns http success"
    end

    describe "エリア検索" do
      let!(:kanto) { tokyo.region }
      let!(:search_params) { { and: { prefecture_id_matches_any: kanto.prefectures.ids } } }

      it "選択した地方のエリアに住所が属するスポットを取得する" do
        expect(controller.instance_variable_get("@results").ids).to match_array([spot_1.id, spot_2.id])
      end

      it_behaves_like "returns http success"
    end
  end
end

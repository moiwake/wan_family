require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Top", type: :request do
  let!(:categories) { create_list(:category, 3) }
  let!(:allowed_areas) { create_list(:allowed_area, 3) }

  describe "GET /index" do
    before { get root_path }

    it_behaves_like "returns http success"
  end

  describe "GET /map_search" do
    before { get map_search_path }

    it_behaves_like "returns http success"
  end

  describe "GET /word_search" do
    let!(:spot_1) do
      create(:spot, name: "東京ドッグパーク", address: "東京都新宿区", category_id: categories[0].id, allowed_area_id: allowed_areas[0].id)
    end
    let!(:spot_2) do
      create(:spot, name: "犬カフェ", address: "東京都渋谷区", category_id: categories[0].id, allowed_area_id: allowed_areas[1].id)
    end
    let!(:spot_3) do
      create(:spot, name: "おおさかキャンプ場", address: "大阪府大阪市", category_id: categories[2].id, allowed_area_id: allowed_areas[1].id)
    end

    before { get word_search_path, params: { q: search_params } }

    describe "詳細検索" do
      let(:search_params) do
        { "and" => {
          "name_or_address_cont"=> name_or_address_word,
          "category_id_matches_any"=> category_ids,
          "allowed_area_id_matches_any"=> allowed_area_ids,
          "address_cont"=> address,
        } }
      end
      let(:name_or_address_word) { "" }
      let(:category_ids) { [""] }
      let(:allowed_area_ids) { [""] }
      let(:address) { "" }

      context "施設名をキーワード検索したとき" do
        let!(:name_or_address_word) { "ドッグパーク" }

        it "施設名にキーワードを含むスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_1])
        end
      end

      context "施設の住所をキーワード検索したとき" do
        let!(:name_or_address_word) { "東京都" }

        it "住所にキーワードを含むスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_1, spot_2])
        end
      end

      context "複数のキーワードで検索したとき" do
        let!(:name_or_address_word) { "キャンプ 大阪" }

        it "and検索をして、すべてのキーワードを名前か住所に含むスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_3])
        end
      end

      context "１つのカテゴリーを選択して検索したとき" do
        let!(:category_ids) { [categories[0].id] }

        it "選択したカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_1, spot_2])
        end
      end

      context "複数のカテゴリーを選択して検索したとき" do
        let!(:category_ids) { [categories[0].id, categories[2].id] }

        it "or検索をして、選択したそれぞれのカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_1, spot_2, spot_3])
        end
      end

      context "１つの同伴可能エリアを選択して検索したとき" do
        let!(:allowed_area_ids) { [allowed_areas[1].id] }

        it "選択したカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_2, spot_3])
        end
      end

      context "複数の同伴可能エリアを選択して検索したとき" do
        let!(:allowed_area_ids) { [allowed_areas[0].id, allowed_areas[1].id] }

        it "or検索をして、選択したカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_1, spot_2, spot_3])
        end
      end

      context "都道府県を指定して検索したとき" do
        let!(:address) { "東京都" }

        it "選択したカテゴリーに属するスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_1, spot_2])
        end
      end

      context "すべての検索項目を合わせて検索したとき" do
        let!(:name_or_address_word) { "カフェ" }
        let!(:category_ids) { [categories[0].id] }
        let!(:allowed_area_ids) { [allowed_areas[1].id] }
        let!(:address) { "東京都" }

        it "and検索をして、すべての条件に合うスポットを取得できる" do
          expect(controller.instance_variable_get("@results")).to eq([spot_2])
        end
      end

      context "検索条件を指定せずに検索したとき" do
        it "すべてのスポットを取得する" do
          expect(controller.instance_variable_get("@results")).to eq([spot_1, spot_2, spot_3])
        end
      end

      context "検索条件に合うスポットが存在しないとき" do
        let!(:name_or_address_word) { "カフェ" }
        let!(:address) { "大阪府" }

        it "検索結果はでない" do
          expect(controller.instance_variable_get("@results")).to eq([])
        end
      end

      it_behaves_like "returns http success"
    end

    describe "エリア検索" do
      let!(:search_params) { {or: { address_cont_any: Prefecture.find_prefecture_name("関東") }} }

      it "選択したエリアに住所が属するスポットを取得する" do
        expect(controller.instance_variable_get("@results")).to eq([spot_1, spot_2])
      end

      it_behaves_like "returns http success"
    end
  end
end


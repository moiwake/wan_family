require "rails_helper"
# require 'support/shared_examples/model_spec'

RSpec.describe Prefecture, type: :model do
  describe "scope #find_prefecture_name" do
    it "地方名が引数の値と一致するデータの県名を、配列で取得する" do
      expect(find_prefecture_name("東北")).to eq(["青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県"])
    end
  end
end

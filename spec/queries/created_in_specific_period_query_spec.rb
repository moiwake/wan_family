require 'rails_helper'

RSpec.describe CreatedInSpecificPeriodQuery, type: :model do
  let!(:scope) do
    create_list(:spot_favorite, 3)
    SpotFavorite.all
  end
  let!(:date) { "days" }
  let!(:number) { 6 }
  let(:class_instance) { CreatedInSpecificPeriodQuery.new(scope: scope, date: date, number: number) }


  describe "#call" do
    subject(:return_value) { CreatedInSpecificPeriodQuery.call(scope: scope, date: date, number: number) }

    let(:searched_scope) { instance_double("scope") }

    before do
      allow(CreatedInSpecificPeriodQuery).to receive(:new).and_return(class_instance)
      allow(class_instance).to receive(:for_specific_period).and_return(searched_scope)
      subject
    end

    it "引数を渡して、CreatedInSpecificPeriodQueryクラスをレシーバーにnewメソッドを呼び出す" do
      expect(CreatedInSpecificPeriodQuery).to have_received(:new).once.with(scope: scope, date: date, number: number)
    end

    it "CreatedInSpecificPeriodQueryのインスタンスをレシーバーに、for_specific_periodメソッドを呼び出す" do
      expect(class_instance).to have_received(:for_specific_period).once
    end

    it "for_specific_periodメソッドの返り値を返す" do
      expect(return_value).to eq(searched_scope)
    end
  end

  describe "#for_specific_period" do
    subject(:return_value) { class_instance.for_specific_period }

    let(:to) { Time.current + 1 }
    let(:from) { (to - class_instance.number.send(class_instance.date)).at_beginning_of_day }

    it "指定した時点から現在までに作成されたレコード群を返す" do
      expect(return_value.ids).to eq(scope.where(created_at: from...to).ids)
    end
  end
end

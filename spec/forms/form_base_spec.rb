require 'rails_helper'

RSpec.describe FormBase, type: :model do
  let!(:form_base_instance) { FormBase.new }

  describe "#invalid?" do
    before do
      allow(form_base_instance).to receive(:check_and_add_error)
    end

    it "check_and_add_errorメソッドを呼び出す" do
      form_base_instance.invalid?
      expect(form_base_instance).to have_received(:check_and_add_error).once
    end
  end

  describe "#save" do
    before do
      allow(form_base_instance).to receive(:persist)
    end

    it "persistメソッドを呼び出す" do
      form_base_instance.save
      expect(form_base_instance).to have_received(:persist).once
    end
  end
end

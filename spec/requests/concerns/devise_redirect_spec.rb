require 'rails_helper'

RSpec.describe "DeviseRedirect", :type => :request do
  let(:admin) { create(:admin) }
  let(:other) { double("other") }

  before do
    dummy_controller = Class.new(DeviseController) do
      include DeviseRedirect

      attr_reader :resource, :scope_name

      def initialize(resource: nil, scope_name: nil)
        @resource = resource
        @scope_name = scope_name
      end
    end

    stub_const("DummyController", dummy_controller)

    def return_path(path)
      Rails.application.routes.url_helpers.send(path)
    end

    allow(controller).to receive(:rails_admin_path) do
      return_path("rails_admin_path")
    end

    allow(controller).to receive(:root_path) do
      return_path("root_path")
    end
  end

  describe "#after_sign_in_path_for" do
    subject(:return_value) { controller.after_sign_in_path_for(controller.resource) }

    context "引数のオブジェクトがAdminクラスのインスタンスのとき" do
      let(:controller) { DummyController.new(resource: admin) }

      it "rails_admin_pathを返す" do
        expect(return_value).to eq(rails_admin_path)
      end
    end

    context "引数のオブジェクトがAdminクラスのインスタンスではないとき" do
      let(:controller) { DummyController.new(resource: other) }

      before do
        allow(controller).to receive(:stored_location_for).and_return("stored_location_path")
        subject
      end

      it "引数を渡して、stored_location_forメソッドを呼び出す" do
        expect(controller).to have_received(:stored_location_for).once.with(other)
      end
    end
  end

  describe "#after_sign_out_path_for" do
    subject(:return_value) { controller.after_sign_out_path_for(controller.scope_name) }

    context "引数が':admin'のとき" do
      let(:controller) { DummyController.new(scope_name: :admin) }

      it "rails_admin_pathを返す" do
        expect(return_value).to eq(rails_admin_path)
      end
    end

    context "引数が':admin'ではないとき" do
      let(:controller) { DummyController.new(scope_name: :other) }

      it "root_pathを返す" do
        expect(return_value).to eq(root_path)
      end
    end
  end
end

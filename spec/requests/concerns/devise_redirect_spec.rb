require 'rails_helper'

class DummyController < DeviseController
  include DeviseRedirect

  attr_accessor :resource
  def initialize(resource: nil)
    @resource = resource
  end
end

RSpec.describe "DeviseRedirect", :type => :request do
  let(:admin) { create(:admin) }
  let(:admin_controller) { DummyController.new(resource: admin) }
  let(:user) { create(:user) }
  let(:user_controller) { DummyController.new(resource: user) }

  before do
    def return_path(path)
      Rails.application.routes.url_helpers.send(path)
    end

    allow(admin_controller).to receive(:rails_admin_path) do
      return_path("rails_admin_path")
    end

    allow(user_controller).to receive(:root_path) do
      return_path("root_path")
    end
  end

  describe "#after_sign_in_path_for" do
    context "引数のオブジェクトがAdminクラスのインスタンスのとき" do
      it "rails_admin_pathを返す" do
        expect(admin_controller.after_sign_in_path_for(admin_controller.resource)).to eq(rails_admin_path)
      end
    end

    context "引数のオブジェクトがAdminクラスのインスタンスではないとき" do
      it "root_pathを返す" do
        expect(user_controller.after_sign_in_path_for(user_controller.resource)).to eq(root_path)
      end
    end
  end

  describe "#after_sign_out_path_for" do
    context "引数が':admin'のとき" do
      it "rails_admin_pathを返す" do
        expect(admin_controller.after_sign_in_path_for(admin_controller.resource)).to eq(rails_admin_path)
      end
    end

    context "引数が':admin'ではないとき" do
      it "root_pathを返す" do
        expect(user_controller.after_sign_in_path_for(user_controller.resource)).to eq(root_path)
      end
    end
  end
end

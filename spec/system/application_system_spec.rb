require "rails_helper"

RSpec.describe "ApplicationSystemSpec", type: :system do
  let(:base_controller) { ApplicationController }
  let(:dummy_controller) do
    Class.new(base_controller) do
      def index
        render inline: "<form action='/dummy_create' method='post'>
                          <input type='submit' value='POSTリクエスト送信'>
                        </form>
                        <a data-remote='true' data-method='post' href='/dummy_create'>Ajaxリンク</a>",
               layout: "application"
      end

      def create
      end
    end
  end

  before do
    stub_const("DummyController", dummy_controller)
    Rails.application.routes.disable_clear_and_finalize = true
    Rails.application.routes.draw do
      get "/dummy_index", to: "dummy#index"
      post "/dummy_create", to: "dummy#create"

      devise_scope :user do
        get '/dummy_devise', to: 'devise/dummy#index'
      end
    end
  end

  after { Rails.application.reload_routes! }

  describe "ヘッダー" do
    before { visit "/dummy_index" }

    describe "ロゴ" do
      it "トップページへのリンクになっている" do
        expect(page).to have_link("Wan Family", href: root_path)
      end
    end

    describe "メニューリンク" do
      let!(:user) { create(:user) }
      let!(:admin) { create(:admin) }

      describe "ログイン状況" do
        context "ログインしていないとき" do
          it "ユーザー新規登録ページへのリンクがある" do
            expect(page).to have_link(href: new_user_registration_path)
          end

          it "ログインページへのリンクがある" do
            expect(page).to have_link(href: new_user_session_path)
          end

          it "スポット登録ページへのリンクがある" do
            expect(page).to have_link(href: new_spot_path)
          end
        end

        context "一般ユーザーとしてログインしているとき" do
          before do
            sign_in user
            visit "/dummy_index"
          end

          it "ログアウトのリンクがある" do
            expect(page).to have_link(href: destroy_user_session_path)
          end

          it "マイページへのリンクがある" do
            expect(page).to have_link(href: users_mypage_favorite_spot_index_path)
          end

          it "スポット登録ページへのリンクがある" do
            expect(page).to have_link(href: new_spot_path)
          end
        end

        context "管理者としてログインしているとき" do
          before do
            sign_in admin
            visit "/dummy_index"
          end

          it "ログアウトのリンクがある" do
            expect(page).to have_link(href: destroy_admin_session_path)
          end

          it "サイト管理ページへのリンクがある" do
            expect(page).to have_link(href: rails_admin_path)
          end
        end
      end

      describe "ウィンドウサイズ", js: true do
        context "ウィンドウサイズの幅が1024px未満のとき" do
          include_context "resize_browser_size", 1023, 1000

          it "リンクが非表示になっている" do
            expect(page).not_to have_selector(".navbar-menu")
          end

          it "メニュー表示アイコンをクリックすると、リンクが表示される" do
            find(".navbar-burger").click
            expect(page).to have_selector(".navbar-menu")
          end

          it "メニュー非表示アイコンをクリックすると、リンクが非表示になる" do
            find(".navbar-burger").click
            find(".navbar-burger").click
            expect(page).not_to have_selector(".navbar-menu")
          end

          context "検索バーが表示されている状態でメニューリンクを表示したとき" do
            include_context "resize_browser_size", 599, 1000

            before do
              find(".search-form-open-btn").click
              find(".navbar-burger").click
            end

            it "検索バーが閉じる" do
              expect(page).not_to have_selector(".js-target-header-search")
            end
          end
        end
      end
    end

    describe "検索バー", js: true do
      let!(:spot) { create(:spot) }

      describe "キーワード検索" do
        before do
          visit "/dummy_index"
          fill_in "q_and_name_or_address_cont", with: spot.name
          find(".header-search-btn").click
        end

        it "スポットのキーワード検索ができる" do
          expect(current_path).to eq(word_search_path)
          expect(find(".search-result-wrap")).to have_content(spot.name)
        end

        it "検索後、入力した内容が検索バーに表示される" do
          expect(find("#q_and_name_or_address_cont").value).to eq(spot.name)
        end
      end

      describe "詳細検索" do
        let!(:categories) { create_list(:category, 3) }
        let!(:allowed_areas) { create_list(:allowed_area, 3) }
        let!(:prefectures) { create_list(:prefecture, 3) }
        let!(:regions) { Region.all }
        let!(:locator) { find(".header-search-form") }

        before do
          visit "/dummy_index"
          find(".search-filter-open-btn").click
          find("label[for='header_q_category_#{spot.category.id}']").click
          find("label[for='header_q_allowed_area_#{spot.allowed_area.id}']").click
          select spot.prefecture.name
          find(".search-filter-btn").click
          find(".search-filter-open-btn").click
        end

        it "スポットの詳細検索ができる" do
          expect(current_path).to eq(word_search_path)
          expect(find(".search-result-wrap")).to have_content(spot.name)
        end

        it "検索後、詳細検索で設定した条件が選択済みになっている" do
          expect(find("#header_q_category_#{spot.category.id}", visible: false).checked?).to eq(true)
          expect(find("#header_q_allowed_area_#{spot.allowed_area.id}", visible: false).checked?).to eq(true)
          expect(find("option[value='#{spot.prefecture.id}']", visible: false).selected?).to eq(true)
        end

        it "検索条件のクリアをクリックすると、詳細検索の条件がすべて未選択になる" do
          find(".js-search-condition-clear-btn").click
          expect(find("#header_q_category_#{spot.category.id}", visible: false).checked?).to eq(false)
          expect(find("#header_q_allowed_area_#{spot.allowed_area.id}", visible: false).checked?).to eq(false)
          expect(find("option[value='#{spot.prefecture.id}']", visible: false).selected?).to eq(false)
        end

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_regions"
        it_behaves_like "displays_all_prefectures"
      end

      describe "ウィンドウサイズ" do
        before { visit "/dummy_index" }

        context "ウィンドウサイズの幅が600px未満のとき" do
          include_context "resize_browser_size", 599, 1000

          it "検索バーが非表示になっている" do
            expect(page).not_to have_selector(".header-search-wrap")
          end

          it "検索バー表示アイコンをクリックすると、検索バーが表示される" do
            find(".search-form-open-btn").click
            expect(page).to have_selector(".header-search-wrap")
          end

          it "閉じるアイコンをクリックすると、検索バーが非表示になる" do
            find(".search-form-open-btn").click
            find(".search-form-close-btn").click
            expect(page).not_to have_selector(".header-search-wrap")
          end

          context "メニューリンクが表示されている状態で検索バーを表示したとき" do
            include_context "resize_browser_size", 599, 1000

            before do
              find(".navbar-burger").click
              find(".search-form-open-btn").click
            end

            it "メニューリンクが閉じる" do
              expect(page).not_to have_selector(".navbar-menu")
            end
          end
        end
      end
    end
  end

  describe "フレンドリーフォワーディング" do
    let!(:user) { create(:user) }

    subject do
      visit new_user_session_path
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: user.password
      click_button "ログイン"
    end

    context "GETリクエストかつ、Deviseのコントローラーからリクエストではない、かつAjaxリクエストではないとき" do
      before do
        visit "/dummy_index"
        subject
      end

      it "ログインする前のページにリダイレクトする" do
        expect(current_path).to eq("/dummy_index")
      end
    end

    context "GETリクエストではないとき" do
      before do
        visit "/dummy_index"
        click_button "POSTリクエスト送信"
        subject
      end

      it "ログインする前の特定のリクエストで呼び出されたページにリダイレクトする" do
        expect(current_path).to eq("/dummy_index")
      end
    end

    context "Ajaxリクエストのとき" do
      before do
        visit "/dummy_index"
        click_link "Ajaxリンク"
        subject
      end

      it "ログインする前の特定のリクエストで呼び出されたページにリダイレクトする" do
        expect(current_path).to eq("/dummy_index")
      end
    end

    context "Deviseのコントローラーからリクエストのとき" do
      let!(:base_controller) { DeviseController }

      before do
        stub_const("Devise::DummyController", dummy_controller)
        visit root_path
        visit "/dummy_devise"
        subject
      end

      it "ログインする前の特定のリクエストで呼び出されたページにリダイレクトする" do
        expect(current_path).to eq(root_path)
      end
    end
  end
end

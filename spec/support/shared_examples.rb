shared_examples "adds adds validation error messagess" do
  it "errorsコレクションにエラーメッセージが追加される" do
    invalid_object.valid?
    expect(invalid_object.errors[attribute]).to include(message)
  end
end

shared_examples "returns http success" do
  it "HTTPリクエストが成功する" do
    subject if subject.present?
    expect(response).to have_http_status(:success)
  end
end

shared_examples "returns 302 HTTP Status Code" do
  it "HTTPステータスコードが302リダイレクトとなる" do
    subject
    expect(response.status).to eq(302)
  end
end

shared_examples "redirects to login page" do
  it "ログイン画面にリダイレクトする" do
    expect(response).to redirect_to(new_user_session_path)
  end
end

shared_examples "displays_all_categories" do
  it "すべてのカテゴリーが表示される" do
    categories.each do |category|
      expect(response.body).to include(category.name)
    end
  end
end

shared_examples "displays_all_allowed_areas" do
  it "すべての同伴可能エリアが表示される" do
    allowed_areas.each do |allowed_area|
      expect(response.body).to include(allowed_area.area)
    end
  end
end

shared_examples "displays_all_option_titles" do
  it "すべての同伴ルールの選択肢のタイトルが表示される" do
    option_titles.each do |option_title|
      expect(response.body).to include(option_title.name)
    end
  end
end

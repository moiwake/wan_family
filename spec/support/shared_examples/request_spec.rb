shared_examples "returns http success" do
  it "HTTPリクエストが成功する" do
    subject if subject.present?
    expect(response).to have_http_status(:success)
  end
end

shared_examples "redirects to login page" do
  it "ログイン画面にリダイレクトする" do
    expect(response).to redirect_to(new_user_session_path)
  end
end

shared_examples "returns 302 http status code" do
  it "HTTPステータスコードが302リダイレクトとなる" do
    subject
    expect(response.status).to eq(302)
  end
end

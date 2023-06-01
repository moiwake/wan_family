shared_examples "HTTPリクエストの成功" do
  it "HTTPリクエストが成功する" do
    subject if subject.present?
    expect(response).to have_http_status(:success)
  end
end

shared_examples "ログイン画面へのリダイレクト" do
  it "ログイン画面にリダイレクトする" do
    expect(response).to redirect_to(new_user_session_path)
  end
end

shared_examples "HTTPステータスコード302" do
  it "HTTPステータスコードが302リダイレクトとなる" do
    subject
    expect(response.status).to eq(302)
  end
end

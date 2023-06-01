shared_examples "有効なオブジェクトか" do
  it "そのオブジェクトのデータは有効" do
    expect(valid_object).to be_valid
  end
end

shared_examples "バリデーションエラーメッセージ" do
  it "errorsコレクションにエラーメッセージが追加される" do
    invalid_object.valid?
    expect(invalid_object.errors[attribute]).to include(message)
  end
end

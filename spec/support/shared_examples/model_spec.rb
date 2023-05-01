shared_examples "the object is valid" do
  it "そのオブジェクトのデータは有効" do
    expect(valid_object).to be_valid
  end
end

shared_examples "adds validation error messages" do
  it "errorsコレクションにエラーメッセージが追加される" do
    invalid_object.valid?
    expect(invalid_object.errors[attribute]).to include(message)
  end
end

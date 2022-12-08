shared_examples "adds adds validation error messagess" do
  it "errorsコレクションにエラーメッセージが追加される" do
    invalid_object.valid?
    expect(invalid_object.errors[attribute]).to include(message)
  end
end

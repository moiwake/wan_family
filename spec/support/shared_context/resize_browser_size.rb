shared_context "resize_browser_size" do |width, height|
  before { resize_browser_size(width: width, height: height) }

  after { resize_browser_default_size }
end

Capybara.default_driver    = :rack_test
Capybara.javascript_driver = :selenium_chrome
Capybara.server_host = "web"
Capybara.server_port = 3001
Capybara.default_max_wait_time = 5
Capybara.ignore_hidden_elements = true
Capybara.register_driver :selenium_chrome do |app|
  opts = {
    capabilities: :chrome,
    browser: :remote,
    url: "http://chrome:4444/wd/hub",
  }
  Capybara::Selenium::Driver.new(app, opts)
end

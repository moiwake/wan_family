require 'webdrivers/chromedriver'

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :remote_chrome
Capybara.server_host = "web"
Capybara.server_port = 3001
Capybara.default_max_wait_time = 5
Capybara.ignore_hidden_elements = true

Capybara.register_driver :remote_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome
  capabilities['goog:chromeOptions'] = {
    args: [
      "--no-sandbox",
      "--disable-dev-shm-usage",
      "--disable-popup-blocking",
      "--disable-gpu",
      "--headless",
      "--window-size=1920,1080",
    ]
  }

  url = "http://chrome:4444/wd/hub"

  driver_opts = {
    browser: :remote,
    capabilities: capabilities,
    url: url,
  }

  Capybara::Selenium::Driver.new app, **driver_opts
end

def resize_browser_size(width = 600, height = 600)
  Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
end

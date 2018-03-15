
And(/^I can see the h1 header with DeviceAgent$/) do
  page = page(WebViewApp::TabBar).active_page

  timeout = 30
  message = "Waited for #{timeout} seconds for H1 Header"
  options = {timeout: timeout,
             timeout_message: message}

  wait_for(options) do
    !device_agent.query({id: "H1 Header!", all: true}).empty?
  end
end

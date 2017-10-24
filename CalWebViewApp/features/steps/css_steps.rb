
Then(/^I can query for hrefs with css$/) do
  page = page(WebViewApp::TabBar).active_page
  res = query(page.query_str("css:'a'"))
  # Distinguish between a and a w/ href
  hrefs = res.select { |elm| elm['href'] }
  expect(hrefs.count).to be == 2
end

Then(/^I can query for the body with css$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    qstr = page.query_str("css:'body'")
    visible = lambda {
      query(qstr).count == 1
    }

    counter = 0
    loop do
      break if visible.call || counter == 12
      scroll(page.query_str, :down)
      step_pause
      counter = counter + 1
    end
    res = query(qstr)
    expect(res.count).to be == 1
  end
end

# 3.5in iPhones will only show 2; all others will show 3
When(/^I query with css I should see at least (\d+) unordered lists$/) do |expected|
  page = page(WebViewApp::TabBar).active_page
  res = query(page.query_str("css:'ul'"))
  expect(res.count).to be >= expected.to_i
end

Then(/^I can use css to find the "([^"]*)" list item$/) do |id|
  page = page(WebViewApp::TabBar).active_page
  res = query(page.query_str("css:'li##{id}'"))
  expect(res.count).to be == 1
end

When(/^I touch the internal link with css$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('Internal Link')
    qstr = page.query_str("css:'a#internal-link'")
    wait_for(options) do
      !query(qstr).empty?
    end
    touch(qstr)
  end

  wait_for_none_animating
  sleep(1.0)
end

Then(/^a query for the FAQ with css should succeed$/) do
  page = page(WebViewApp::TabBar).active_page
  options = wait_options('FAQ List')
  wait_for(options) do
    !query(page.query_str("css:'ul#faq-list'")).empty?
  end
end

And(/^I touch the toggle\-the\-secret button with css$/) do
  page = page(WebViewApp::TabBar).active_page
  options = wait_options('Toggle the Secret button')
  qstr = page.query_str("css:'button#show_secret'")
  wait_for(options) do
    !query(qstr).empty?
  end
  touch(qstr)
end

Then(/^I should see the secret message with css$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('Secret Message')
    qstr = page.query_str("css:'span#secret_message'")
    res = nil
    wait_for(options) do
      res = query(qstr)
      !res.empty?
    end
    expect(res.first['textContent']).to be == 'Let Op!'
  end
end

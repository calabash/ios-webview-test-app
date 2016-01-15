And(/^I can see the iframe$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    qstr = page.query_str("css:'iframe'")
    visible = lambda {
      query(qstr).count == 1
    }

    counter = 0
    loop do
      break if visible.call || counter == 10
      scroll(page.query_str, :down)
      step_pause
      counter = counter + 1
    end
    res = query(qstr)
    expect(res.count).to be == 1
  end
end

Then(/^I can query within the iframe with css for (\d+) "([^"]*)"$/) do |num, nodeName|
  page = page(WebViewApp::TabBar).active_page
  res = query(page.query_str("css:'iframe' css:'#{nodeName}'"))
  # Distinguish between a and a w/ href
  inputs = res.select { |elm| elm['nodeName'].downcase == nodeName.downcase }
  expect(inputs.count).to be == num.to_i
end

Then(/^I can query for "([^"]*)" with id "([^"]*)"$/) do |nodeName, el_id|
  page = page(WebViewApp::TabBar).active_page
  res = query(page.query_str("css:'iframe' css:'#{nodeName}##{el_id}'"))
  expect(res.count).to be > 0
end

Then(/^I can enter "([^"]*)" in the "([^"]*)" with id "([^"]*)"$/) do |text, nodeName, el_id|
  page = page(WebViewApp::TabBar).active_page
  res = enter_text(page.query_str("css:'iframe' css:'#{nodeName}##{el_id}'"), text)
  expect(res.count).to be > 0
  elementText = query(page.query_str("css:'iframe' css:'nodeName##{el_id}'")).first['textContent']
  expect(elementText).to be == text
end

When(/^I click the "([^"]*)" with id "([^"]*)"$/) do |nodeName, el_id|
  page = page(WebViewApp::TabBar).active_page
  res = touch(page.query_str("css:'iframe' css:'#{nodeName}##{el_id}'"))
  expect(res.count).to be > 0
end


Then(/^I should receive confirmation that I've clicked the button$/) do
  page = page(WebViewApp::TabBar).active_page
  res = query(page.query_str("css:'iframe' css:'h2#msg.label.label-success'"))
  expect(res.count).to be == 1
end
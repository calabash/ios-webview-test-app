And(/^I can see the iframe$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    iframe_query = page.query_str("css:'iframe'")
    button_query = page.query_str("css:'iframe' css:'button'")

    visible = lambda do
      !query(iframe_query).empty? &&
      query(button_query).count == 1
    end

    counter = 0
    loop do
      break if visible.call || counter == 10
      scroll(page.query_str, :down)
      step_pause
      counter = counter + 1
    end

    if iphone_35in? || iphone_6_plus?
      scroll(page.query_str, :down)
      step_pause
    end

    res = query(iframe_query)
    expect(res.empty?).to be_falsey
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
  q = page.query_str("css:'iframe' css:'#{nodeName}##{el_id}'")
  enter_text(q, text)
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

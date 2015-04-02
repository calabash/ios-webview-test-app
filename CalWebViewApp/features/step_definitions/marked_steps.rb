
Then(/^I can find the h2 header by using the mark "([^"]*)"$/) do |mark|
  page(WebViewApp::TabBar).with_active_page do |page|
    res = query(page.query_str("marked:'#{mark}'"))
    expect(res.count).to be == 1
  end
end

When(/^I touch the internal link using the mark "([^"]*)"$/) do |mark|
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('Internal Link')
    qstr = page.query_str("marked:'#{mark}'")
    wait_for(options) do
      !query(qstr).empty?
    end
    touch(qstr)
  end
end

Then(/^a query for the FAQ with marked should succeed$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('FAQ List')
    wait_for(options) do
      !query(page.query_str("marked:'FAQ'")).empty?
    end
  end
end

And(/^I touch the toggle\-the\-secret button with mark$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('Toggle the Secret button')
    qstr = page.query_str("marked:'Toggle the Secret'")
    wait_for(options) do
      !query(qstr).empty?
    end
    touch(qstr)
  end
end

Then(/^I should find the secret message with a mark$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('Secret Message')
    qstr = page.query_str("marked:'Let Op!'")
    wait_for(options) do
      !query(qstr).empty?
    end
  end
end

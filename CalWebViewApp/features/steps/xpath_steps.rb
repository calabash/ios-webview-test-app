
Then(/^I can query for hrefs with xpath$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    res = query(page.query_str("xpath:'//a'"))
    # Distinguish between a and a w/ href
    hrefs = res.select { |elm| elm['href'] }
    expect(hrefs.count).to be == 2
  end
end

And(/^I can query for the body with xpath$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    qstr = page.query_str("xpath:'//body'")
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

When(/^I query with xpath I should see at least (\d+) unordered lists$/) do |expected|
  page(WebViewApp::TabBar).with_active_page do |page|
    res = query(page.query_str("xpath:'//ul'"))
    expect(res.count).to be >= expected.to_i
  end
end

Then(/^I can use xpath to find the "([^"]*)" list item$/) do |li_id|
  page(WebViewApp::TabBar).with_active_page do |page|
    res = query(page.query_str("xpath:'//li[contains(@id,\"#{li_id}\")]'"))
    expect(res.count).to be == 1
  end
end

When(/^I touch the internal link with xpath$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('Internal Link')
    qstr = page.query_str("xpath:'//a[contains(@id,\"internal\")]'")
    wait_for(options) do
      !query(qstr).empty?
    end
    touch(qstr)
    wait_for_none_animating
  end
end

Then(/^a query for the FAQ with xpath should succeed$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    qstr = page.query_str("xpath:'//span/a[contains(@id,\"faq\")]'")

    is_wkwebview = qstr[/WKWebView/,0]

    if xamarin_test_cloud?
       xcode_lte_611 = false
    else
      xcode_version = RunLoop::Xcode.new.version
      xcode_lte_611 = xcode_version <= RunLoop::Version.new("6.1.1")
    end

    if xcode_lte_611 && is_wkwebview
      puts %Q{
Detecting Xcode <= 6.1.1 and a WKWebView!

Skipping test because link is not touchable.
}
      $stdout.flush
    else
      res = query(qstr)
      expect(res.count).to be == 1
    end
  end
end

When(/^I touch the toggle\-the\-secret button with xpath$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('Toggle the Secret button')
    qstr = page.query_str("xpath:'//button[contains(@id,\"show_secret\")]'")
    wait_for(options) do
      !query(qstr).empty?
    end
    touch(qstr)
  end
end

Then(/^I should see the secret message using xpath$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    options = wait_options('Secret Message')
    qstr = page.query_str("xpath:'//span[contains(@id,\"secret_message\")]'")
    res = nil
    wait_for(options) do
      res = query(qstr)
      !res.empty?
    end
    expect(res.first['textContent']).to be == 'Let Op!'
  end
end

module WebViewApp
  module JavaScript

    def javascript_hash(js)
      { calabashStringByEvaluatingJavaScript:js }
    end

    def query_with_javascript(page, js)
      query(page.query_str, javascript_hash(js))
    end

  end
end

World(WebViewApp::JavaScript)

And(/^I can see the h1 header with javascript$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    js = "document.getElementsByTagName('h1').toString()"
    visible = lambda {
      query_with_javascript(page, js).count == 1
    }

    counter = 0
    loop do
      break if visible.call || counter == 4
      scroll(page.query_str, :up)
      step_pause
      counter = counter + 1
    end
  end
end

Then(/^I can query for hrefs with javascript$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    js = 'document.links.length'
    res = query_with_javascript(page, js)
    expect(res.count).to be == 1
    expect(res.first.to_i).to be == 2
  end
end

And(/^I can query for the body with javascript$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    js = 'document.body.innerHTML'
    res = query_with_javascript(page, js)
    expect(res.count).to be == 1
    expect(res.first).to be_a_kind_of String
  end
end

When(/^I query with javascript I should see (\d+) unordered lists$/) do |expected|
  page(WebViewApp::TabBar).with_active_page do |page|
    js = "document.getElementsByTagName('ul').length"
    res = query_with_javascript(page, js)
    expect(res.count).to be == 1
    expect(res.first.to_i).to be == expected.to_i
  end
end

Then(/^I can use javascript to find the "([^"]*)" list item$/) do |li_id|
  page(WebViewApp::TabBar).with_active_page do |page|
    js = "document.getElementById('#{li_id}')"
    res = query_with_javascript(page, js)
    expect(res.count).to be == 1
  end
end

When(/^I touch the toggle\-the\-secret button with javascript$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    js = "document.getElementById('show_secret').click()"
    query_with_javascript(page, js)
  end
end

Then(/^I should see the secret message has been revealed using javascript$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    js = "document.getElementById('secret_message').getAttribute('style')"
    options = wait_options('Secret Message Revealed')
    wait_for(options) do
      res = query_with_javascript(page, js)
      if res.empty?
        false
      else
        res.first == 'display: block;'
      end
    end
  end
end

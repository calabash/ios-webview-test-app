When(/^I touch the first name field, the keyboard should appear$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    qstr = page.query_str("css:'input#firstname'")

    options = wait_options('First Name Input')
    wait_for(options) do
      !query(qstr).empty?
    end

    touch(qstr)
    wait_for_keyboard
  end
end

Then(/^I should be able to use the setText API to set the text to "([^"]*)"$/) do |new_text|
  page(WebViewApp::TabBar).with_active_page do |page|
    qstr = page.query_str("css:'input#firstname'")

    options = wait_options('First Name Input')
    wait_for(options) do
      !query(qstr).empty?
    end
    set_text(qstr, new_text)

    js = "document.getElementById('firstname').value"
    hash = { calabashStringByEvaluatingJavaScript:js }
    options = wait_options("firstname => #{new_text}")
    wait_for(options) do
      result =  query(page.query_str, hash)
      if result.count == 1
        result.first == new_text
      else
        false
      end
    end
  end
end

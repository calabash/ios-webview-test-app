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
    sleep(2)
    set_text(qstr, new_text)

    result = query(qstr)
    expect(result.count).to be == 1
    expect(result.first['textContent']).to be == new_text
  end
end

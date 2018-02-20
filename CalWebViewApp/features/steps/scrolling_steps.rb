
And(/^I can see the h1 header with (css|mark|xpath)$/) do |api|
  page = page(WebViewApp::TabBar).active_page

  if api == 'css'
    criteria = "css:'h1'"
  elsif api == 'xpath'
    criteria = "mark:'H1 Header!'"
  else
    criteria = "xpath:'//h1'"
  end

  visible = lambda {
    query(page.query_str(criteria)).count == 1
  }

  counter = 0
  loop do
    break if visible.call || counter == 4
    scroll(page.query_str, :up)
    step_pause
    counter = counter + 1
  end
end

And(/^I can see the green line with (css|xpath)$/) do |api|
  page(WebViewApp::TabBar).with_active_page do |page|
    if api == 'css'
      criteria = "css:'hr#green_stripe'"
    else
      criteria = "xpath:'hr#green_stripe'"
    end
    visible = lambda {
      query(page.query_str(criteria)).count == 1
    }

    counter = 0
    loop do
      break if visible.call || counter == 4
      scroll(page.query_str, :down)
      step_pause
      counter = counter + 1
    end

    # Pause test to allow scrolling to finish
    sleep(1.0)
  end
end

And(/^I find the toggle\-the\-secret button with mark$/) do
  page(WebViewApp::TabBar).with_active_page do |page|
    criteria = "marked:'Toggle the Secret'"
    visible = lambda {
      query(page.query_str(criteria)).count == 1
    }

    counter = 0
    loop do
      break if visible.call || counter == 4
      scroll(page.query_str, :down)
      step_pause
      counter = counter + 1
    end
  end
end

And(/^I can see the (first|last) name text input field$/) do |input_field_id|
  page(WebViewApp::TabBar).with_active_page do |page|
    criteria = "css:'input##{input_field_id}name'"
    visible = lambda {
      query(page.query_str(criteria)).count == 1
    }

    counter = 0
    loop do
      break if visible.call || counter == 4
      scroll(page.query_str, :down)
      step_pause
      counter = counter + 1
    end

    # Visibility heuristic is failing.  Input field is _behind_ the tabbar.
    if iphone_35in?
      scroll(page.query_str, :down)
      step_pause
    end

    sleep 1.0
  end
end

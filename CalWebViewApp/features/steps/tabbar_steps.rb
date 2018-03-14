
Given(/^I am looking at the (UIWebView|WKWebView|SafariWebView) tab$/) do |tab_name|
  tabbar = page(WebViewApp::TabBar).await
  if tab_name == 'UIWebView'
    tabbar.navigate_to(:uiwebview)
  elsif tab_name == 'WKWebView'
    tabbar.navigate_to(:wkwebview)
  else
    tabbar.navigate_to(:safariwebview)
  end

  js = "window.scrollTo(0,0)"
  query(tab_name, {calabashStringByEvaluatingJavaScript:js})
  wait_for_none_animating
end

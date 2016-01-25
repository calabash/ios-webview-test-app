
Given(/^I am looking at the (UIWebView|WKWebView) tab$/) do |tab_name|
  tabbar = page(WebViewApp::TabBar).await
  if tab_name == 'UIWebView'
    tabbar.navigate_to(:uiwebview)
  else
    tabbar.navigate_to(:wkwebview)
  end

  js = "window.scrollTo(0,0)"
  query(tab_name, {calabashStringByEvaluatingJavaScript:js})
  wait_for_none_animating
end

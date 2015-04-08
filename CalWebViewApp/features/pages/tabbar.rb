require 'calabash-cucumber/ibase'
require File.join(File.dirname(__FILE__), '..', 'support', 'wait_options')

module WebViewApp
  class TabBar < Calabash::IBase
    include WebViewApp::WaitOpts

    def trait
      'UITabBar'
    end

    def navigate_to(page_id)
      case page_id
        when :uiwebview
          index = 0
        when :wkwebview
          index = 1
        else
          raise "Expected '#{page_id}' to be one of [:uiwebview, :wkwebview]"
      end

      qstr = "UITabBarButton index:#{index}"
      wait_for(wait_options(qstr)) do
        !query(qstr).empty?
      end

      touch(qstr)
      step_pause
    end

    def active_page
      page_query = query("* {accessibilityIdentifier LIKE 'landing page'}")
      if page_query.empty?
        raise "Could not set active page; could not find 'landing page'"
      end

      page_class = page_query.first['class']
      if page_class == 'UIWebView'
        page(WebViewApp::UIWebView)
      elsif page_class == 'WKWebView'
        page(WebViewApp::WKWebView)
      else
        raise "Expected page class '#{page_class}' to be one of [UIWebView, WKWebView]"
      end
    end

    def with_active_page(&block)
      block.call(active_page)
    end
  end
end

require 'calabash-cucumber/ibase'
require "run_loop"

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
        when :safariwebview
          index = 2
        else
          raise "Expected '#{page_id}' to be one of [:uiwebview, :wkwebview, :safariwebview]"
      end

      qstr = "UITabBarButton index:#{index}"
      wait_for(wait_options(qstr)) do
        !query(qstr).empty?
      end

      count = 0
      begin
        touch(qstr)
      rescue => e
        count = count + 1
        if count == 3
          raise e.message
        else
          puts "Touch failed; retrying..."
        end

        sleep(0.4)
        retry
      end

      with_active_page do |page|
        qstr = page.query_str

        if RunLoop::Environment.xtc?
          timeout = 240
        elsif RunLoop::Environment.ci?
          timeout = 60
        else
          timeout = 30
        end

        options = wait_options('Waiting for page to load',
                               {:timeout => timeout})
        wait_for(options) do
          res = query(qstr, :isLoading)
          !res.empty? && res.first.to_i == 0
        end
      end
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
      elsif page_class == 'SFSafariView'
        page(WebViewApp::SafariWebView)
      else
        raise "Expected page class '#{page_class}' to be one of [UIWebView, WKWebView, SafariWebView]"
      end
    end

    def with_active_page(&block)
      block.call(active_page)
    end
  end
end

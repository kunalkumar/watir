# feature tests for XPath in Frame Element
# revision: $Revision$

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED

require 'unittests/setup'

class TC_Frames_XPath < Test::Unit::TestCase
  def setup
    goto_page "frame-xpath.html"
  end
  
  def test_xpath_support_frame
    assert(browser.button(:xpath , "//div[@id='testDivInMain']/input[@type='button']").exists?)   
    
    assert(browser.frame(:src , "frame-content.html").button(:xpath , "//div[@id='testDivInFrame']/input[@type='button']").exists? )   
  end
  
end


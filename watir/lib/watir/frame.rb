module Watir
  class Frame
    include Container
    include PageContainer
    include XmlParser
    
    # Find the frame denoted by how and what in the container and return its ole_object
    def locate
      how = @how
      what = @what
      frames = @container.document.frames
      target = nil
      
      for i in 0..(frames.length - 1)
        this_frame = frames.item(i)
        case how
        when :index
          index = i + 1
          return this_frame if index == what
        when :name
          begin
            return this_frame if what.matches(this_frame.name)
          rescue # access denied?
          end
        when :id
          # We assume that pages contain frames or iframes, but not both.
          this_frame_tag = @container.document.getElementsByTagName("FRAME").item(i)
          return this_frame if this_frame_tag and what.matches(this_frame_tag.invoke("id"))
          this_iframe_tag = @container.document.getElementsByTagName("IFRAME").item(i)
          return this_frame if this_iframe_tag and what.matches(this_iframe_tag.invoke("id"))
        when :src
          this_frame_tag = @container.document.getElementsByTagName("FRAME").item(i)
          return this_frame if this_frame_tag and what.matches(this_frame_tag.src)
          this_iframe_tag = @container.document.getElementsByTagName("IFRAME").item(i) 
          return this_frame if this_iframe_tag and what.matches(this_iframe_tag.src)
        else
          raise ArgumentError, "Argument #{how} not supported"
        end
      end
      
      raise UnknownFrameException, "Unable to locate a frame with #{how.to_s} #{what}"
    end
    
    def initialize(container, how, what)
      set_container container
      @how = how
      @what = what
      @o = locate
      copy_test_config container
    end
    
    def document
      @o.document
    end

    def attach_command
      @container.page_container.attach_command + ".frame(#{@how.inspect}, #{@what.inspect})"
    end
    
    # return the first element that matches the xpath
    def element_by_xpath(xpath)
      temp = elements_by_xpath(xpath)
      temp = temp[0] if temp
      return temp
    end
    
    # execute xpath and return an array of elements
    def elements_by_xpath(xpath)
      doc = xmlparser_document_object 
      modifiedXpath = ""
      selectedElements = Array.new
      
      # strip any trailing slash from the xpath expression (as used in watir unit tests)
      xpath.chop! unless (/\/$/ =~ xpath).nil?
      
      doc.xpath(xpath).each do |element|
        modifiedXpath = element.path
        temp = element_by_absolute_xpath(modifiedXpath) # temp = a DOM/COM element
        selectedElements << temp if temp != nil
      end
      #puts selectedElements.length
      if selectedElements.length == 0
        return nil
      else
        return selectedElements
      end
    end
    
    
  end
end
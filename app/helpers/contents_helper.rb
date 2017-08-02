module ContentsHelper

    def content_image image, css = ""
    	image_tag(image, class: css) if image
  	end

end
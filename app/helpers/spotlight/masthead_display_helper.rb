module Spotlight
  module MastheadDisplayHelper

    def masthead_style
      return 'background-container' if current_masthead.blur

      'background-container-no-blur'
    end
  end
end

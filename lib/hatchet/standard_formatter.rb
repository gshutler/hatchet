module Hatchet

  class StandardFormatter

    def format(context, msg)
      "#{context} - #{msg.call}"
    end

  end

end


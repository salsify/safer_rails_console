module SaferRailsConsole
  module Colors
    NONE = 0
    RED = 31
    GREEN = 32
    YELLOW = 33

    def color_text(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end
  end
end

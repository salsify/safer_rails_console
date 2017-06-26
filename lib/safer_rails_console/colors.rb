module SaferRailsConsole
  module Colors
    NONE = 0
    BLACK = 30
    RED = 31
    GREEN = 32
    YELLOW = 33
    BLUE = 34
    PINK = 35
    CYAN = 36
    WHITE = 37

    def color_text(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end
  end
end

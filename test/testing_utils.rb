# Some testing utilities
module TestingUtils
  # Turn output on or off
  class ToggleOutput
    def initialize(bool)
      case bool
      when true
        def puts(o)
          super(o)
        end

        def print(o)
          super(o)
        end
      when false
        def puts(_)
          nil
        end

        def print(_)
          nil
        end
      end
    end
  end
end

###Sudoku rev2:
class MarkedArray < Array
    def initialize(arr) 
        super(arr)
        @marker = nil   #range = (-1..self.length)
    end
    def inspect(sup=nil)
        if sup
            super()
        else
            "@marker=#{@marker.inspect}, @arr="+super()
        end
    end
    def to_s
        mrk_s = @marker ? @marker.inspect : '-'
        "("+mrk_s+")"+self.inspect(true)
    end
    def rewind
        @marker = nil
    end
    def first
        @marker = 0
        return self[@marker]
    end
    def current
        if @marker
            return self[@marker]
        else
            return nil
        end        
    end
    def next
        #return: next item in self
        #        or nil (reached to the end)
        #        When reaching to the end, @marker == self.length-1
        return(first) if @marker == nil
        
        raise("invalid index: @marker=#{@marker}") if (@marker < 0) || (@marker > self.length - 1)
        if (@marker == self.length - 1)
            return nil #reached to the end
        else 
            @marker += 1
            return self[@marker] #next item
        end
    end
    def prev
        #return: previous item in self
        #       or nil (reached Top of Array)
        #       When reached to the beginning, @marker == 0
        raise("invalid index: @marker=#{@marker}") if (@marker < 0) || (@marker > self.length - 1)
        if @marker == 0
            return nil #reached to the beginning
        else 
            @marker -= 1
            return self[@marker] #previous item
        end
    end
end



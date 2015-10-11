class Complement
    def initialize
        @complements   = Hash.new{ Array.new }  #nn => Array of Pair 
        # @orphans store cells whose can_be.length ==2 and 
        # that haven't found the pair
        @orphans = Hash.new{ Array.new }  #nn => Array of Cell 
    end
    def register(cell)
        #Array of Pair created
        #false if no pair created(cell is orphan)
        return nil if cell.can_be.length != 2
        pairs = []
        cell.nine_nums.each do |nn|
            found = nil
            @orphans[nn].each do |other|
                if (cell.can_be == other.can_be)
                    found = other
                    break
                end
            end
            if found
                pair = Pair.new([cell,found],cell.can_be)
                pairs << pair
                @complements[nn] += [pair]
                @orphans[nn] -= [found]
            else
                @orphans[nn] += [cell]
                next
            end
        end
        return pairs
    end
    def pairs(nine_num, num=nil)
        #when num is not specified, return all pairs in nine_num
        #when num is specified, return pairs whose can_be include num
        #return: Array of Pair 
        if num == nil
            return @complements[nine_num] 
        else
            return @complements[nine_num].select {|pair| pair.nums.include?(num)}
        end
    end
    def all_nums(nine_num)#return: Array of num
        @complements[nine_num].collect {|pair| [pair.nums[0], pair.nums[1]] }.flatten
    end
    def all_cells(nine_num) #return: Array of Cell
        @complements[nine_num].collect {|pair| pair.cells }.flatten
    end
    def cannot_be(cell) #return: Array of num
        cannot_be = []
        cell.nine_nums.each do |nn| 
            next if all_cells(nn).include?(cell)
            cannot_be += all_nums(nn)
        end
        return cannot_be
    end
end
class Suite
    def initialize(cells, nums)
        @cells = cells.sort{|a,b| a.y*10+a.x <=> b.y*10+b.x}
        @nums = nums.sort
    end
    attr_reader :nums, :cells
    def inspect
        @cells.inject(""){|str,c| str+="(#{c.xy_to_s})"}+",#{@nums.inspect})"
    end
    def ==(other)
        @cells.length == other.cells.length && (@cells - other.cells).empty? && nums == other.nums
    end
    def merge!(other)#other: Pair/Trio
        other.cells.each do |cell|
            @cells << cell if !@cells.include?(cell)
            @cells.sort!{|a,b| a.y*10+a.x <=> b.y*10+b.x}
        end
        other.nums.each do |num|
            @nums << num if !@nums.include?(num)
            @nums.sort!
        end
        return self
    end
    def merge(other)#other: Pair/Trio
        cells =Array.new(self.cells)
        nums = Array.new(self.nums)
        copy = self.class.new(cells,nums)
        
        other.cells.each do |cell|
            copy.cells << cell if !copy.cells.include?(cell)
            copy.cells.sort!{|a,b| a.y*10+a.x <=> b.y*10+b.x}
        end
        other.nums.each do |num|
            copy.nums << num if !copy.nums.include?(num)
            @nums.sort!
        end
        return copy
    end
end
class Pair < Suite
end
class Trio < Suite
end


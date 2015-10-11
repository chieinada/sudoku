require 'complement'

class Alternative
    def initialize
        @bd = nil##############
        @alternatives = Hash.new{ Array.new }  #nn => Array of Pair 
        #@trio = Hash.new{Array.new}
    end
    def register(bd)
        @bd = bd############
        #true if pair(s) created
        #false if no pair created(cell is orphan)
        
        Board::NumRange.each do |num|
            bd.nine_nums.each do |nine_num|
                ok_cells = nine_num.cells_can_be(num)
                @alternatives[nine_num].each do |alt|
                    next if (alt.nums.include?(num))
                        
                    if (alt.nums.length == alt.cells.length) #complements
                        ok_cells -= alt.cells
                    end
                end                 
                if ok_cells.length == 1
                elsif ok_cells.length == 2
                    pair = Pair.new(ok_cells, [num])
                    cell, other = ok_cells[0], ok_cells[1]
                    add(pair,cell.row)    if cell.row.equal?(other.row)
                    add(pair,cell.column) if cell.column.equal?(other.column)
                    add(pair,cell.box)    if cell.box.equal?(other.box)
                elsif ok_cells.length == 3
                    trio = Trio.new(ok_cells, [num])
                    cell, other1, other2 = ok_cells[0], ok_cells[1], ok_cells[2]
                    add(trio,cell.row)    if cell.row.equal?(other1.row) && cell.row.equal?(other2.row)
                    add(trio,cell.column) if cell.column.equal?(other1.column) && cell.column.equal?(other2.column)
                    add(trio,cell.box)    if cell.box.equal?(other1.box) && cell.box.equal?(other2.box)
                end
            end
        end
        return self
    end
    def alternatives(nine_num, num=nil)
        #when num is not specified, return all alternative-pairs in nine_num
        #when num is specified, return alternative-pairs whose can_be include num
        #return: Array of Pair 
        if num == nil
            return @alternatives[nine_num] 
        else
            return @alternatives[nine_num].select {|pair| pair.nums.include?(num)}
        end
    end
    def all_nums(nine_num)#return: Array of num
        @alternatives[nine_num].collect {|pair| [pair.nums[0], pair.nums[1]] }.flatten
    end
    def all_cells(nine_num) #return: Array of Cell
        @alternatives[nine_num].collect {|pair| pair.cells }.flatten
    end
    def cannot_be(cell) #return: Array of num
        cannot_be = []
        cell.nine_nums.each do |nn|
            @alternatives[nn].each do |alt|
                next if alt.cells.include?(cell)
                cannot_be += alt.nums
            end
        end
        return cannot_be
    end
    def add(new_alt, nn)
        return true if @alternatives[nn].any? {|alt| 
                                    new_alt == alt || ((new_alt.cells-alt.cells).empty? && 
                                    (new_alt.nums-alt.nums).empty?)}#already added
               
        @alternatives[nn].each do |alt|
            if (new_alt.cells.length == alt.cells.length) && (new_alt.cells - alt.cells).empty? 
                #they are complement suite
                merged = alt.merge!(new_alt)
                return true
            end
if $TRIO
            if (three_cells = new_alt.cells | alt.cells).length == 3
                @alternatives[nn].each do|alt_2|
                    next if alt.equal?(alt_2)
                    if (three_cells | alt_2.cells).length == 3
                        trio = new_alt.merge(alt).merge(alt_2)
                        @alternatives[nn] << trio
                        #@alternatives[nn] -= [alt, alt_2]
                        return true
                    end
                end
            end
end#$TRIO
        end
        @alternatives[nn] += [new_alt]
        return true
    end
end
class Tactics
    def tactic_6_alternative
        done = []
        str = '' if $VERBOSE
        alternative = Alternative.new.register(@bd)
        alternative.register(@bd)
        Board::NumRange.each do |num|
            cells_cannot_be_num = []
            @bd.nine_nums.each do |nine_num| 
                next if nine_num.have?(num)
                alternative.alternatives(nine_num).each do |alt|
                    if alt.nums.include?(num)
                        cells_cannot_be_num += (nine_num.cells - alt.cells)
                    elsif alt.cells.length == alt.nums.length #complement not including num
                        cells_cannot_be_num += alt.cells
                    end
                end
            end
            @bd.nine_nums.each do |nine_num|
                next if nine_num.have?(num)
                ok_cells = nine_num.cells_can_be(num) - cells_cannot_be_num
                if ok_cells.length == 1
                    result = ok_cells[0].set(num)
                    if !result
                        raise("cell(#{ok_cells[0].xy_to_s}).set(#{num}) failed")
                    end
                    done << ok_cells[0]
                    str += "(#{ok_cells[0].inspect} " if $VERBOSE
                end
                
                
                
            end
        end
        @empty_cells -= done
        return done
    end       
end
require_relative 'complement'

class Alternative
    def initialize
        @bd = nil##############
        @alternatives = Hash.new{ Array.new }  #nn => Array of Suite
        @trios = Hash.new{Array.new}            #nn => Array of Suite
        @cells_to_exclude = Hash.new{Array.new} #num => Cell
    end
    def trios(nn)
        @trios[nn]
    end
    def cells_to_exclude(num)
        return @cells_to_exclude[num]
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
    def make_cells_to_exclude
        Board::NumRange.each do |num|
            cells_to_exclude = []
            trio_cells_to_exclude = []
            @bd.nine_nums.each do |nine_num| 
                next if nine_num.have?(num)
                @alternatives[nine_num].each do |alt|
                    if alt.nums.include?(num)
                        cells_to_exclude += (nine_num.cells - alt.cells)
                    elsif alt.cells.length == alt.nums.length #complement not including num
                        cells_to_exclude += alt.cells
                    end
                end
                @trios[nine_num].each do |trio|
                    if trio.nums.include?(num)
                        trio_cells_to_exclude += (nine_num.cells - trio.cells)
                    elsif trio.cells.length == trio.nums.length
                        trio_cells_to_exclude += trio.cells
                    end

                end
            end
            @cells_to_exclude[num] += (cells_to_exclude + trio_cells_to_exclude)
        end
        return @cells_to_exclude
    end
    def register(bd)
        @bd = bd############
        make_cells_to_exclude if !@alternatives.keys.empty?
        Board::NumRange.each do |num|
            bd.nine_nums.each do |nine_num| 
                ok_cells = nine_num.cells_can_be(num) - cells_to_exclude(num)
                if ok_cells.length == 1
                elsif ok_cells.length == 2
                    pair = Suite.new(ok_cells, [num])
                    #a = ok_cells.inject {|res, val| (res.respond_to?(:nine_nums) ? res.nine_nums : res) & val.nine_nums}
                    (ok_cells[0].nine_nums & ok_cells[1].nine_nums).each {|nn| add(pair, nn)}
                elsif ok_cells.length == 3
                    trio = Suite.new(ok_cells, [num])
                    (ok_cells[0].nine_nums & ok_cells[1].nine_nums & ok_cells[2].nine_nums).each {|nn|
                        add(trio, nn)}
                end
            end #nine_nums
        end
        return self
    end
    def add(new_alt, nn)
        if @alternatives[nn].any? {|alt| new_alt == alt} #already added
            return true 
        elsif new_alt.cells.length == new_alt.nums.length #complement
            @alternatives[nn] += [new_alt]
            return true
        end

        @alternatives[nn].each do |alt|
            if new_alt.cells == alt.cells
            ###
            p "before: "+@alternatives[nn].inspect+"\n\n" if alt.cells==[@bd.cell(0,0),@bd.cell(0,1),@bd.cell(0,5)]
            p "new_alt: #{new_alt.inspect}" if alt.cells==[@bd.cell(0,0),@bd.cell(0,1),@bd.cell(0,5)]
            ###
                merged = alt.merge!(new_alt)
            ###
            p "merged: #{merged.inspect}\n"+@alternatives[nn].inspect+"\n\n" if merged.cells==[@bd.cell(0,0),@bd.cell(0,1),@bd.cell(0,5)]
            ###
                return true
            end
            if (new_alt.cells | alt.cells).length == 3
                trio1 = new_alt.merge(alt)
if $alt
                if @alternatives[nn].all? {|t| t.cells!=trio1.cells || t.nums!=trio1.nums}
                    @alternatives[nn] += [trio1] 
                end
else
                if @trios[nn].all? {|t| t.cells!=trio1.cells || t.nums!=trio1.nums}
                    @trios[nn] += [trio1] 
                end
end
                
                @alternatives[nn].each do|alt_2|
                    next if alt.equal?(alt_2)
                    if ((trio1.cells | alt_2.cells).length == 3)
                        trio2 = trio1.merge(alt_2)
if $alt
                        if @alternatives[nn].all? {|t| t.cells!=trio2.cells || t.nums!=trio2.nums}
                            @alternatives[nn] += [trio2] 
                        end
else
                        if @trios[nn].all? {|t| t.cells!=trio2.cells || t.nums!=trio2.nums}
                            @trios[nn] += [trio2] 
                        end
end
                        
                    end
                end
            end
        end
        @alternatives[nn] += [new_alt]
        return true
    end
end
class Tactics
    def tactic_6_alternative_ok_cells
        done = []
        str = '' if $VERBOSE
if $org
        alternative = Alternative.new.register(@bd)
else
        alternative = Alternative.new
        puts"start1"
        alternative.register(@bd)
        puts"start2"
        p "Tactic6: "+alternative.alternatives(@bd.cell(0,0).column).inspect
        puts
        alternative.register(@bd)
        puts"end"
end
        alternative.make_cells_to_exclude
        Board::NumRange.each do |num|
            @bd.nine_nums.each do |nine_num|
                next if nine_num.have?(num)
                ok_cells = nine_num.cells_can_be(num) - alternative.cells_to_exclude(num)

                if ok_cells.length == 1
                    result = ok_cells[0].set(num)
                    raise("cell(#{ok_cells[0].xy_to_s}).set(#{num}) failed") if !result
                    done << ok_cells[0]
                    str += "(#{ok_cells[0].inspect} " if $VERBOSE
                end
            end
        end
        @empty_cells -= done
        return done
    end
    def tactic_7_alternative_cells_canbe
        done = []
        str = '' if $VERBOSE
        alternative = Alternative.new.register(@bd)
        
        @bd.empty_cells.each do |cell|
            ok_nums = cell.can_be
            raise("Shouldn't be happen! ok_nums is empty.")if ok_nums.empty?
            
            cannot_be = [] #Array of num
            cell.nine_nums.each do |nn|
                alternative.alternatives(nn).each {|alt|
                    cannot_be += alt.nums if !alt.cells.include?(cell)}
            end
            ok_nums -= cannot_be
            raise("Shouldn't be happen! ok_nums is empty.")if ok_nums.empty?
            if ok_nums.length == 1
                result = cell.set(ok_nums[0])
                raise("cell(#{cell.xy_to_s}).set(#{ok_nums[0]}) failed") if !result
                
                done << cell
                str += "(#{cell.inspect} " if $VERBOSE
            end
        end
        @empty_cells -= done
        return done
    end     
    def tactic_8_alternative_ok_cells_R
        done = []
        str = '' if $VERBOSE
        alternative = Alternative.new.register(@bd).register(@bd).register(@bd)
        alternative.make_cells_to_exclude
        Board::NumRange.each do |num|
            @bd.nine_nums.each do |nine_num|
                next if nine_num.have?(num)
                ok_cells = nine_num.cells_can_be(num) - alternative.cells_to_exclude(num)

                if ok_cells.length == 1
                    result = ok_cells[0].set(num)
                    raise("cell(#{ok_cells[0].xy_to_s}).set(#{num}) failed") if !result
                    done << ok_cells[0]
                    str += "(#{ok_cells[0].inspect} " if $VERBOSE
                end
            end
        end
        @empty_cells -= done
        return done
    end
end

require 'board'
require 'complement'
require 'alternative'

class Tactics
    def initialize(bd)
        @disabled = []
        @bd = bd
        @empty_cells = bd.empty_cells
    end
    attr_reader :empty_cells, :disabled
    def solved?
        @empty_cells.empty?
    end
    def tactics
        methods.select{|name| name =~ /^tactic_/}.sort - @disabled
    end
    def disable(*tactic) #tactic: Regular Expression / part of method name
        tactic.each do |tac|
            regexp = /#{tac.to_s}/
            disabled = tactics.select{|name| name =~ regexp} 
            if disabled.empty?
                puts("warning: no tactic disabled") if !$SILENT
            else
                @disabled += disabled
                puts disabled.inject("") {|str,name| str += "disabled: "+name+"\n"} if $VERBOSE #!$SILENT
            end
        end
        return @disabled
    end
    def enable(*tactic) #tactic: Regular Expression / method name String
        tactic.each do |tac|
            regexp = /#{tac.to_s}/
            enabled = @disabled.select{|name| name =~ regexp} 
            if enabled.empty?
                 puts("warning: no tactic enabled") if !$SILENT
            else
                @disabled -= enabled
                puts @disabled.inject("") {|str,name| str += "enabled: "+name+"\n"} if $VERBOSE #!$SILENT
            end
        end
        return @disabled
    end
    def execute(*tactic_names)
        tactic_names = tactics if tactic_names.empty?
        puts  if !$SILENT
        cells_done = []
        tactic_names.each do |tactic|
            puts "#{tactic} start....."  if !$SILENT
            while(true)
                result = method(tactic).call
                break if result.empty?
                
                if !$SILENT #Display results
                    puts "        #{result.length} cells done: "
                    puts '        '+result.inspect.gsub(', ','').gsub(/[\[\]]/,'') if $VERBOSE
                end
                cells_done += result
                break if solved? 
            end
            break if solved?
        end
        puts ":TOTAL #{cells_done.length} cells done."  if !$SILENT
        return cells_done
    end
    def execute_parallel(*tactic_names)
        tactic_names = tactics if tactic_names.empty?
        puts  if !$SILENT
        cells_done = []
        tactic_names.each do |tactic|
            puts "#{tactic} start....."  if !$SILENT
            result = method(tactic).call
            next if result.empty?
            
            if !$SILENT #Display results
                puts "        #{result.length} cells done: "
                puts '        '+result.inspect.gsub(', ','').gsub(/[\[\]]/,'') if $VERBOSE
            end
            cells_done += result
            did_something = true
            break if solved?
        end
        puts ":TOTAL #{cells_done.length} cells done."  if !$SILENT
        return cells_done
    end

end
############################
class Tactics
    #methods named "tactic_*" will be executed
    def tactic_1_only_num_for_cell
        done = Array.new
        @empty_cells.each do |cell|
            can_be = cell.can_be
            raise("This should't be happen!, cell#{cell.inspect}.can_be.length=0") if can_be.empty?
            if can_be.length==1
                cell.set(can_be[0])
                done << cell
            end
        end
        @empty_cells -= done
        return done
    end
    def tactic_2_only_cell_in_nn
        done = Array.new
        nine_nums = @bd.nine_nums
        Board::NumRange.each do |num|
            #select NineNum that doesn't include num yet
            nine_nums.each do |nn| 
                next if nn.have?(num)
                ok_cells = nn.cells_can_be(num)
                if ok_cells.length == 1
                    cell = ok_cells[0]
                    raise("already done! #{cell.inspect}") if cell.num
                    ret = cell.set(num)
                    raise("something bad happen!") if !ret
                    done << cell
                end
            end
        end
        @empty_cells -= done
        return done
    end
    def tactic_3_all_canbe_in_row_or_col
        done = []
        Board::NumRange.each do |num|
            ### choose dame_cells ###
            dame_cells = []
            @bd.boxes.each do |box|
                next if box.have?(num)
                ok_cells = box.cells_can_be(num)
                raise("this shouldn't be happen. num=#{num}") if ok_cells.length == 0

                cell = ok_cells[0] #sample cell
                if (ok_cells.length == (ok_cells & cell.row).length)
                    #all ok_cells are belong to the same row. Other cells in the row can't be num
                    dame_cells += cell.row - ok_cells
                elsif (ok_cells.length == (ok_cells & cell.column).length)
                    #all ok_cells are belong to the same column. Other cells in the column can't be num
                    dame_cells += cell.column - ok_cells
                end
            end
            ###   Search only cell in the row/column that can be num, 
            ###  while excluding dame_cells
            (@bd.rows + @bd.columns).each do |nn|
                ok_cells = nn.cells_can_be(num) - dame_cells
                if ok_cells.length == 1
                    cell = ok_cells[0]
                    result = cell.set(num)
                    raise("something bad happen!") if !result
                    done << cell
                end
            end
        end
        @empty_cells -= done
        return done
    end
    def tactic_4a_all_empty_cell_in_box
        done = []
        (@bd.rows+@bd.columns).each do |nn|
            nn_empty_cells = nn.empty_cells 
            next if nn_empty_cells.length == 0
            box = nn_empty_cells[0].box #take any cell in empty_cells as a sample cell
            
            if (nn_empty_cells - box).empty? ### All nn.empty_cells belong to the same box
                #nums that the box already have, (box.i_have), 
                #and nums that fit to nn.empty_cells. ((1..9) - nn.i_have),
                #don't fit to other cells in the box (box - nn)
                cannot_be = box.i_have + ((1..9).to_a - nn.i_have)
                
                #try to fill cells, (box - nn_empty_cells)
                (box.empty_cells - nn_empty_cells).each do |cell|
                    can_be = cell.can_be - cannot_be
                    if can_be.length == 1
                        cell.set(can_be[0])
                        done << cell
                    end
                end
            end
        end
        @empty_cells -= done
        return done
    end
    def tactic_4b_all_empty_cell_in_row_or_column
        done = []
        @bd.boxes.each do |box|
            box_empty_cells = box.empty_cells 
            next if box_empty_cells.length == 0
            sample = box_empty_cells[0] #take any cell in empty_cells
            
            #check if all box_empty_cells belong to the same row/column
            nns = []
            nns << sample.row    if (box_empty_cells - sample.row).empty?
            nns << sample.column if (box_empty_cells - sample.column).empty?

            #try nums to fill cells in (row/column - box)
            nns.each do |nn|
                #nums that don't fit to cells in (row/column - box)
                cannot_be = (1..9).to_a - box.i_have + nn.i_have
                (nn.empty_cells - box_empty_cells).each do |cell|
                    can_be = cell.can_be - cannot_be
                    if can_be.length == 1
                        cell.set(can_be[0])
                        done << cell
                    end
                end
            end
        end
        @empty_cells -= done
        return done
    end
    def tactic_5_complement
        done = []
        ### find all complement-pairs
        complement = Complement.new
        @empty_cells.each {|cell| complement.register(cell)} 
        
        ### fill empty_cells (only-cell-in-nn)
        #str = "          set" if $VERBOSE
        Board::NumRange.each do |num|
            @bd.nine_nums.each do |nn| 
                next if nn.have?(num) #try nine_num that has not num
                next if not complement.pairs(nn, num).empty?
                
                cells = nn.cells - complement.all_cells(nn)
                ok_cells = cells.select {|cell| 
                    can_be = cell.can_be - complement.cannot_be(cell)
                    cell.empty? && can_be.include?(num)
                }
                
                if ok_cells.length == 0
                    puts @bd.to_s
                    raise("This shouldn't happen. ok_cell.length == 0. num=#{num}, nn=#{nn.inspect}")
                elsif ok_cells.length == 1
                    ok_cells[0].set(num)
                    done << ok_cells[0]
                    #str += "(#{ok_cells[0].x},#{ok_cells[0].y})=#{num} " if $VERBOSE
                    #puts "(#{ok_cells[0].x},#{ok_cells[0].y})=#{num} " if $VERBOSE 
                end
            end
        end
        #puts str if !done.empty? if $VERBOSE
        @empty_cells -= done
        return done
    end
end
############################
############################
__END__
ARGV.each do |fname|
    sv = Solver.new(fname)
    #puts "#{81-sv.bd.empty_cells.length} cells given"
    
    tc = Tactics.new(sv.bd)
    tactics = tc.tactics
    done = []
    
    while true 
        result = tc.execute(*tactics)
        done += result
        break if tc.solved?
        break if result.length == 0
    end
    puts
    puts sv.bd.to_s
    puts "\nsolved!" if tc.solved?
    if !tc.solved?
        puts "\nincomplete."
        puts " I filled #{done.length} cells. #{sv.bd.empty_cells.length} cells remains"        
    end
    puts
    
end

###Sudoku rev1a:  Mar 19 2007
# Mar-18-2007 Changed:
#       - push given-cells in Solver::@history and stop skipping 
#         given-cells after @history.pop 
# Mar-18-2007 Bug Fixed: 
#       -Problem: Only 19 solutions of problem1M.sdk, out of 48, were found.
#       -Fixed: After the first solution was found, SolverCell::clear must 
#           be called for the last cell (8,8) in Solver::go_backward.
#
#
require 'markedarray'
require 'problem'
require 'sudoku'

class History < Array
    def initialize
        @poped_count = 0
        super
    end
    def pop
        @poped_count += 1
        super
    end
    def count
        @poped_count
    end
end
#####################################################
class SolverCell < MarkedArray
    def initialize(idx, bd)
        @bd = bd
        @x, @y = idx % 9, idx / 9
        super(items_to_try)
    end
    def given?
        @bd.cell(@x,@y).given?
    end
    def clear
        @bd.cell(@x,@y).clear
    end
    def to_s
        str="(x,y,n)=(#{@x},#{@y}"
        str+=",#{self[@marker]}" if @marker
        return str+")"
    end
    def items_to_try
        #return: array of items
        arr = Array.new
        if given?
            arr << @bd.cell(@x,@y).num 
        else
            9.times do |n|
                num = n+1
                cell = @bd.cell(@x,@y).set(num)
                if !cell #this num is not fit
                    next
                else 
                    @bd.cell(@x,@y).clear
                    arr << num
                end
            end
        end
        return arr
    end
    def try
        clear
        while(item = self.next)
            if given?
                found = true
            else
                found = @bd.cell(@x,@y).set(item)
                break if found
            end
        end
        return (found ? item.to_i : nil) 
    end
end
#####################################################
class Solver < MarkedArray
    
    def initialize(fname) 
        @talkative = $VERBOSE
        @bd = Board.new
        @history = History.new 
        @problem = Problem.read(fname)
        @bd.load_problem(@problem)
        puts @bd.to_s+"\n"

        solver_cells = Array.new(Board::Width**2) {|idx| SolverCell.new(idx, @bd) }
        super(solver_cells)
    end
    def inspect_bd(comment=true)
        if comment
            @problem.comments + @bd.to_s + "\n"
        else
            @bd.to_s + "\n"
        end
    end
    def inspect(sup=false)
        if sup
            return super
        else
            str = "@marker="+@marker.inspect+", \n"
            9.times do |y|
                9.times do |x|
                    idx = x + y * 9
                    str += "(#{x},#{y}) = "
                    str += self[idx].to_s + "\n"
                end
                str += "\n"
            end
            return str
        end
    end
    def history
        @history
    end
    def go_backward
        current.clear
        current.rewind
        puts "[-]rewind: #{current.inspect} #{current.to_s}" if @talkative
        removed = @history.pop
        puts "[#{@history.length}]removed: #{"-"} #{removed.inspect} #{removed.to_s}" if @talkative
        while (cell = prev)
            raise("on the wrong track!\n" +
                "[-]prev: #{"-"} #{cell.inspect} #{cell.to_s}") if removed && !removed.equal?(cell)

            found = cell.try #loop until find
            if found
                @history << cell
                puts "[#{@history.length-1}]found: #{found} #{cell.inspect} #{cell.to_s}" if @talkative
                return true
            else
                puts "[-]prev: #{"-"} #{cell.inspect} #{cell.to_s}" if @talkative
                current.clear
                cell.rewind
                puts "[-]rewind: #{cell.inspect} #{cell.to_s}" if @talkative
                removed = @history.pop
                puts "[#{@history.length}]removed: #{"-"} #{removed.inspect} #{removed.to_s}" if @talkative
                next
            end
        end
        puts "I couldn't find a solution. I was back to the beginning."
        puts history.count.to_s + " of wrong attempts\n\n"
        return false
    end
    def go_forward
         while (cell = self.next)
            found = cell.try
            if found
                @history << cell
                puts "[#{@history.length-1}]found: #{found} #{cell.inspect} #{cell.to_s}" if @talkative
                next
            else
                puts "[--]STUCK!!: #{found} #{cell.inspect} #{cell.to_s}" if @talkative
                puts inspect_bd if @talkative
        
                puts "GO BACK!!!" if @talkative
                result = go_backward
                return false if !result
                puts "GO FORWARD!" if @talkative
                next
            end
        end
        return true #return when all cells has done
    end
    def solve
        try_count = 1
        found = go_forward
        if !found
            puts "Sorry. I couldn't solve it."
            return false
        end
        result(try_count)
        
        while (found)    
            try_count += 1
            found = another_attempt
            result(try_count) if found
        end    
        return true
    end
    def result(try_count=1)
        if try_count == 1
            another = "a"
        else
            another = "another"
        end
        puts "I found #{another} solution!!!"
        puts "#Solution #{try_count}"
        puts inspect_bd(false)
        puts history.count.to_s + " of wrong attempts"
        puts 
    end
    def another_attempt
        puts "I'll continue to find another solution..."
        puts "GO BACK!!!" if @talkative
        
        @history.pop #pop last cell (8,8)
        result = go_backward
        return false if !result
        
        puts "GO FORWARD!" if @talkative
        result = go_forward
        return false if !result
        
        return true
    end
end
####################################
#talkative = $VERBOSE
#talkative = false
ARGV.each do |fname|
    sv = Solver.new(fname)
    sv.solve
end
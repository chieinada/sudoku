###Sudoku rev1: 
#[Comments] Given-cells aren't pushed into Solver::@history, 
#          and are skipped after Solver.next, Solver.prev
#[Known bug] Only 19 solutions of problem1M.sdk, out of 48, were found.
#       => fixed in rev1.1
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
        self.length == 0
    end
    def to_s
        str="(x,y,n)=(#{@x},#{@y}"
        str+=",#{self[@marker]}" if @marker
        return str+")"
    end
    def items_to_try
        #return: array of items
        arr = Array.new
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
        return arr
    end
    def try
        return (@bd.cell(@x,@y).num) if self.length == 0 #given cell
        @bd.cell(@x,@y).clear
        while(item = self.next)
            found = @bd.cell(@x,@y).set(item)
            break if found
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
        removed = @history.pop
        puts "[#{@history.length}]removed: #{"-"} #{removed.inspect} #{removed.to_s}" if @talkative
        while (cell = prev)
            if cell.given?
                puts "[-]skip!: - #{cell.inspect} #{cell.to_s}" if @talkative
                next 
            end
            raise("on the wrong track!\n" +
                "[-]prev: #{"-"} #{cell.inspect} #{cell.to_s}") if removed && !removed.equal?(cell)

            found = cell.try #loop until find
            if found
                @history << cell
                puts "[#{@history.length-1}]found: #{found} #{cell.inspect} #{cell.to_s}" if @talkative
                return true
            else
                puts "[-]prev: #{"-"} #{cell.inspect} #{cell.to_s}" if @talkative
                cell.rewind
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
            if cell.given?
                puts "[-]skip!: - #{cell.inspect} #{cell.to_s}" if @talkative
                next 
            end
            found = cell.try
            if found
                @history << cell
                puts "[#{@history.length-1}]found: #{found} #{cell.inspect} #{cell.to_s}" if @talkative
                next
            else
                puts "[--]STUCK!!: #{found} #{cell.inspect} #{cell.to_s}" if @talkative
                puts inspect_bd if @talkative
        
                puts "GO BACK!!!" if @talkative
                cell.rewind
                result = go_backward
                return false if !result
                puts "GO FORWARD!" if @talkative
                next
            end
        end
        return true #return when all cells has done
    end
    def solve
        found = go_forward
        if !found
            puts "Sorry. I couldn't solve it."
            return false
        end
        result
        
        try_count = 2
        while (found)
            found = another_attempt
            result(try_count) if found
            try_count += 1
        end
        return true
    end
    def result(try_count=1)
        if try_count == 1
            another, try_count_s = "a", nil 
        else
            another = "another"
            try_count_s = "I tried #{try_count} times"
        end
        puts "I found #{another} solution!!!\n\n"
        puts inspect_bd(false)
        puts history.count.to_s + " of wrong attempts"
        puts try_count_s if try_count_s
        puts 
    end
    def another_attempt
        puts "I'll continue to find another solution..."
        puts "GO BACK!!!" if @talkative
        
        current.rewind
        @history.pop if !current.given? 
        result = go_backward
        return false if !result
        
        puts "GO FORWARD!" if @talkative
        result = go_forward
        return false if !result
        
        return true
    end
end
####################################
#talkative = $VERBOSE #moved to Solver::initialize()
#talkative = false
ARGV.each do |fname|
    sv = Solver.new(fname)
    sv.solve
end
###Sudoku rev1a:  Mar 19 2007
#  [Added] 
#   - Problem::diff(other)
#   - Problem::to_s
#  [Changed] 
#   - Problem.read() create new Problem object.
#   - remove instance variable: Problem::@fname, 
#    and store fname in @comments

require 'sudoku'

class Problem < Array
    def initialize(arr, comments=nil)
        @comments = comments 
        super(arr).freeze
    end
    #attr_accessor :comments
    attr_reader :comments
    def to_s
        str = ""
        each_index do |idx|
            str += self[idx]+" "
            str += "\n" if idx % 9 == 8
        end
        @comments+"\n"+str
    end
    def diff(other)
        arr_self = Array.new
        arr_other = Array.new
        count = 0
        str = ""
        each_index do |idx|
            if self[idx] == other[idx]
                arr_self << '='
                arr_other << '='
            else
                count += 1
                arr_self << self[idx].to_s
                arr_other << other[idx].to_s
            end
            if arr_self.length == 9
                s = o = ""
                arr_self.each {|cell| s += cell+" "}
                arr_other.each {|cell| o += cell+" "}
                str += (s+"    "+o+"\n")
                arr_self.clear
                arr_other.clear
            end
        end
        return "#{count} cells differ.\n"+str
    end
    def Problem.read(fname)
        #return: new Problem object
        cmts = "#"+fname+"\n"
        puts cmts
        arr = Array.new
        IO.readlines(fname, "\n").each do |line| 
            next if !(line =~/^\s*[-#1-9]/) 
            if (line =~ /^\s*#/)#comment line ('#' at the beginning)
                puts line.chomp
                cmts << (line.chomp+"\n")
                next
            elsif (line =~ /^\s*[-1-9]/)#game description line  ([-1-9] at the beginning)
                line.gsub!(/\s+/,'')
                nums = line.split('').collect {|char| 
                    raise("invalid character '#{char}' found in #{fname}") if !(char =~ /^[-1-9]$/)
                    char }
                arr << nums
            end
        end
        arr.flatten!
        raise("wrong file format. wrong number of cells(#{arr.length} cells) in #{fname}") if arr.length != Board::Width**2
        problem = self.new(arr, cmts)
        return problem
    end
end
###############
__END__
fname = "../sdk/problem1.sdk"
problem = Problem.read(fname)
bd = Board.new
bd.load_problem(problem)
puts bd.to_s+"\n"
p bd.to_problem
__END__
fname = ARGV[0]
#ARGV.each do |fname|
    problem = Problem.read(fname)
    bd = Board.new
    bd.load_problem(problem)
    puts bd.to_s+"\n"
    
    pb = bd.to_problem
    p pb
    
#end

#p problem.given_cells
#p problem.given_cells.length

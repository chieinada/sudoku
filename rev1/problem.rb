###Sudoku rev1: 
require 'sudoku'

class Problem < Array
    def initialize(arr, comments=nil)
        @comments = comments 
        super(arr)
    end
    attr_reader :comments
    def Problem.read(fname)
        #return: new Problem object
        comments = "#"+fname+"\n"
        puts comments
        arr = Array.new
        IO.readlines(fname, "\n").each do |line| 
            next if !(line =~/^\s*[-#1-9]/) 
            if (line =~ /^\s*#/)#comment line ('#' at the beginning)
                puts line.chomp
                comments << (line.chomp+"\n")
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
        problem = self.new(arr)
        problem.comments = comments
        return problem
    end
end
###############
__END__
fname = "sdk/problem1.sdk"
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

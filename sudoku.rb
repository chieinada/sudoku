### sudoku.rb  #######################################################
# Solve 9x9 Sudoku problem(s) in *.sdk file(s)                        
# >>ruby sudoku.rb [FILE]...                                      
#    
# *.sdk files are located in ./sdk/*.sdk
# This is a sample of sdk file (./sdk/364640776.sdk)
# - - - 8 7 - - - -  
# 5 - - - 4 - 7 1 -
# - 7 - 2 - - 3 - - 
# 6 - - - - - - - 2
# - 2 - - 8 - - 7 - 
# 1 - - - - - - - 6
# - - 9 - - 8 - 4 - 
# - 8 4 - 9 - - - 7
# - - - - 5 3 - - - 
#  
####################################################################
require_relative 'solver'
require_relative 'tactic'

ARGV.each do |arg|
    if arg =~ /^-/
      puts "Sudoku: ignore commandline option: #{arg}"
      next
    else  
      puts "Sudoku: loading SDK file: #{arg}..."
      fname = arg
    end
    sv = Solver.new(fname)    
    tc = Tactics.new(sv.bd)
#    tactics = tc.tactics  #tactics is no longer refered

    tc.disable(7)
    tc.disable(8)
   
    #tc.disable("[#{disable}]") if disable
    #dis = tc.enable("[#{enable}]") if enable
    
    done = []
    while(true)
      result = tc.execute
      break if result.empty?
        
      done += result
      break if tc.solved?
    end
    
    #display results
    puts  
    puts sv.bd.to_s
    if tc.solved?
      puts "\nsolved! I filled #{done.length} cells."
    else 
      puts "\nXXXXX incomplete. I filled #{done.length} cells. "
      puts "#{sv.bd.empty_cells.length} cells remains"
    end
    puts
    puts
end

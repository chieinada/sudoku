require_relative 'solver'
require_relative 'tactic'
require_relative 'problem'

verbose = $VERBOSE
$VERBOSE = false
    $PARA = $para || $p || $pv || $ps || $sp
    verbose = verbose || $v ||$pv || $vp
    $SILENT = $ps || $s || $sp || $sr || $rs 
    $RESULT = !$SILENT || ($SILENT && ($r || $sr || $rs || $pr || $rp))
    $PER = $p
    REPEAT = $50 ? 50 : 1
    ALL = $a
$VERBOSE = verbose

ARGV.each do |fname|
    #bd = Board.new.load_problem(Problem.read(fname))
    sv = Solver.new(fname)
    bd = sv.bd
    
    tc = Tactics.new(bd)
    REPEAT.times do
        result = tc.execute_parallel(:tactic_4a_all_empty_cell_in_box) if !ALL
        result = tc.execute_parallel(*tc.tactics) if ALL
        result = tc.execute_parallel(*tc.tactics) if ALL
        
        puts "\nRESULT: "+result.inspect if $VERBOSE 
        puts "\n"+bd.to_problem.to_s
        bd.clear
        
        if !$SILENT || $RESULT #display results
            if tc.solved?
                puts "\nsolved!" 
            else# !tc.solved?
                puts "\nincomplete."
            end
            puts
        end
    end
end

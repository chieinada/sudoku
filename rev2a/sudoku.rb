#! /usr/local/bin/ruby -s
require 'solver'
require 'tactic'

### read command option
verbose = $VERBOSE
$VERBOSE = nil
    $PARA = $para || $p || $pv || $ps || $sp
    verbose = verbose || $v ||$pv || $vp
    $SILENT = $ps || $s || $sp || $sr || $rs 
    $RESULT = !$SILENT || ($SILENT && ($r || $sr || $rs || $pr || $rp))

    $SOLVER = $solver
    $ANOTHER_ATTEMPT = $a
    
    $TRIO = $trio
$VERBOSE = verbose

ARGV.each do |arg|
    raise("#{arg}")if arg =~ /^-/
    fname = arg
    sv = Solver.new(fname)    
    if $SOLVER
        sv.solve
        exit
    end
    tc = Tactics.new(sv.bd)
    tactics = tc.tactics
    #tc.disable(6)
    
    done = []
    while(true)
        if $PARA
            result = tc.execute_parallel
        else
            result = tc.execute
        end
        break if result.empty?
        
        done += result
        break if tc.solved?
    end
    
    if !$SILENT || $RESULT #display results
        puts  
        puts sv.bd.to_s
        puts "\nsolved! I filled #{done.length} cells." if tc.solved?
    end
    if !$SILENT || $RESULT
        if !tc.solved?
            puts "\nincomplete."
            puts "I filled #{done.length} cells. #{sv.bd.empty_cells.length} cells remains"
        end
        puts
    end
end
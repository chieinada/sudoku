#! /usr/local/bin/ruby -s
require 'solver'
require 'tactic'

### read command option
verbose = $VERBOSE
$VERBOSE = nil
    $PARA = $para || $p || $pv || $ps || $sp
    verbose = verbose || $v ||$pv || $vp
    $SILENT = $ps || $s || $sp || $sr || $rs ||$sm ||$ms
    $RESULT = !$SILENT || ($SILENT && ($r || $sr || $rs || $pr || $rp))
    $MESSAGE = $sm ||$ms

    $SOLVER = $solver
    $ANOTHER_ATTEMPT = $a #do another attempt
    disable = enable = nil
    disable = disable ? disable+'1' : '1' if $d1 
    disable = disable ? disable+'2' : '2' if $d2 
    disable = disable ? disable+'3' : '3' if $d3 
    disable = disable ? disable+'4' : '4' if $d4 
    disable = disable ? disable+'5' : '5' if $d5 
    disable = disable ? disable+'6' : '6' if $d6 
    disable = disable ? disable+'7' : '7' if $d7 
    disable, enable = '1-7', enable ? enable+'1' : '1'  if $t1
    disable, enable = '1-7', enable ? enable+'2' : '2'  if $t2
    disable, enable = '1-7', enable ? enable+'3' : '3'  if $t3
    disable, enable = '1-7', enable ? enable+'4' : '4'  if $t4
    disable, enable = '1-7', enable ? enable+'5' : '5'  if $t5
    disable, enable = '1-7', enable ? enable+'6' : '6'  if $t6
    disable, enable = '1-7', enable ? enable+'7' : '7'  if $t7
    
#p disable    
#p enable    
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
    tc.disable("[#{disable}]") if disable
    dis = tc.enable("[#{enable}]") if enable
    
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
    
    str = $MESSAGE ? sv.bd.comments.chomp : ''
    if !$SILENT || $RESULT  || $MESSAGE#display results
        puts  if !$MESSAGE
        puts sv.bd.to_s if !$MESSAGE
        puts str+"\nsolved! I filled #{done.length} cells." if tc.solved?
    end
    if !$SILENT || $RESULT || $MESSAGE
        if !tc.solved?
            puts str+"\nXX incomplete. I filled #{done.length} cells. "
            puts "#{sv.bd.empty_cells.length} cells remains"
        end
        puts
    end
end
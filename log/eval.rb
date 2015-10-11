require 'problem'
class Problem
    def Problem.mread(fname)
        #read multiple Problmes
        problems = Array.new
        arr = Array.new
        comments = ""
        line_count = 0
        IO.readlines(fname, "\n").each do |line|
            line_count += 1
            if line =~ /^(\d)\s+(\d)\s+(\d)\s+(\d)\s+(\d)\s+(\d)\s+(\d)\s+(\d)\s+(\d)\s+$/
                line_start = line_count if arr.length == 0
                arr << $1 << $2 << $3 << $4 << $5 << $6 << $7 << $8 << $9 
                if arr.length == Board::Width**2
                    problems << Problem.new(arr, "#solution #{problems.length+1}: ")
                    arr.clear
                    comments = ""
                elsif arr.length > Board::Width**2
                    raise("something wrong!")
                end
            else
                raise("wrong file format '#{fname}' line #{line_start}-#{line_count}") if arr.length > 0 
            end
        end
        return problems  #Array of Problems
    end
end
class OurPb  < Array
    def initialize(name, fname)
        @name = name
        @fname = fname
        super(Problem.mread(fname))
    end
    def to_s
        str = ""
        each {|pb| str += pb.to_s+"\n"}
        str
    end
    attr_reader :name
end
makotos = OurPb.new("makoto", "makoto.log")
chies = OurPb.new("chie", "chie.log")
#chies = OurPb.new("chie", "problem1M.log")
#chie2s = OurPb.new("chie2", "chie2.log")

target = chies.dup
check = makotos.dup
while(cmp = target.pop)
    idx = target.length
    if check.include?(cmp)
        puts "#{check.name} have #{target.name}s[#{idx}] at #{check.index(cmp)}" 
    end
    puts "#{check.name} doesn't have it!" if !check.include?(cmp)
    
    #puts "I have" if chies.include?(cmp)
    #puts "chie doesn't have it!" if !chies.include?(cmp)
end
puts "done."
puts 
puts "#####################################################"
puts "#####################################################"
puts "compare chies[n] vs [n-1]"
target = chies.dup
cur = target.pop
cur_idx = target.length+1
while(nxt = target.pop)
    nxt_idx = target.length+1
    puts "diff [#{cur_idx}]vs[#{nxt_idx}] #{cur.diff(nxt)}"
    cur, cur_idx = nxt, nxt_idx
end
puts "done"
__END__
puts "#####################################################"
puts "#####################################################"
puts "compare makotos[n] vs [n-1]"
target = makotos.dup
cur = target.pop
cur_idx = target.length+1
while(nxt = target.pop)
    nxt_idx = target.length+1
    puts "diff [#{cur_idx}]vs[#{nxt_idx}] #{cur.diff(nxt)}"
    cur, cur_idx = nxt, nxt_idx
end
puts "done"

puts "#####################################################"
puts "#####################################################"
puts "compare chies[0] vs [n]"
target = chies.dup
cur, cur_no = chies[0], 1
while(nxt = target.pop)
    nxt_no = target.length+1
    puts "diff [#{cur_no}]vs[#{nxt_no}] #{cur.diff(nxt)}"
    cur, cur_no = nxt, nxt_no
end
puts "done"
=begin
puts "#####################################################"
puts "#####################################################"
puts "compare chies[n] vs chie2s[n]"
target = chies.dup
other = chie2s.dup
while(nxt = target.pop)
    cmp = other.pop
    no = target.length+1
    puts "diff [#{no}chies vs chie2s] #{nxt.diff(cmp)}"
end
puts "done"
=end
__END__
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
        problem = self.new(arr, comments)
        return problem
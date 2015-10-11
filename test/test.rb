require 'sudoku'


=begin
def try(bd, kouhos, done)
    decided = 0
    kouhos.each_index do |idx|
        x, y = idx % 9, idx / 9
        kouho = kouhos[idx]
        next if (kouho.length == 0) #already done or given
        kouho.each do |num|
        bd.set(x, y, num, false)
        
        
        
        
        decided += 1 if kouho.length == 1
        bd.cell(x, y).clear if kouho.length > 1
    end
    done += decided
    puts "decided = "+decided.to_s+", done = "+done.to_s
    puts bd
    puts
    return done
end
=end
problem = 
%w[- - - - 8 - - - - 
2 9 - - - 6 1 7 - 
- 5 - 7 - 9 - - - 
- - 4 - - - 5 - - 
1 - - - 4 - - - 3 
- - 6 - - - 8 - - 
- - - - - 8 - 9 - 
- 6 1 - - - - 4 5 
- 2 - - 3 - - - -] #24 given numbers

bd = Board.new
#initialize problem
count=0
problem.each_index do |idx|
  char = problem[idx]
  #puts "idx,char = "+idx.inspect+","+char.inspect
  if(/^\d$/ =~ char)
    x = idx % 9 
    y = idx / 9
    bd.cell(x, y).set(char.to_i, true)
    #puts "(x,y,n)=(#{x},#{y}.#{char.to_i})"
    count += 1
  else
    next
  end
end
#create kouhos[]
puts "initial board..."
puts bd

puts "\ncreate kouho..."
given_count = 0
decided = 0
kouhos = Array.new(81) do |idx| 
    x, y = idx % 9, idx / 9
    kouho = Array.new
    given = false
    9.times do |num|
        if (given = bd.cell(x,y).given?)
            #kouho.length == 0 if given 
            given_count += 1
           break 
        end
        kouho << (num+1) if bd.cell(x, y).set(num+1, false)
    end
    if (kouho.length ==1) #clear decided kouho
        decided += 1 
        kouho.pop
    end
    bd.cell(x,y).clear if (kouho.length > 1)
    #puts "(#{x},#{y})=#{kouho.inspect} "+(given ? "given" : "")
    kouho
end
puts "given = "+given_count.to_s + " decided = "+decided.to_s
puts bd
puts"++++++++++++++++++"
cp = bd.dup
p cp.inspect
puts"++++++++++++++++++"
p bd.inspect
__END__
try_idx = 1
puts "\ntry (#{try_idx})"
decided = try(bd,kouhos, decided+given_count)



=begin
#input decided num to bd
puts "given = "+given_count.to_s
puts bd
puts
count = 0
81.times do |idx|
  x, y = idx % 9, idx / 9
  kouho = kouhos[idx]
  if kouho.length == 1
    bd.set(x,y,kouho[0],false) 
    count += 1
  end
end
puts "decided = "+(count-given_count).to_s
=end
__END__
puts bd

bd.set(0,0,1,true)
bd.clear
p bd    #cell(0,0) == (1t) not cleared
bd.clear!
p bd    #all cleared
__END__
cell = Cell.new
cell.set!(1,false)
p (cell.equal? cell.clear) #true

=begin
b=Board.new
p b.cell(1,1).inspect
p b.cell(1,1).to_s
puts b.inspect
9.times {|x|
    9.times {|y|
        b.set(x,y,x+1)
    }
}
puts b.inspect
puts b
puts
@cells = Array.new(81) {|idx| Cell.new}
cell = @cells[5]
cell.set(5,true)
p @cells[5].inspect
=end

=begin
nn=NineNum.new
cells = Array.new(9){|idx| Cell.new.set(idx+1)}
other = Cell.new.set(3)
cells.each do |cell|
    puts "#{cell.to_s}: include? 3 = #{nn.include?(other)}"
    puts "nn<<cell: #{nn<<cell}"
    puts "nn: #{nn}"
    puts
end
puts"##########"
nn = NineNum.new
cell = Cell.new
11.times do |idx|
    puts "#{idx}: include? 3 = #{nn.include?(other)}"
    puts "nn<<cell: #{nn<<cell}"
    puts "nn: #{nn}"
    puts
end
=end

=begin
puts"##########"
nn = NineNum.new
cells = Array.new(9){|idx| Cell.new.set(idx+1)}
other = Cell.new.set(5)
more = Cell.new

result = nn<<other
puts "nn<<#{other}: #{result}"
cells.each do |cell|
    result = nn<<cell
    puts "nn<<#{cell}: #{result}"    
end
#result = nn<<other
#puts "nn<<#{other}: #{result}"    

#result = nn<<more
#puts "nn<<#{more}: #{result}"    
=end



__END__
##test Sudoku
bd = Board.new
p 1
p bd
p bd.cell(1,1).to_s #initialized value
p  bd.cell(1,1).inspect
p 2
#bd.set(1,9,9,true) #out of range, y>8
#bd.set(9,0,9,true) #out of range, x>8
#bd.set(1,8,0,true) #out of range, num<1
#bd.set(0,8,1,33)   #given=33
#p bd.cell(1,9).to_s #out of range y>8
#p bd.cell(11,1).inspect #out of range x>8
p "2-1"
bd.set(1,8,9,true) #cell[1,8]=(9,true)
p bd.cell(1,8).to_s
p bd.cell(1,8).inspect
p 3
p bd.inspect_row(1) #initialized value
#p bd.inspect_row(9) #out of range y>8
p 4
p bd.row_to_s(1)
#p bd.row_to_s(9) #invalid row y>8
p 5
bd.clear!
9.times{|i| bd.set(i,i,i+1,true)}
puts bd.to_s
p bd.inspect

__END__
def f(a,b,c)
    a+=1
    b+=2
    c+=3
end

def g(arr)
    arr[0]*=1
    arr[1]*=2
    arr[2]*=3
end

arr=[1,1,1]

f(*arr)
p arr
g(arr)
p arr

if arr
    puts true
else
    puts false
end

__END__





def check(num)
    if num <10
        result = "less than ten"
    elsif num ==10
        result = "equal ten"
    else 
        result = "greater than ten"
    end
end

puts "num = 8, " + check(8).to_s
puts "num = 10, " + check(10).to_s
puts "num = 12, " + check(12).to_s


#array.length
arr = [1,2,3,4,5]
puts "\narr = " +arr.to_s
puts "Array.length = " + arr.length.to_s

arr = [11,12,13,14,15]
puts "\n" + arr.inspect


#
str = "orange"
puts str.plural
puts "Just hit return key!"
while (str=gets) != "\n" do
    puts str.inspect
end

s = "potato"
puts s[s.length-1, 1]


s ="good bye!"
puts s + " = " + s.length.to_s + " characters"
#
puts true & false
puts false || false
#
sample = ["day","boy","donkey","guy","puppy","plum","llllliy", "ayayou"]
sample.each do |s|
    puts s[/[aeiou]y$/]
end
puts""
sample.each do |s|
    puts s[/.$/] #return substring
end
puts""
sample.each do |s|
    puts s=~/y$/ #return index
end
puts""
t = s = "body"
s[/y$/]="ies"
puts t #t is modified too when s is modified
s = "lady"
t = s.gsub(/y$/,'ies')
puts t
puts s
puts""
sample = ['calf', 'half', 'pool', 'girl', 'half sandwitch', 'wife', 'knife',
        'wipe', 'canadian wolf', 'kitchen knife', 'cliff', 'leaflet', 'relief', 'reef',
        'cream puff', 'orange', "tomato", "brush", "box","church",
        'kiss','baby','other country', 'fly','lady','boy','day','donkey','guy', 
        'kimono', 'kilo', 'potato']
sample.each do |s|
    if s[/calf$|half$|leaf$|life$|loaf$|self$|sheaf$|shelf$|thief$|wolf$/]
        puts s.sub(/f$/, 'ves')
    elsif s[/knife$|wife$/]
        puts s.sub(/fe$/, 'ves')       
    elsif s[/[sc]h$/]
        puts s + 'es'
    else
        puts s +'s'
    end
    
end
p""
sample.each do |s|
    p s.plural
end
###
def upcase(str)
    str.upcase!
end
def replace(str)
    str = "I replace it!"
end
def add_some(str)
    str + ' good luck!'
end

str = "do your best!"
replace(str)#str point original string. the method can't modify str
puts str    #same

upcase(str) #contents of str modified in the method
puts str     #changed!

new_str = add_some(str) 
str = 'take your time!'
puts new_str #previous line did nothing about new_str

str = 'baby'
new_str = str.sub(/y$/,'ies')
puts str+" "+new_str

end_in_o__add_s = ['dynamo', 'kimono', 'piano', 'kilo', 'photo', 'soprano'] 
sample.each do |word| 
    if end_in_o__add_s.include?(word)
        result = true.to_s
        puts word+":\t"+result
    end
        
end

sample.each do |word|
    puts word+": "+word.plural
end

#back-quote = command
puts "#####"+`ls`
__END__
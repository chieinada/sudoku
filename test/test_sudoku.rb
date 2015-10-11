require 'sudoku'
#Cell
puts "##### class Cell ######"
cell = Cell.new
p cell.inspect  #"(-f)"
p cell.to_s     #"-"
puts "....clear(),clear!()........."
cell.set!(1,false)
p cell.clear        #"(-f)"
cell.set!(2,false)
p cell.clear!       #"(-f)"
cell.set!(3,true)
p cell.clear        #nil
cell.set!(4,true)
p cell.clear!       #"(-f)"
puts "....given_to_s()............"
cell.set!(5,true)    
p cell.given_to_s   #"t"
cell.set!(6,false)   
p cell.given_to_s   #"f"
puts "....set()........."
cell.clear!
puts "#num,given = Fixnum,false"
p cell.set(1,false) #"(1f)"
p cell.set(9,false) #"(9f)"
p cell.set(10,false) #ArgumentError
p cell.set(222,false) #nil
p cell.set(0,false) #nil
p cell.set(-1,false) #nil
p cell.set(1.1,false) #nil
puts "#num,given = Fixnum,true"
p cell.set(1,true) #"(1t)"
p cell.set(9,true) #"(9t)"
p cell.set(10,true) #nil
p cell.set(222,true) #nil
p cell.set(0,true) #nil
p cell.set(-1,true) #nil
p cell.set(1.1,true) #nil
puts "#num,given = String,false"
p cell.set('1',false) #"(1f)"
p cell.set('2',false) #"(2f)"
p cell.set('3',false) #"(3f)"
p cell.set('4',false) #"(4f)"
p cell.set('5',false) #"(5f)"
p cell.set('6',false) #"(6f)"
p cell.set('7',false) #"(7f)"
p cell.set('8',false) #"(8f)"
p cell.set('9',false) #"(9f)"
p cell.set('10',false) #nil
p cell.set('222',false) #nil
p cell.set('0',false) #nil
p cell.set('-1',false) #nil
p cell.set('1.1',false) #nil
p cell.set("a",false) #nil
p cell.set("long string",false) #nil
puts "#num,given = String,true"
p cell.set('1',true) #"(1t)"
p cell.set('2',true) #"(2t)"
p cell.set('3',true) #"(3t)"
p cell.set('4',true) #"(4t)"
p cell.set('5',true) #"(5t)"
p cell.set('6',true) #"(6t)"
p cell.set('7',true) #"(7t)"
p cell.set('8',true) #"(8t)"
p cell.set('9',true) #"(9t)"
p cell.set('10',true) #nil
p cell.set('222',true) #nil
p cell.set('0',true) #nil
p cell.set('-1',true) #nil
p cell.set('1.1',true) #nil
p cell.set("a",true) #nil
p cell.set("long string",true) #nil
puts "#num,given = Object,false"
p cell.set(cell,false) #nil
p cell.set(true,false) #nil
puts "#num,given = Object,true"
p cell.set(cell,true) #nil
p cell.set(true,true) #nil


__END__
class TestCell #< Test::Unit::TestCase
    def test_initialize 
        c = Cell.new
        p cell
    end
end

cell=TestCell.new
cell.test_initialize
    
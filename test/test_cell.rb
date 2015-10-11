require 'test/unit'
require 'sudoku'
class TestCell < Test::Unit::TestCase
    def test_initialize
        assert_instance_of(Cell, Cell.new)
    end
    def test_given?
        cell = Cell.new
        assert_instance_of(FalseClass, cell.given?)   #false
        cell.set!(5,true)
        assert_instance_of(TrueClass, cell.given?)   #false
    end
    def test_given_to_s
        cell = Cell.new
        cell.set!(6,false)
        assert_equal("f",cell.given_to_s)
        cell.set!(9,true)
        assert_equal("t",cell.given_to_s)
    end
    def test_inspect
        cell = Cell.new
        assert_equal("(-f)", cell.inspect)
        #(1..9), false
        cell.set!(1,false)
        assert_equal("(1f)", cell.inspect)
        cell.set!(2,false)
        assert_equal("(2f)", cell.inspect)
        cell.set!(3,false)
        assert_equal("(3f)", cell.inspect)
        cell.set!(4,false)
        assert_equal("(4f)", cell.inspect)
        cell.set!(5,false)
        assert_equal("(5f)", cell.inspect)
        cell.set!(6,false)
        assert_equal("(6f)", cell.inspect)
        cell.set!(7,false)
        assert_equal("(7f)", cell.inspect)
        cell.set!(8,false)
        assert_equal("(8f)", cell.inspect)
        cell.set!(9,false)
        assert_equal("(9f)", cell.inspect)
        #(1..9,true)
        cell.set!(1,true)
        assert_equal("(1t)", cell.inspect)
        cell.set!(2,true)
        assert_equal("(2t)", cell.inspect)
        cell.set!(3,true)
        assert_equal("(3t)", cell.inspect)
        cell.set!(4,true)
        assert_equal("(4t)", cell.inspect)
        cell.set!(5,true)
        assert_equal("(5t)", cell.inspect)
        cell.set!(6,true)
        assert_equal("(6t)", cell.inspect)
        cell.set!(7,true)
        assert_equal("(7t)", cell.inspect)
        cell.set!(8,true)
        assert_equal("(8t)", cell.inspect)
        cell.set!(9,true)
        assert_equal("(9t)", cell.inspect)
        #clear!
        cell.clear!
        assert_equal("(-f)",cell.inspect)
    end
    def test_to_s
        cell = Cell.new
        assert_equal("-", cell.to_s)
        #(1..9), false
        cell.set!(1,false)
        assert_equal("1", cell.to_s)
        cell.set!(2,false)
        assert_equal("2", cell.to_s)
        cell.set!(3,false)
        assert_equal("3", cell.to_s)
        cell.set!(4,false)
        assert_equal("4", cell.to_s)
        cell.set!(5,false)
        assert_equal("5", cell.to_s)
        cell.set!(6,false)
        assert_equal("6", cell.to_s)
        cell.set!(7,false)
        assert_equal("7", cell.to_s)
        cell.set!(8,false)
        assert_equal("8", cell.to_s)
        cell.set!(9,false)
        assert_equal("9", cell.to_s)
        #(1..9,true)
        cell.set!(1,true)
        assert_equal("1", cell.to_s)
        cell.set!(2,true)
        assert_equal("2", cell.to_s)
        cell.set!(3,true)
        assert_equal("3", cell.to_s)
        cell.set!(4,true)
        assert_equal("4", cell.to_s)
        cell.set!(5,true)
        assert_equal("5", cell.to_s)
        cell.set!(6,true)
        assert_equal("6", cell.to_s)
        cell.set!(7,true)
        assert_equal("7", cell.to_s)
        cell.set!(8,true)
        assert_equal("8", cell.to_s)
        cell.set!(9,true)
        assert_equal("9", cell.to_s)
        #clear!
        cell.clear!
        assert_equal("-",cell.to_s)
    end
    def test_clear
        cell = Cell.new
        #(1..9), false
        cell.set!(1,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        cell.set!(2,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        cell.set!(3,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        cell.set!(4,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        cell.set!(5,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        cell.set!(6,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        cell.set!(7,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        cell.set!(8,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        cell.set!(9,false)
        assert_same(cell, cell.clear)
        assert_equal("(-f)", cell.inspect)
        #(1..9,true)
        cell.set!(1,true)
        assert_nil(cell.clear) #can't clear
        assert_equal("(1t)", cell.inspect)
        cell.set!(2,true)
        assert_nil(cell.clear)
        assert_equal("(2t)", cell.inspect)
        cell.set!(3,true)
        assert_nil(cell.clear)
        assert_equal("(3t)", cell.inspect)
        cell.set!(4,true)
        assert_nil(cell.clear)
        assert_equal("(4t)", cell.inspect)
        cell.set!(5,true)
        assert_nil(cell.clear)
        assert_equal("(5t)", cell.inspect)
        cell.set!(6,true)
        assert_nil(cell.clear)
        assert_equal("(6t)", cell.inspect)
        cell.set!(7,true)
        assert_nil(cell.clear)
        assert_equal("(7t)", cell.inspect)
        cell.set!(8,true)
        assert_nil(cell.clear)
        assert_equal("(8t)", cell.inspect)
        cell.set!(9,true)
        assert_nil(cell.clear)
        assert_equal("(9t)", cell.inspect)
    end
    def test_clear!
        cell = Cell.new
        #(1..9), false
        cell.set!(1,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(2,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(3,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(4,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(5,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(6,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(7,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(8,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(9,false)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        #(1..9,true)
        cell.set!(1,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(2,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(3,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(4,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(5,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(6,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(7,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(8,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
        cell.set!(9,true)
        assert_same(cell, cell.clear!)
        assert_equal("(-f)", cell.inspect)
    end
    def test_set
        cell = Cell.new
        #num,given = Fixnum,false
        assert_same(cell, cell.set(1,false))
        assert_equal("(1f)", cell.inspect)
        assert_same(cell, cell.set(9,false)) 
        assert_equal("(9f)", cell.inspect)
        assert_raise(ArgumentError){cell.set(10,false)}
        assert_raise(ArgumentError){cell.set(222,false)}
        assert_raise(ArgumentError){cell.set(0,false)}
        assert_raise(ArgumentError){cell.set(-1,false)}
        #num,given = Fixnum,true
        assert_same(cell, cell.set(1,true)) #ok
        assert_equal("(1t)", cell.inspect)
        assert_nil(cell.set(9,true)) #can't set over given cell
        assert_equal("(1t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set(9,true)) #ok
        assert_equal("(9t)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set(10,true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set(222,true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set(0,true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set(-1,true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        
        #num,given = Float, false 
        assert_same(cell, cell.set(1.1,false)) #works as 1
        assert_equal("(1f)", cell.inspect)
        #num,given = Float, false 
        assert_same(cell, cell.set(1.1,true)) #works as 1
        assert_equal("(1t)", cell.inspect)
        cell.clear!
        
        #num,given = String,false"
        assert_same(cell, cell.set('1',false)) 
        assert_equal("(1f)", cell.inspect)
        assert_same(cell, cell.set('2',false)) 
        assert_equal("(2f)", cell.inspect)
        assert_same(cell, cell.set('3',false)) 
        assert_equal("(3f)", cell.inspect)
        assert_same(cell, cell.set('4',false)) 
        assert_equal("(4f)", cell.inspect)
        assert_same(cell, cell.set('5',false)) 
        assert_equal("(5f)", cell.inspect)
        assert_same(cell, cell.set('6',false)) 
        assert_equal("(6f)", cell.inspect)
        assert_same(cell, cell.set('7',false)) 
        assert_equal("(7f)", cell.inspect)
        assert_same(cell, cell.set('8',false)) 
        assert_equal("(8f)", cell.inspect)
        assert_same(cell, cell.set('9',false)) 
        assert_equal("(9f)", cell.inspect)
        assert_raise(ArgumentError){cell.set('10',false)}
        assert_equal("(9f)", cell.inspect)
        assert_raise(ArgumentError){cell.set('222',false)}
        assert_equal("(9f)", cell.inspect)
        assert_raise(ArgumentError){cell.set('0',false)}
        assert_equal("(9f)", cell.inspect)
        assert_raise(ArgumentError){cell.set('-1',false)}
        assert_equal("(9f)", cell.inspect)
        assert_same(cell, cell.set('1.1',false)) #works fine as 1!
        assert_equal("(1f)", cell.inspect)
        assert_raise(ArgumentError){cell.set("a",false)}
        assert_equal("(1f)", cell.inspect)
        assert_raise(ArgumentError){cell.set("long string",false)}
        assert_equal("(1f)", cell.inspect)
        #num,given = String,true"
        assert_same(cell, cell.set('1',true) )
        assert_equal("(1t)", cell.inspect)
        assert_nil(cell.set('2',true) )#can't set over given cell
        assert_equal("(1t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('3',true) )
        assert_equal("(3t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('3',true) )
        assert_equal("(3t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('4',true) )
        assert_equal("(4t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('5',true) )
        assert_equal("(5t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('6',true) )
        assert_equal("(6t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('7',true) )
        assert_equal("(7t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('8',true) )
        assert_equal("(8t)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('9',true) )
        assert_equal("(9t)", cell.inspect)
        cell.clear!
        
        assert_raise(ArgumentError){cell.set('10',true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set('222',true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set('0',true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set('-1',true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_same(cell, cell.set('1.1',true)) #works fine as 1
        assert_equal("(1t)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set("a",true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_raise(ArgumentError){cell.set("long string",true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        
        #num,given = Object,false
        assert_raise(NoMethodError){cell.set(cell,false)} #no method: to_i
        assert_equal("(-f)", cell.inspect)
        assert_raise(NoMethodError){cell.set(true,false)} #no method: to_i
        assert_equal("(-f)", cell.inspect)
        #num,given = Object,true"
        assert_raise(NoMethodError){cell.set(cell,true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
        assert_raise(NoMethodError){cell.set(true,true)}
        assert_equal("(-f)", cell.inspect)
        cell.clear!
    end
    def test_set!
        cell = Cell.new
        assert_same(cell, cell.set!(1, true))
        assert_equal("(1t)", cell.inspect)
        assert_same(cell, cell.set!(3, false)) #works fine
        assert_equal("(3f)", cell.inspect)
        assert_same(cell, cell.set!(9,true))
        assert_equal("(9t)", cell.inspect)
        assert_raise(ArgumentError){cell.set!(10, true)}
        assert_raise(ArgumentError){cell.set!(-1,true)}
        assert_raise(NoMethodError){cell.set(true,true)}
    end
end
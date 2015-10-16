###Sudoku rev1a:  Mar 19 2007
#Board
#  added: empty_cells 
#NineNum
#  added: i_have
#  -----: i_dont_have
#  added: include?(cell) 
#Cell
#  added: @x, @y
#  modified: inspect
#  added: can_be
class Board < Object
  WIDTH = 9
  XY_RANGE = (0..WIDTH-1)
  NUM_RANGE = (1..WIDTH)    
  def initialize
      #create empty board
    @comments = ""
    @cells = Array.new(WIDTH**2) {|idx| Cell.new(idx%WIDTH, idx/WIDTH) }
    @rows =    Array.new(WIDTH) {|idx| NineNum.new }
    @columns = Array.new(WIDTH) {|idx| NineNum.new }
    @boxes =   Array.new(WIDTH) {|idx| NineNum.new }
    #link rows and cells each other
    WIDTH.times do |y|
      row = @rows[y]
      WIDTH.times do |idx| 
        cell = @cells[idx + y * WIDTH]
        if not(row << cell)
          raise("same cell inserted @rows[#{y}], idx=#{idx}")
        end
        cell.set_row(row)
      end
    end
        
    #link columns and cells each other
    WIDTH.times do |x|
      column = @columns[x]
      WIDTH.times do |idx|
        cell = @cells[x + idx * WIDTH]
        if not(column << cell)
          raise("same cell inserted @columns[#{x}], idx=#{idx}")
        end
        cell.set_column(column)#
      end
    end

    #link boxes and cells each other
    WIDTH.times do |box_no|
      box = @boxes[box_no]
      box_x = box_no / 3
      box_y = box_no % 3
      3.times do |y|
        3.times do |x|
          cell = @cells[(x+box_x*3) + (y+box_y*3) * 9]
          if not(box << cell)
            raise("same cell inserted @boxes[#{box_no}], (x,y)=(#{x},#{y})")
          end
          cell.set_box(box)
        end
      end
    end
  end
  attr_reader :comments
  attr_reader :cells, :boxes, :rows, :columns
  def load_problem(problem)
    #problem: Problem object containing 
    #       an Array of 81 single-character strings /^[1-9]$/ or '-'
    raise("problem has wrong number of cells: #{problem.length} cells") if problem.length != WIDTH**2
    
    @comments = problem.comments    
    problem.each_index do |idx|
        num = problem[idx].to_i
        if num != 0
            x, y = idx % WIDTH, idx / WIDTH
            given = true
            cell = cell(x, y).set(num, given)
            if !cell
                self.inspect
                raise("can't set cell: (x,y,num,given)=(#{x},#{y},#{num},#{given}" ) 
            end
        end
    end
    if !$SILENT || $RESULT
        puts "\n"+comments
        puts to_s
        puts "#{Board::WIDTH**2-empty_cells.length} cells given"+"\n"
    end
    return self
  end
  def to_problem
    problem = Array.new
    @cells.each {|cell| problem << (cell.num ? cell.num : '-') }
    return Problem.new(problem, @comments)
  end
  def clear
    @cells.each {|cell| cell.clear}
  end
  def clear!
    @cells.each {|cell| cell.clear!}
end
  def inspect
    #@cells.collect {|cell| cell.inspect}.to_s
    str = ""
    WIDTH.times do |y| 
      WIDTH.times {|x| str += cell(x,y).inspect + " "}
      str += "\n"
    end
    return str
  end
  def to_s
    str = ""
    WIDTH.times do |y| 
      WIDTH.times {|x| str+= cell(x,y).to_s+" " }
      str += "\n"
    end
    return str
  end
  def cell(x, y)
    #x, y: Fixnum, (0 <= x, y < WIDTH)
    #return: Cell or nil
    x_i, y_i = x.to_i, y.to_i
    raise(ArgumentError,"Out of range x=#{x}") if not XY_RANGE.include? x_i
    raise(ArgumentError,"Out of range y=#{y}") if not XY_RANGE.include? y_i
        
    return @cells[x_i + y_i * WIDTH]
  end
  def nine_nums
    return @rows+@columns+@boxes
  end
  def empty_cells
    @cells.select{|cell| cell.num == nil}
  end
end
###################################################################################
###################################################################################

class NineNum
  def initialize()
    @cells = [] #max length == Board::WIDTH
  end
  attr_reader :cells
  def to_s
    return "@cells=nil" if @cells == nil
    str = ""
    @cells.each { |cell| str+=cell.to_s }
    return str
  end
  def -(cells)
    #return: Array of Cell
    @cells - cells
  end
  def to_ary
    #return: Array of Cell
    @cells
  end
  #def select(&proc)
  #    @cells.select(&proc)
  #end
  def empty_cells
    #return: Array of Cell
    @cells.select{|cell| cell.empty?}
  end
  def cells_can_be(num)
    #return: Array of Cell (empty cells that can be num)
    return [] if have?(num)
    @cells.select {|cell| cell.empty? && cell.can_be.include?(num)}
  end
  def i_have
    #return: Array of nums
    have_it = Hash.new(false)
    @cells.each do |cell|
      have_it[cell.num] = true if cell.num
    end
    return have_it.keys
  end
  def include?(cell)
    #return: true/false
    @cells.include?(cell)
  end
  def have?(num)
      #true/false
    return false if !num
    num_i = num.to_i
    raise(ArgumentError, "Out of range: num(#{num})") if not Board::NUM_RANGE.include? num_i
    
    return @cells.any? {|cell| cell.num == num_i}
  end
  def <<(new_cell)        
    #return: nil/self
    ### need type check for cell?
    if @cells.length >= Board::WIDTH
      raise("too many cells pushed (@cells.length=#@cells.length)") 
    end
    @cells.each {|cell| raise("same cell pushed") if cell.equal? new_cell}
    
    new_num = new_cell.num  
    if (have?(new_num))
      return nil
    else #I don't have it!
      @cells << new_cell
      return self
    end
  end
end
###################################################################################
###################################################################################

class Cell
  def initialize(x,y)
    @x,@y = x,y
    @num=nil         #nil or 1-Board::WIDTH(=9)(Fixnum)
    @given=false    #true/false
    @row = @column = @box = nil
    #set_row(),set_column(),set_box() must be called before use
  end
  attr_reader :num, :row, :column, :box, :x, :y
  def set_row(row)
    raise("set_row called twice for same cell") if @row != nil
    @row = row
  end
  def set_column(column)
    raise("set_column called twice for same cell") if @column != nil
    @column = column
  end
  def set_box(box)
    raise("set_box called twice for same cell") if @box != nil
    @box = box
  end
  def nine_nums
    return [@row, @column, @box]
  end
  def empty?
    return @num == nil
  end
  def given?
    @given
  end
  def given_to_s
    @given ? 't' : 'f'
  end
  def inspect
    "(#@x,#@y,#{to_s}#{given_to_s})"
  end
  def to_s
    return '-' if @num == nil
    return @num.to_s
  end
  def xy_to_s
    return "#@x,#@y"
  end
  def <=>(other)
      (@y * 10 + @x) <=> (other.y * 10 + other.x)
  end
  def clear
    #keep given cell
    return nil if @given
    @num = nil
    return self
  end
  def clear!
    #clear given cell too
    @num, @given = nil, false
    return self
  end
  def can_be
    #return: sorted Array of nums
    #Must be call for empty cells.
    #When @num has value, return value is Array of nums that fit in this cell.
    #When cell is given cell, only [@num] is returned
    
    return [@num] if given?
    return Board::NUM_RANGE.to_a - @row.i_have - @column.i_have - @box.i_have
  end
  def set(num,given=false)
    #num: Fixnum (1 <= num <= Board::WIDTH)  (can't be nil) 
    #given: true/false
    #return: self/nil

    num_i = num.to_i
    raise(ArgumentError, "Invalid num: (num=#{num.inspect})") if not(Board::NUM_RANGE.include? num_i)
    raise(RuntimeError, "Not linked with NineNum") if !@row || !@column || !@box
    
    #can't modify given cell
    return nil if @given 
    if @num == num_i
      @given = given
      return self
    end
    
    if (@row.have?(num_i) || @column.have?(num_i) || @box.have?(num_i))
      return nil
    else
      @num, @given = num, given
      
      return self
    end
  end
=begin
  ###need these?##
  def self.inspect_cells(cells)
    str = ""
    cells.each {|cell| str += cell.inspect}
    return str
  end
  def self.cells_to_s(cells)
    str = ""
    cells.each {|cell| str += cell.to_s}
    return str
  end
  #####
=end
end
__END__
fname = "problem1.txt"
problem = Problem.new(Problem.read(fname), "##{fname}\n")
bd = Board.new
bd.load_problem(problem)
puts bd.to_s+"\n"
p bd.to_problem

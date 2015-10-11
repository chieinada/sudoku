###Sudoku rev1a:  Mar 19 2007
class Board < Object
  Width = 9
  XYRange = (0..Width-1)
  NumRange = (1..Width)    
  def initialize
    @cells = Array.new(Width**2) {|idx| Cell.new }
    @rows =    Array.new(Width) {|idx| NineNum.new }
    @columns = Array.new(Width) {|idx| NineNum.new }
    @boxes =   Array.new(Width) {|idx| NineNum.new }
    #link rows and cells each other
    Width.times do |y|
      row = @rows[y]
      Width.times do |idx| 
        cell = @cells[idx + y * Width]
        if not(row << cell)
          raise("same cell inserted @rows[#{y}], idx=#{idx}")
        end
        cell.set_row(row)
      end
    end
        
    #link columns and cells each other
    Width.times do |x|
      column = @columns[x]
      Width.times do |idx|
        cell = @cells[x + idx * Width]
        if not(column << cell)
          raise("same cell inserted @columns[#{x}], idx=#{idx}")
        end
        cell.set_column(column)#
      end
    end

    #link boxes and cells each other
    Width.times do |box_no|
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
  def load_problem(problem)
    #problem: Problem object containing 
    #       an Array of 81 single-character strings /^[1-9]$/ or '-'
    raise("problem has wrong number of cells: #{problem.length} cells") if problem.length != Width**2
        
    problem.each_index do |idx|
        num = problem[idx].to_i
        if num != 0
            x, y = idx % Width, idx / Width
            given = true
            cell = cell(x, y).set(num, given)
            if !cell
                self.inspect
                raise("can't set cell: (x,y,num,given)=(#{x},#{y},#{num},#{given}" ) 
            end
        end
    end
    return 
  end
  def to_problem
    problem = Array.new
    @cells.each do|cell|
      if cell.num
        problem << cell.num
      else
        problem << '-'
      end
    end
    return Problem.new(problem)
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
    Width.times do |y| 
      Width.times {|x| str += cell(x,y).inspect + " "}
      str += "\n"
    end
    return str
  end
  def to_s
    str = ""
    Width.times do |y| 
      Width.times {|x| str+= cell(x,y).to_s+" " }
      str += "\n"
    end
    return str
  end

  ####### methods processing cell ################
  def cell(x, y)
    #x, y: Fixnum, (0 <= x, y < Width)
    #return: Cell or nil
    x_i, y_i = x.to_i, y.to_i
    raise(ArgumentError,"Out of range x=#{x}") if not XYRange.include? x_i
    raise(ArgumentError,"Out of range y=#{y}") if not XYRange.include? y_i
        
    return @cells[x_i + y_i * Width]
  end
end
###################################################################################
###################################################################################

class NineNum
  def initialize()
    @cells = [] #max length == Board::Width
  end       
  def to_s
    return "@cells=nil" if @cells == nil
    str = ""
    @cells.each { |cell| str+=cell.to_s }
    return str
  end
  def what_I_dont_have
    have_it = Hash.new(Board::Width+1, nil)
    @cells.each do |cell|
      have_it[cell.num] = true if cell.num
    end
    
  end
  def have_it?(num)
    return false if num == nil
    num_i = num.to_i
    raise(ArgumentError, "Out of range: num(#{num})") if not Board::NumRange.include? num_i
    
    have_it = Array.new(Board::Width+1, nil)
    @cells.each do|cell|
      have_it[cell.num] = true if cell.num
    end
    return have_it[num_i]
  end
  def <<(new_cell)        
    #return: nil/self
    ### need type check for cell?
    if @cells.length >= Board::Width
      raise("too many cells pushed (@cells.length=#{@cells.length})") 
    end
    @cells.each {|cell| raise("same cell pushed") if cell.equal? new_cell}
    
    new_num = new_cell.num  
    if (have_it?(new_num))
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
  def initialize
    @num=nil         #nil or 1-Board::Width(=9)(Fixnum)
    @given=false    #true/false
    @row = @column = @box = nil
    #set_row(),set_column(),set_box() must be called before use
  end
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
  def given?
    @given
  end
  def given_to_s
    @given ? 't' : 'f'
  end
  def inspect
    "#{to_s}#{given_to_s}"
  end
  def to_s
    return '-' if @num == nil
    return @num.to_s
  end
  def num
    return @num
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
  def set(num,given=false)
    #num: Fixnum (1 <= num <= Board::Width)  (can't be nil) 
    #given: true/false
    #return: self/nil

    num_i = num.to_i
    raise(ArgumentError, "Invalid num: (num=#{num.inspect})") if not(Board::NumRange.include? num_i)
    raise(RuntimeError, "Not linked with NineNum") if !@row || !@column || !@box
    
    #can't modify given cell
    return nil if @given 
    if @num == num_i
      @given = given
      return self
    end
    
    if (@row.have_it?(num_i) || @column.have_it?(num_i) || @box.have_it?(num_i))
      return nil
    else
      @num, @given = num, given
      
      return self
    end
  end
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
end
__END__
fname = "problem1.txt"
problem = Problem.new(Problem.read(fname), "##{fname}\n")
bd = Board.new
bd.load_problem(problem)
puts bd.to_s+"\n"
p bd.to_problem
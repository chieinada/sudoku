class Arr 
    def initialize(arr)
        @arr=arr
    end
    def each(&proc)
        (0..@arr.length-1).each {|idx| proc.call(@arr[idx])}
    end
end

a=Arr.new([1,2,3])
p a
a.each {|n| p n}
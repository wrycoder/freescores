module WorksHelper
  def oxford_list(instruments, options = {})
    options[:separator] ||= ','
    options[:oxford_comma] ||= true
    result = ''
    instruments.each_with_index do |inst, x|
      if instruments.length > 1 && x == (instruments.length - 1)
        if instruments.length != 2 && options[:oxford_comma] == true
          result << ', and ' + inst[1]
        else
          result << ' and ' + inst[1]
        end
      else
        if x > 0
          result << ', '
        end
        result << inst[1]
      end
    end
    result
  end
end

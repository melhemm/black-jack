module Bank
  attr_accessor :bank

  def increase_value(sum)
    @bank += sum
  end

  def reduce_value(sum)
    @bank -= sum
  end
end

class Array
  def pinject(*args, &block)
    block = args[0].to_proc if args[0].is_a? Symbol
    accumulator = assign_accumulator(*args)
    call_block_on_accumulator_and_value(accumulator, &block)
  end

  def pinject_recursive(*args, &block)
    block = args[0].to_proc if args[0].is_a? Symbol
    accumulator = assign_accumulator(*args)
    forwardvalue = 0
    run_it_recursively(accumulator, forwardvalue, *args, &block)
  end

  private

  def assign_accumulator(*args)
    if args.empty? || args[0].class == Symbol
      accumulator = self.shift
    else
      accumulator = args[0]
    end
  end

  def call_block_on_accumulator_and_value(accumulator, &block)
    self.each { |value| accumulator = yield(accumulator, value) }
    accumulator
  end

  def run_it_recursively(accumulator, forwardvalue, *args, &block)
    return accumulator if self.empty?
    accumulator = block.call(accumulator, self[forwardvalue])
    self.drop(1).pinject_recursive(accumulator, args, &block)
  end
end

require './lib/traceabool.rb'

class Sample
  extend Traceabool

  def true?
    true
  end

  def false?
    false
  end

  def_with_trace :true_and_false?, [:true?, :false?], :all?
  def_with_trace :true_or_false?, [:true?, :false?], :any?
  def_with_trace :true_nor_false?, [:true?, :false?], :none?
  # def_with_trace :true_and_false?, [:true?, :false?, :dddd?], :all?, pppp: 'xxxx', qqqq: 'yyyy'
  def_with_trace :m_not_true_nor_false?, [{
    method: :true?,
    not: :not,
    description: "",
    args: [],
    when_rescue: -> (e) {
    }
  }, {
    method: :false?,
  }], :none?, {
  }
  def_with_trace :m_not_true_nor_false__and__true?, [:m_not_true_nor_false?, :true?], :all?

  # debug
  def method_missing(name, args=nil)
    puts "method_missing: #{name}"
  end
end

[
  :true_and_false?,
  :true_or_false?,
  :true_nor_false?,
  :m_not_true_nor_false?,
  :m_not_true_nor_false__and__true?,
].each do |name|
  puts name.to_s
  puts Sample.new.public_send(name)
  puts Sample.new.public_send("why_#{name}".to_sym)
end

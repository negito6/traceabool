example = {
  name: "aaaa?",
  method: :all?,
  result: true,
  trace: [
    "self.bbbb?" => {
    },
    "self.cccc?" => true
  ],
  text: "aaaa returns true <= [true <= self.bbbb?, true <= self.cccc?, ].all?",
  options: {
    reach_to_last: true
  }
} 

require './lib/traceabool.rb'

class Sample
  extend Traceabool

  def dddd?
    false
  end

  def ffff?
    false
  end

  def eeee?
    true
  end

  def iiii?
    true
  end

  def self.hhhh
    Object.new
  end

  def_with_trace :aaaa?, [:bbbb?, :cccc?, :dddd?], :all?, pppp: 'xxxx', qqqq: 'yyyy'
  def_with_trace :bbbb?, [{
    # recever: self.hhhh,
    method: :iiii?,
    not: :not,
    description: "",
    args: [],
    when_rescue: -> (e) {
    }
  }, {
    method: :iiii?,
  }], :none?, {
  }
  def_with_trace :cccc?, [:eeee?, :ffff?, :iiii?], :any?, {}
  def_with_trace :aany?, [:eeee?, :ffff?, :iiii?], :any?, {}
  def_with_trace :anone?, [:eeee?, :ffff?, :iiii?], :none?, {}
  def_with_trace :aall?, [:eeee?, :ffff?, :iiii?], :all?, {}

  def yyyy
  end

  def method_missing(name, args=nil)
    puts "method_missing: #{name}"
  end
end
puts Sample.new.bbbb?
puts Sample.new.why_bbbb?
puts Sample.new.aaaa?
puts Sample.new.why_aaaa?
puts Sample.new.cccc?
puts Sample.new.why_cccc?
# puts Sample.new.why_aall?

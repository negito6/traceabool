# require "traceabool/version"

module Traceabool
  def def_with_trace(method_name_base, conditions, enumerable_method, option={})
    conditions.each do |condition|
      if condition.class == Hash
      end
    end
    target = MethodDefinition.new(enumerable_method, method_name_base, conditions, option)

    # boolean method
    define_method(target.method_name_for_execute) do
      conditions.map do |condition|
        condition.class == Symbol ? condition : condition[:method]
      end.send(enumerable_method) do |name|
        self.send(name)
      end
    end

    # method with trace
    define_method(target.method_name_for_execute_with_trace) do # |args|
      results = conditions.inject({})  do |h, condition|
        method_name = condition.class == Symbol ? condition : condition[:method]
        why_method_name = "why_#{method_name}".to_sym

        if self.respond_to?(why_method_name)
          # case of Traceabool method
          h[method_name] = self.send(why_method_name)
        else
          h[method_name] = self.send(method_name)
        end
        h
      end

      Result.new(target, results).to_h
    end
  end

  class MethodDefinition
    def initialize(method, method_name_base, conditions, options)
      @method = method
      @conditions = conditions
      @options = options
      @method_name_base = method_name_base
    end

    def execute_with_trace(args)
      execute
    end

    def method_name_for_execute
      # ???
      "#{method_name_base}".to_s.sub(/\?\?$/, '?')
    end

    def method_name_for_execute_with_trace
      "why_#{method_name_for_execute}"
    end

    def execute
      conditions.map do |condition|
        condition.class == self.class ? condition.execute : self.send(condition[:method])
      end.send(enumerable_method)
    end

    attr_reader :options, :method, :conditions, :method_name_base
  end


  class Result
    def initialize(method_definition, results)
      @method = method_definition
      @trace = results
      @result = results.values.send(@method.method)
    end

    def name
      @method.try(:name)
    end

    def method
      @method.method
    end

    def trace
      @trace
    end

    def options
      @method.options
    end

    def conditions
      @method.conditions
    end

    def result
      @result
    end

    def description
      @method.try(:description)
    end

    def text
      conditions.map {|c| "#{result} <= [#{conditions.map(&:text).join(", ")}].#{method.to_s}" }
    end

    def to_h
      {
        # name: name,
        method: method,
        result: result,
        # description: description,
        options: options,
        trace: trace.inject({}) {|h, (key, value)| h[key] = value.class == self.class ? value.to_h : value; h }
        # text: "#{name} returns #{text}",
      }
    end
  end
end

class LengthCalculator

  SYMBOL = [
      ['(', ')'],
      ['+', '-'],
      ['*', '/']
  ]

  REG_VARIABLE = /\d+(?:\.\d+)?/
  REG_OPERATOR = /[\+\-\*\/\|\&]/
  REG_PARENTHESIS = /[\(\)]/
  REG_SPACE = /\s+/


  def unit_translator (formula)
    formula_split = formula.split(/[+\-\*\/]/)
    unit_result = formula_split.collect {|x| translator(x)}
    calculators = formula.split(//).select{|x| x == '+' || x == '-' || x == '*' || x == '/'}
    formula_meter = calculate unit_result, calculators
    postfix = parse_to_postfix(formula_meter)

    (exec_postfix postfix).round(6)
  end

  private
  def translator (unit)
    number_unit = unit.scan(/\d+|[a-zA-Z]+/)
    unit_downcase = number_unit[1]
    translator = number_unit[0].to_f
    if unit_downcase == 'm'
      translator
    elsif unit_downcase == 'dm'
      translator = translator / 10
    elsif unit_downcase == 'cm'
      translator = translator / 100
    elsif unit_downcase == 'mm'
      translator = translator / 1000
    end

    translator
  end

  def calculate (number, calculators)
    formula = ''
    index = 0
    while index < calculators.size do
      formula += number[index].to_s + calculators[index]
      index += 1
    end
    formula += number.last.to_s
    formula
  end

  def parse_to_postfix(exp)
    postfix_exp, stack = [], []
    until exp.nil? or exp.size == 0
      case exp
        when /^(#{REG_VARIABLE})/
          token = $1
          postfix_exp << token
        when /^(#{REG_OPERATOR})/
          token = $1
          if stack.empty?
            stack << token
          else
            while stack.size > 0 && precedence(token) <= precedence(stack.last)
              postfix_exp << stack.pop
            end
            stack << token
          end
        when /^(#{REG_PARENTHESIS})/
          token = $1
          case token
            when '('
              stack << token
            when ')'
              postfix_exp << stack.pop while !stack.empty? && stack.last != '('
              p "mismatched '#{token}'" if stack.last != '('
              stack.pop
            else
              raise "parenthesis '#{token}' wrong"
          end
        when /^(#{REG_SPACE})/
          token = $1
        else
          p "unknown expression is '#{exp}'"
      end
      exp = exp[token.size..-1]
    end

    until stack.empty?
      postfix_exp << stack.pop
    end
    postfix_exp
  end

  def exec_postfix(postfix_exp)
    stack = []
    postfix_exp.each do |token|
      case token
        when REG_VARIABLE
          stack << token.to_f
        when REG_OPERATOR
          d2, d1 = stack.pop, stack.pop
          stack << exec_exp(d1, token, d2)
      end
    end
    stack.first
  end

  def precedence(op)
    re = SYMBOL.index { |symbol| symbol.include?(op) }
    re
  end

  def exec_exp(d1, op, d2)
    case op
      when REG_OPERATOR
        d1.send(op, d2)
      else
        p "operator '#{op}' wrong"
    end
  end

end
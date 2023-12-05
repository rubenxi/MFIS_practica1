module EXAMPLE
  imports INT
  syntax Exp ::= Int | Exp "+" Exp
  rule 1 + 2 => 3
endmodule

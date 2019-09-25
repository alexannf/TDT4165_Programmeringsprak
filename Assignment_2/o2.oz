functor
import
    System
    Application(exit:Exit)
define

    \insert List.oz

    % 2 a)
    fun {Lex Stringput}
        {String.tokens Stringput & }
    end

    {System.show {Lex "1 2 + 3 *"}}

    % 2 b) 
    fun {Tokenize Lexemes}
        case Lexemes of Head|Tail then
            if Head == "+" then
                operator(type:plus)|{Tokenize Tail}
            elseif Head == "-" then
                operator(type:minus)|{Tokenize Tail}
            elseif Head == "/" then
                operator(type:divide)|{Tokenize Tail}
            elseif Head == "*" then
                operator(type:multiply)|{Tokenize Tail}
            % 2 d)
            elseif Head == "p" then
                command(print)|{Tokenize Tail}
            % 2 e)
            elseif Head == "d" then
                command(duplicatetop)|{Tokenize Tail}
            % 2 f)
            elseif Head == "i" then
                operator(type:flipsign)|{Tokenize Tail}
            % 2 g)
            elseif Head == "^" then
                operator(type:multiplicinverse)|{Tokenize Tail}
            else
                local A B in
                    /* 
                    String.isFloat will return true both for
                    Int and Float, but will not change the type
                    A is true if its possible to convert Head to float
                    */
                    {String.isFloat Head A}
                    if A then
                        % B is Head converted to float
                        {String.toFloat Head B}
                        number(B)|{Tokenize Tail}
                    else
                        raise 
                            illegalArgumentException(Head)
                        end
                    end
                end
            end
        else
            if Lexemes == nil then
                nil
            else
                raise 
                    illegalFormatException(Lexemes)
                end
            end
        end
    end

    {System.show {Tokenize {Lex "1 2 + 3 *"}}}

    % 2 c)
    fun {Reverse List}
        case List of Head|Tail then
            /*
            we make Head into a new list so we can use the "Append" function
            Head elements are recursively placed last relative to their 
            current List, resulting in a reversed list
             */
            {Append {Reverse Tail} Head|nil}
        else
            nil
        end
    end

    
    fun {Interpret2 Tokens Stack}
		case Tokens of Head|Tail then
			local Stack2 in
				case Head of operator(type:plus) then
					case Stack of number(Exp1)|number(Exp2)|Tail then
					    Stack2 = number(Exp1 + Exp2)|Tail
					end
                
				[] operator(type:minus) then
					case Stack of number(Exp1)|number(Exp2)|Tail then
					    Stack2 = number(Exp2 - Exp1)|Tail
					end
				[] operator(type:multiply) then
					case Stack of number(Exp1)|number(Exp2)|Tail then
					    Stack2 = number(Exp2 * Exp1)|Tail
					end
				[] operator(type:divide) then
					case Stack of number(Exp1)|number(Exp2)|Tail then
					    Stack2 = number(Exp2 / Exp1)|Tail
					end
                % 2 d)
                [] command(print) then
					{System.show {Reverse Stack}}
				    Stack2 = Stack
                % 2 e)
                [] command(duplicatetop) then
					case Stack of Head|Tail then
					    Stack2 = Head|Head|Tail
					else
					    Stack2 = Stack
					end
                % 2 f)
                [] operator(type:flipsign) then
                    local A in
                        case Stack of number(Exp1)|Tail then
                            % this function flips the sign of "Exp1"
                            A = {Number.'~' Exp1}
                            Stack2 = number(A)|Tail
                        end
                    end
                % 2 g)
                [] operator(type:multiplicinverse) then
					case Stack of number(Exp1)|Tail then
					    Stack2 = number(1.0/Exp1)|Tail
					end
				else
				    Stack2 = Head|Stack
				end
				{Interpret2 Tail Stack2}
			end
		else
			Stack
		end
	end


    fun {Interpret Tokens}
		{Reverse {Interpret2 Tokens nil}}
	end
    
    {System.show {Interpret {Tokenize{Lex "1 2 3 +"}}}}

    {System.show {Interpret {Tokenize{Lex "1 2 3 p +"}}}}

    {System.show {Interpret {Tokenize{Lex "1 2 3 + d"}}}}

    {System.show {Interpret {Tokenize{Lex "1 i 2 3 + d"}}}}

    {System.show {Interpret {Tokenize{Lex "1 2 3 + ^"}}}}

    % 3 a)
    % we convert all numbers to floats in our Tokenize function
    fun {InfixInternal Tokens ExpressionStack}
        if Tokens == nil then
            ExpressionStack
        else
            case Tokens of Head|Tail then
                local A in
                    {String.isFloat Head A}
                    if A then
                        {InfixInternal Tail A|ExpressionStack}
                    /*
                    Here we know it is some kind of operator
                    I assume we have atleast 2 elements in our Expression-
                    stack at this point
                    */
                    else
                        case ExpressionStack of Exp1|Exp2|ExpList then
                            case Head of operator(type:plus) then
                                {InfixInternal Tail "("#Exp1#" + "#Exp2#")"|ExpList}
                            [] operator(type:minus) then
                                {InfixInternal Tail "("#Exp1#" - "#Exp2#")"|ExpList}
                            [] operator(type:divide) then
                                {InfixInternal Tail  "("#Exp1#" / "#Exp2#")"|ExpList}
                            [] operator(type:multiply) then
                                {InfixInternal Tail "("#Exp1#" * "#Exp2#")"|ExpList}
                            end
                        end
                    end
                end
            end
        end
    end
    
    % 3 b)
    fun {Infix TokenList}
        {InfixInternal TokenList nil}
    end


    %{System.show {Infix {Tokenize {Lex "3.0 10.0 9.0 * - 0.3 +"}}}}

    /*

    HIGH LEVEL DESCRIPTION FOR TASK 3:
    Task: to give a high level description of how i convert postfix notation
        to infix notation.
    
    ASSUMPTION: the postfix input is valid and a String in the form explained in the {Lex} function

    My first step is to "Lexemize" the input string, which converts our String into a list of smaller strings 
    (usually 1 character, but it can have more) which represents a valid unit to calculate.

    In my second step i map any operator in our list to a planned record (operator(type:X)) and the rest,
    our numbers, to a number(N) record.

    In my third step i now have a list of records and my function {Infix} can be summed up with a few lines of
    Pseudocode:

    INFIX(ListofRecords)
        L = ListofRecords
        S = Stack
        FOR record IN L:
            IF record is type number():
                S.INSERT(record)
                L.REMOVE(record)
            ELSE:
                S1 = S.POP() 
                S2 = S.POP()
                STR = "(#S2 + record + #S1)" i.e. (3.0 - 1.0)
                L.REMOVE(record)
                S.INSERT(STR)
            END
        END
    END

    Note that S1 and S2 can be strings with brackets.


    Task 4:

    4 a)

    We have the following regular expressions describing our lexemes:

    number: "[0-9]+(\.[0-9]+)?"
	plus: "\+"
	minus: "-"
	multiply: "\*"
	divide: "/"
	print: "p"
	duplicate: "d"
	inverse: "i"


    4 b)

    Expr ::= Expr + Prod
	        | Expr - Prod
	        | Prod;
	Prod ::= Prod * number
	        | Prod / number
	        | number;  % Number that was defined as a lexeme
	
    we notice that all parse trees are left-recursive

    ie. 6-5-4 parses to ((6-5)-4), still semantically correct.

    This makes the grammar unambiguous
    
    4 c)
	A context-sensitive grammar has a "non-terminal" surrounded by "terminals" 
    and/or "non-terminals" on both the left side and the right side.
    
    
     */

    {Exit 0}
end
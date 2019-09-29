functor
import
    Application
    System
define

    % 1] a)
    % Assumption: Inputs are Floats
    proc {QuadraticEquation A B C ?RealSol ?X1 ?X2}
        local D P M in
            D = B*B-4.0*A*C
            P = (~B + {Float.sqrt D}) / (2.0*A)
            M = (~B - {Float.sqrt D}) / (2.0*A)
            if D >= 0.0 then
                RealSol = true
                X1 = P
                X2 = M
            else
                RealSol = false
            end
        end
    end

    % for nice printing in console =)
    {System.showInfo " "}

    % using local environment for testing
    local RealSol X1 X2 in
    {QuadraticEquation 2.0 1.0 ~1.0 RealSol X1 X2}
    {System.showInfo "1] a)"}
    {System.show RealSol#X1#X2} % here RealSol is bound to "true", X1 is bound to "0.5" & X2 is bound to "~1"(-1).
    end % ^ Note: "" is just to clarify the values, not actually a string. 

    % using local environment for testing
    local RealSol X1 X2 in
    {QuadraticEquation 2.0 1.0 2.0 RealSol X1 X2}
    {System.show RealSol#X1#X2} % here RealSol is bound to "false", X1 & X2 is unbound (also noted as "_")
    end % ^ Note: "" is just to clarify the values, not actually a string. 

    % for nice printing in console =)
    {System.showInfo " "}
    /*
    b)
    Why are procedural abstractions useful? Give at least two reasons.

    1):
    procedual abstractions are useful because it alows us to delay the execution of a statement.
    For example we can bind X to a procedure like so: X = proc {$} <statement> end. 
    Now our statement is packaged in the procedure and we can in essence execute the statement at any later time calling {X}

    2):
    procedual abstractions are also useful as we can define our statement(s) with free variables without yet knowing the specific values
    of said variables. The quadratic equation above is a good example of this. We can delay bounding RealSol, X1 and X2 until we know what values
    A, B and C has. At any time later we can simply call proc {QuadraticEquation ...} and pass in our desired values as the free variables.


    c)
    What is the difference between a procedure and a function?

    Answer:
    A procedure does not return any value when it is run, while a function does. 
    X = {Function A B} will bind X to the value returned from the function.
    Y = {Procedure C D} will "bind" Y to the statement packaged in the procedure, but not run it (can be run with {Y})

    you might say that a function will always map to a value when run, while a procedure will map to a statement
     */

    % 2]

    % returns the sum of the values of the list elements.
    fun {Sum1 List}
        case List of Head|Tail then
            Head + {Sum1 Tail}
        [] nil then
            0
        end
    end


    {System.showInfo "2]"}
    {System.show {Sum1 [1 2 3 4]}}    

    % for nice printing in console =)
    {System.showInfo " "}
    % 3]

    % a)
    fun {RightFold List Op U}
        case List of Head|Tail then
            % Op has to be a function which takes in two arguments
            {Op Head {RightFold Tail Op U}}
        [] nil then
            U
        end
    end

    /*
    b)
    Explanation of Rightfold:
    fun {RightFold List Op U}: fun defines a function and binds "RightFold" to it, "List", "Op" & "U" are in parameters and are replaced by
        specific values/elements when the function is called

    case List of Head|Tail then: if variable "List" is of the type Head|Tail (1. element of list | rest of list), execute the statement
         in the line below

    {Op Head {RightFold Tail Op U}}: The most important line in this function. Op is a function which takes in two parameters (important).
        the first parameter is the first element of the list from the parent RightFold call. 
        The second parameter needs to eventually become a variable, but we use a recursive call to reduce the list one element at a time 
        "from left to right" until we are at nil in the list (past the last value). After calling {Op LastElement {nil}} we will
        execute statements in the functions "backward recursively" updating the value in the second parameter for the next function call.

    [] nil then: used to determine if List in parameter in function call is "nil", this means we have reached or initial value and
        we execute the line below (in this case "case List of Head|Tail" will not be "true")

    U: determines what we are going to return if we have reached our initial value. Its very nice that we can define this in the first 
        call of RigthFold
    
    end x2: first end is used to close the case statement, second end is used to close the function body.
    */

    % c)
    
    fun {Length List}
        {RightFold List fun {$ X Y} 1+Y end 0}
    end
    
    {System.showInfo "3] c)"}
    {System.show {Length [1 2 3 4]}}

    fun {Sum2 List}
        {RightFold List fun {$ X Y} X+Y end 0}
    end

    {System.show {Sum2 [1 2 3 4]}}

    % for nice printing in console =)
    {System.showInfo " "}

    /*
    d)
    For the Sum and Length operations, would left fold (a left-associative fold) and right fold give different results? 
    Answer: No it would not give different results as ((((0+1)+2)+3)+4) is the same as (1+(2+(3+(4+0))) and
        ((((0+1)+1)+1)+1) is the same as (1+(1+(1+(1+0)))
    
    What about subtraction?
    Answer: 
        ((((0-1)-2)-3)-4) = -1-2-3-4 = -10, (1-(2-(3-(4-0)))) = 1-2-3-4 = 1-9 = -8. 
        The operator "minus" does not always give the same results when applied as left associative compared to right associative
        So we see it would indeed give different results (in most cases)
     
    e)
    What is a good value for U when using RightFold to implement the product of list elements?
    Answer:
        A good value to use is 1, as all the values we are interested in are the values before nil in a list. 
        we can signal that we have reached the end of our list and at the same time still recieve the right answer.
        (1*(2*(3*(4*U)))), if U is 0 we will end up with 0, if U is 2 we will have twice the correct value. It must be 1
    */

    % 4]

    fun {Quadratic A B C}
        fun {$ X}
            A*X*X + B*X + C
        end
    end

    {System.showInfo "4]"}
    {System.show {{Quadratic 3 2 1} 2}}

    % for nice printing in console =)
    {System.showInfo " "}

    % 5]

    % a)
    fun {LazyNumberGenerator StartValue}
        StartValue|fun {$} {LazyNumberGenerator StartValue+1} end
    end

   
    {System.showInfo "5] a)"}
    {System.show {LazyNumberGenerator 0}.1}
    {System.show {{LazyNumberGenerator 0}.2}.1}
    {System.show {{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1}

    /*
    b)
    High level description of solution in 5] a):
    The function takes a start value that is a of type where it is valid to use the "+" operator. 

    We take this value and place it, alone, as the head of a list. The way list structures work in oz is that it is nested tuples 
    with 1 unbound variable, where the unbound variable often is another tuple with another unbound variable and so on. This can be translated 
    to a binary tree. Consider all capital letters as unbound variables:
        In the list [1 2 3] we have  (1 X) where X = (2 Y) where Y = (3 nil). 
        For illustrative purposes we can say we have (1 (2 (3 nil)))

    What we do in our function is to bound a new "tuple"/structure at the place of the second element in the list we create in our 
    function call. Since we recursively call this function at the tail of the list we create nested tuple with head-values that are incremented by 1
    "infinitely" many times. 

    A very relevant limitation to having a "infitite" list is that we are not able to use right fold recursion on such a list, 
    as this requires us to reach the rightmost (last) element.

    
    6] a):
    Is your Sum function from Task 2 tail recursive? If yes, explain why. If not, implement a tail recursive
    version and explain how your changes made it so.

    the function in question:
    fun {Sum1 List}
        case List of Head|Tail then
            Head + {Sum1 Tail}
        [] nil then
            0
        end
    end


    A tail recursive version:
    */
    fun {TRecSum List Sum}
        % {System.show Sum} can be used for testing
        case List of Head|Tail then
            Head + {TRecSum Tail Sum+Head}
        [] nil then
            0
        end
    end

    % {System.show {TRecSum [1 2 3 4] 0}} can be used for testing
    /*
    6] a) continued:
        Sum1 was not tail recursive as the "Head + {Sum1 Tail}"" statement has to wait until {Sum1 Tail} is returned.
        {Sum1 Tail} has no information about Head or any values in the earlier function calls in the recursive call stack.
        Therefore it is therefore not tail recursive as every new tail is "separate" and "unknowing" about its predecessors.

        In TRecSum i added a new variable that allows every tail to have information about its predecessor. 
        It is exactly this that makes it tail recursive and it can be used 
        for last call optimalization that will improve the overall performance using this code.


    b) What is the benefit of tail recursion in Oz?
        Answer:
        tail recursion is very beneficial in Oz because you can implement functions with unbound variables. 
        These variables will only be assigned when the function is called so Oz can recognize patterns and skip steps in the calculations,
        which in turn will save us memory in the store and increase performance.

    c) Do all programming languages that allow recursion benefit from tail recursion? Why/why not?
        Answer:

        I would argue that runtime wise most programming languages can benefit from having tail recursion. But there are some languages 
        that don't initially use it because it eliminates the possibility to backtrace and debug where the tail recursion is applied. 

        therefore if a programming language is designed to be easy/consumer friendly to debug they would not benefit from tail recursion.
    */
    {Application.exit 0}

end
functor
import
    Application
    System 
    OS
define


    % 1]
    {System.showInfo "1]"}
    fun {GenerateOdd S E}
        if S =< E then
            if {Int.isOdd S} then
                S|{GenerateOdd S+2 E}
            else
                {GenerateOdd S+1 E}
            end
        else
            nil
        end
    end

    % testing for {GenerateOdd}
    {System.show {GenerateOdd ~3 10}}
    {System.show {GenerateOdd 3 3}}
    {System.show {GenerateOdd 2 2}}

    % for nice printing =)
    {System.showInfo " "}

    % 2]
    {System.showInfo "2]"}
    fun {Product S}
        case S of Head|Tail then
            Head * {Product Tail}
        [] nil then
            1
        end
    end

    % testing for {Product}
    {System.show {Product [1 2 3 4]}}

    % for nice printing =)
    {System.showInfo " "}

    % 3]
    {System.showInfo "3]"}
    local Producer1 Consumer1 in
        thread Producer1 = {GenerateOdd 0 1000} end
        thread Consumer1 = {Product Producer1} end
        {System.showInfo Consumer1}
    end

    % for nice printing =)
    {System.showInfo " "}

    /*
    What are the first three digits of the output?
    A: the first 3 digits of the output is: 100

    What is the benefit of running on two separate threads?
    A: the benefit of running on two separate threads is that Consumer1 is syncronized with Producer1, as the Product function only will use the
        computational power to take the product and call the recursive function if the Producer actually have produced something that matches the 
        case statement. It also has the benefit of having threads for each element in the stream being properly terminated after it's run, along with
        not having 1 big thread of all the computations taking up all the processor time.

    */

    % 4]
    {System.showInfo "4]"}
    /*
    Rewrite your function from task 1 to be lazy, using the lazy annotation. How does this affect task 3 in terms
    of throughput and resource usage?

    A:  The throughput will be heavily reduced due to the nature of lazy functions to incrementally execute.
        The resource usage will be much lower as we spread our computational power over time and by need.
    */

    fun lazy {LazyGenerateOdd S E}
        if S =< E then
            if {Int.isOdd S} then
                S|{LazyGenerateOdd S+2 E}
            else
                {LazyGenerateOdd S+1 E}
            end
        else
            nil
        end
    end

    local Producer2 Consumer2 in
        thread Producer2 = {LazyGenerateOdd 0 1000} end
        thread Consumer2 = {Product Producer2} end
        {System.showInfo Consumer2}
    end

    % for nice printing =)
    {System.showInfo " "}


    % 5]
    {System.showInfo "5]"}

    % a)
    {System.showInfo "a)"}

    fun lazy {HammerFactory} W D in
        {Delay 1000}
        W = {String.toAtom "working"}
        D = {String.toAtom "defect"}
        if {RandomInt 1 11} =< 9 then
            W|{HammerFactory}
        else
            D|{HammerFactory}
        end
    end

    fun {RandomInt Min Max} X = {OS.rand} MinOS MaxOS in
        {OS.randLimits ?MinOS ?MaxOS}
        Min + X*(Max - Min) div (MaxOS - MinOS)
    end


    % testing {Hammerfactory}
    local HammerTime B in
    HammerTime = {HammerFactory}
    B = HammerTime.2.2.2.1
    {System.show HammerTime}
    end

    % for nice printing =)
    {System.showInfo " "}

    % b)
    {System.showInfo "b)"}

    % Assumption: HammerStream is a stream containing "working"-atoms & "defect"-atoms
    fun {HammerConsumer HammerStream N}
        if N =< 0 then
            0
        else
            case HammerStream of Head|Tail then
                if {Atom.toString Head} == "working" then
                    1 + {HammerConsumer Tail N-1}
                else
                    0 + {HammerConsumer Tail N-1}
                end
            end
        end
    end

    local HammerTime Consumer in
    HammerTime = {HammerFactory} % Producer
    Consumer = {HammerConsumer HammerTime 10} % Consumer
    {System.show Consumer}
    end

    % for nice printing =)
    {System.showInfo " "}

    % c)
    fun {BoundedBuffer HammerStream N}
        % ReducedStream is needed to initiate our first call of {Hammerloop} where ReducedStream is "N" (wanted buffer size) elements "behind" our HammerStream
        % it is very important that the call of {ListDrop} is encapsulated in a thread statement so that we start our buffer process while simontaneously 
        % being able to execute other parts in our program.
        ReducedStream=thread {ListDrop HammerStream N} end
        % defining a function thatn has two streams as arguments. The difference between them is explained above
        fun lazy {HammerLoop HammerStream ReducedStream}
            % pattern matching using the case statement to check if the stream is valid and creating Hammerstream.1 = Head and Hammerstream.2 = Tail
            case HammerStream of Head|Tail then
                % here HammerLoop is called recursively but with the "tail" element of both Hammerstream and ReducedStream effectively moving 1 element
                % further down the streams in the function call. This will keep the buffer size (stream difference) the same between the streams

                % calling ReducedStream.2 is equivalent to calling {ListDrop ReducedStream 1} 
                % and has to be in its own thread for the same reasons that {ListDrop} had to
                Head|{HammerLoop Tail thread ReducedStream.2 end}
            end
        end
        % "in" is making it valid to use {HammerLoop} and ReducedStream
        in
        % calling {Hammerloop} the first time and returns a stream similar to HammerStream but with hammers being created in another thread}
        {HammerLoop HammerStream ReducedStream}
    end

    % implementing my own version of "{List.drop ...}" out of fear of getting deducted by using built-in functions
    fun {ListDrop Stream I}
        if I =< 0 then
            Stream
        else
            case Stream of Head|Tail then
                {ListDrop Tail I-1}
            [] nil then 
                nil
            end
        end
    end

    % 1)
    {System.showInfo "c) 1)"}

    % with buffer
    local HammerStream Buffer Consumer in
    HammerStream = {HammerFactory}
    Buffer = {BoundedBuffer HammerStream 6}
    {Delay 6000}
    Consumer = {HammerConsumer Buffer 10}
    {System.show Consumer}
    end 

    % for nice printing =)
    {System.showInfo " "}

    % 2)
    {System.showInfo "c) 2)"}

    % without buffer
    local HammerStream Consumer in
    HammerStream = {HammerFactory}
    {Delay 6000}
    Consumer = {HammerConsumer HammerStream 10}
    {System.show Consumer}
    end   

    {Application.exit 0}
end
functor
import
   System
define
   local X Y Z
      Y = 300
      Z = 30
      X = Y * Z
   end
   
   local X Y Z in
      X = "This is a string"
      %thread{System.showInfo Y}end
      Y = X
   end

   fun {Min X Y}
      if X < Y then
	 X
      else
	 Y
      end
   end

   fun {Max X Y}
      if X > Y then
	 X
      else
	 Y
      end
   end

   proc {PrintGreater Number1 Number2}
      {System.showInfo {Max Number1 Number2}}
   end
   %{PrintGreater 5 3}

   local Pi R in
   Pi = 355.0/113.0

   fun {Area R}
      Pi*R*R
   end

   fun {Diameter R}
      R * 2.0
   end

   fun {Circumference R}
      2.0 * Pi * R
   end

   proc {Circle R}
      {System.showInfo {Area R}}
      {System.showInfo {Diameter R}}
      {System.showInfo {Circumference R}}
   end
   %thread {Circle 5.0} end
   end

   fun {Factorial N}
      if N == 0 then
	 1
      else
	 N*{Factorial (N-1)}
      end
   end

   %{System.showInfo {Factorial 5}}

   fun {Length List}
      case List of Head|Tail then
	 1+{Length Tail}
      else
	 0
      end
   end

   thread{System.showInfo {Length [1 2 3 4 5]}}end

   fun {Take List Count}
      if Count == 0 then
	 nil
      else
	 case List of Head|Tail then
	    Head|{Take Tail Count-1}
	 else
	    nil
	 end
      end
   end

   %{System.show{Take [1 2 3 4 5] 7}}

   fun {Drop List Count}
      if Count == 0 then
	 List
      else
	 case List of Head|Tail then
	    {Drop Tail Count-1}
	 else
	    nil
	 end
      end
   end
   %{System.show{Drop [1 2 3 4 5] 2}}

   fun {Append List1 List2}
      case List1 of Head|Tail then
	 Head|{Append Tail List2}
      else
	 List2
      end
   end

   %{System.show{Append [1 2 3] [4 5 6]}}

   fun {Member List Element}
      case List of Head|Tail then
	 if Head == Element then
	    true
	 else
	    {Member Tail Element}
	 end
      else
	 false
      end
   end
   
   %{System.show{Member [1 2 3 4 5] 3}}

   fun{Position List Element}
      case List of Head|Tail then
	 if Head == Element then
	    0
	 else
	    1 + {Position Tail Element}
	 end
      else
	 1
      end
   end

   {System.showInfo{Position [1 2 3 4 5] 2}}
   
end
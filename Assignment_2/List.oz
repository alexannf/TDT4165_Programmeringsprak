fun {Length List}
    case List of Head|Tail then
        1 + {Length Tail}
    [] nil then
        0
    end
end


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


fun {Append List1 List2}
    case List1 of Head|Tail then
        Head|{Append Tail List2}
    else
        List2
    end
end


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


fun {Position List Element}
    case List of Head|Tail then
        if Element == Head then
            0
        else
            1+{Position Tail Element}
        end
    else
        0
    end
end
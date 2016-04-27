@doc "@knet function reshape(x;outdims=(size1,size2)) reshapes array." :reshape
type Reshape <: Op; outdims;
    function Reshape(;outdims=0, o...)
        new(outdims)
    end
end

ninputs(::Reshape)=1
canoverwrite(::Reshape)=false
back_reads_x(::Reshape)=false
back_reads_y(::Reshape)=false

function forw(::Reshape, x, y; o...)
    (x == nothing) && return nothing
    copy!(y, x)
end

function back(::Reshape, dy, dx; x=nothing, o...)
    if dx != nothing
        copy!(dx, dy)
    end
end

function infersize(r::Reshape,xdims,ydims)
    @assert (r.outdims!=nothing) "outdims cannot be blank for reshape"

    zero_indices = findin(r.outdims,0)
    should_infer = (length(zero_indices) == 1)
    @assert (should_infer || length(zero_indices) == 0)) "reshape cannot infer more than one dimension"

    if xdims == ydims == nothing
        return nothing
    end

    if should_infer
        if xdims != nothing && ydims == nothing
            # implement this
        elseif xdims == nothing && ydims != nothing
            return (xdims, ydims)
        else
        end
    else
        if xdims != nothing && ydims == nothing
            if prod(xdims)==prod(r.outdims)
                return (xdims,r.outdims)
            else
                throw(DimensionMismatch()))
            end
        elseif xdims == nothing && ydims != nothing
            if ydims == r.outdims
                return (xdims, r.outdims)
            else
                throw(DimensionMismatch()))
            end
        else
            if (prod(xdims)==prod(r.outdims)) && (ydims == r.outdims)
                return (xdims, r.outdims)
            end
        end
    end
end

module FunctionalPipes

export dispatch, pipe, 🔥

"Types that are callable."
const CallableType = Union{Type,Function}

"Token used for argument replacement."
const 🔥 = :token

"""
    apply(x, f::CallableType)
    apply(x::Tuple, f::CallableType)
    apply(::Nothing, f::CallableType)

Apply a function over a value `x`.  If `x` is a tuple, then
splat as arguments to the function.  If `x` is `nothing`, 
then call the function without any arguments.  Otherwise,
call the function with a single argument `x`.
"""
function apply end

apply(x, f::CallableType) = f(x)
apply(x::Tuple, f::CallableType) = f(x...)
apply(::Nothing, f::CallableType) = f()

"""
Returns a function that takes an argument `x` and substitutes 
a tuple containing `:token` with `x`.
"""
function substitute(args::Tuple)
    x -> begin
        vec = []
        for arg in args
            push!(vec, arg === 🔥 ? x : arg)
        end
        return tuple(vec...)
    end
end

"""
    dispatch(f::CallableType, args...)

Returns a dispatcher function that takes an argument `x` and 
forwards to funciton `f` with specified arguments `args`.  
If the `args` tuple contains a token `:token` then it is replaced 
with the supplied argument `x`.  

The dispatcher function normally returns whatever returned from 
function `f`.  However, if the returned value is `nothing`, then
it would return `x`.  This behavior is designed to support
function `f` that only produces side effect e.g. println.
"""
function dispatch(f::CallableType, args...)
    x -> let result = apply(substitute(args)(x), f)
        result === nothing ? x : result
    end
end

"""
    pipe([x], fns::CallableType...)

Create a functional pipe with a series of functions `fns`.  
If the first argument is present, then it is passed as an initial 
value to the first function in `fns`.
"""
function pipe end

pipe(x, fns::CallableType...) = foldl(apply, fns, init = x)
pipe(fns::CallableType...) = pipe(nothing, fns...)

end # module

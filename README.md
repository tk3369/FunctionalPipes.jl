# FunctionalPipes

This package provides a simple facility to build functional pipes
support functions that require more than one argument.  

The pipe operator `|>` works well as long as the downstream
function takes a single argument.  Otherwise, it becomes quite
awkward to make anonymous functions to work around the issue.
For example:

```julia
rand(10) |> v -> filter(x -> x > 0.5, v) 
```

Using functional pipes, we can do the following:

```julia
pipe(
    rand(10), 
    dispatch(filter, x -> x > 0.5, 🔥)
)
```

The `dispatch` function replaces the previous result in the place
where 🔥 is present. You can even have multiple of them:

```julia
pipe(3, dispatch(+, 🔥, 🔥))     # 6
```

If the dispatched function returns nothing, then it carries over
the prior result.  This would be useful for functions that only
have side effects.

```julia
julia> pipe(
            1:10,
            collect,
            dispatch(filter, isodd, 🔥),
            dispatch(println, "values: ", 🔥),
            sum,
            dispatch(println, "total: ", 🔥)
        )
values: [1, 3, 5, 7, 9]
total: 25
25
```
# FunctionalPipes

This package provides a simple facility to build functional pipes
that support functions taking more than a single argument.  It also
allows the results from upstream be placed in any argument position.

## Motivation 
The pipe operator `|>` works well as long as the downstream
function takes a single argument.  Otherwise, it becomes quite
awkward to make anonymous functions to work around the issue.
For example:

```julia
[1,2,3] |> v -> filter(x -> x > 1, v) |> sum      # 5
```

## Features

Using the `pipe` function, we can build a computation pipe 
as usual:

```julia
pipe([1,2,3], sum, iseven)  # true
```

However, we can pass prior results to a function in any specific
argument position.  The special token is 🔥.

```julia
pipe(
    [1,2,3],
    dispatch(filter, x -> x > 1, 🔥),
    sum
)
```

In fact, you can even have multiple tokens:

```julia
pipe(3, dispatch(+, 🔥, 🔥))     # 6
```

If the dispatched function returns `nothing`, then it carries over
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

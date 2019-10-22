using FunctionalPipes
using Test

@testset "FunctionalPipes.jl" begin

    add(n) = x -> x + n
    mul(n) = x -> x * n
    zero() = 0

    # init value provided, single function
    @test pipe(1, add(1)) == 2

    # init value provided, multiple functions
    @test pipe(1, add(1), mul(2), add(3)) == 7

    # no init value, single function
    @test pipe(zero, add(1)) == 1
    
    # no init value, multiple functions
    @test pipe(zero, add(1), mul(2)) == 2

    # nothing as init value is the same as no init value
    @test pipe(nothing, zero, add(1)) == 1

    # dispatch with side effect
    @test pipe(
        zero, 
        add(1), 
        dispatch(println, "good job: ", 🔥), 
        mul(2)
    ) == 2

    @test pipe(
        zero,
        add(3),
        dispatch((x,y,z)->x*y*z, 2, 🔥, 4),
        dispatch(println, "variation 1: ", 🔥)
    ) == 24

    @test pipe(
        zero,
        add(3),
        dispatch((x,y,z)->x*y*z, 🔥, 2, 4),
        dispatch(println, "variation 2: ", 🔥)
    ) == 24

    @test pipe(
        zero,
        add(3),
        dispatch((x,y,z)->x*y*z, 2, 4, 🔥),
        dispatch(println, "variation 3: ", 🔥)
    ) == 24

    @test pipe(
        1:10,
        collect,
        dispatch(filter, isodd, 🔥),
        dispatch(println, "values: ", 🔥),
        sum,
        dispatch(println, "total: ", 🔥)
    ) == 25

end

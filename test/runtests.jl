using OptionalData
using Test

struct TestType
    a::Float64
    b::Float64
    c::Float64
end

@OptionalData opt1 Symbol
@OptionalData opt2 TestType "Try again."

@testset "OptionalData" begin
    @test string(opt1) == "OptData{Symbol}()"
    @test_throws NoDataError get(opt1)
    @test sprint(showerror, NoDataError(opt1)) == "`opt1` is not available."
    push!(opt1, :Test)
    @test string(opt1) == "OptData{Symbol}(Test)"
    @test get(opt1) == :Test
    push!(opt1, "Test")
    @test get(opt1) == :Test

    @test string(opt2) == "OptData{TestType}()"
    @test_throws NoDataError get(opt2)
    @test sprint(showerror, NoDataError(opt2)) == "`opt2` is not available. Try again."
    push!(opt2, TestType(1, 2, 3))
    @test string(opt2) == "OptData{TestType}(TestType(1.0, 2.0, 3.0))"
    @test get(opt2) == TestType(1, 2, 3)
    push!(opt2, 1, 2, 3)
    @test get(opt2) == TestType(1, 2, 3)
end

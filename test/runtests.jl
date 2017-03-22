using OptionalData
using Base.Test

immutable TestType
    a::Float64
    b::Float64
    c::Float64
end

@testset "OptionalData" begin
    @OptionalData opt Symbol
    @test string(opt) == "OptData{Symbol}()"
    @test_throws ErrorException get(opt)
    push!(opt, :Test)
    @test string(opt) == "OptData{Symbol}(Test)"
    @test get(opt) == :Test
    push!(opt, "Test")
    @test get(opt) == :Test

    @OptionalData opt TestType
    @test string(opt) == "OptData{TestType}()"
    @test_throws ErrorException get(opt)
    push!(opt, TestType(1, 2, 3))
    @static if VERSION < v"0.6-"
        @test string(opt) == "OptData{TestType}(TestType(1.0,2.0,3.0))"
    else
        @test string(opt) == "OptData{TestType}(TestType(1.0, 2.0, 3.0))"
    end
    @test get(opt) == TestType(1, 2, 3)
    push!(opt, 1, 2, 3)
    @test get(opt) == TestType(1, 2, 3)
end

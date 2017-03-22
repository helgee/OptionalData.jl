using OptionalData
using Base.Test

struct TestType
    a::Float64
    b::Float64
    c::Float64
end

@testset "OptionalData" begin
    opt = OptData(Symbol)
    @test_throws ErrorException get(opt)
    @test_throws ErrorException @get(opt)
    push!(opt, :Test)
    @test get(opt) == :Test
    push!(opt, "Test")
    @test get(opt) == :Test

    opt = OptData(TestType)
    @test_throws ErrorException get(opt)
    @test_throws ErrorException @get(opt)
    push!(opt, TestType(1, 2, 3))
    @test get(opt) == TestType(1, 2, 3)
    push!(opt, 1, 2, 3)
    @test get(opt) == TestType(1, 2, 3)
end

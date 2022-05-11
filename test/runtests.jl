using Test

const path = mktempdir()

@testset "t1.jl" begin
	include("test_t1.jl")
	@test filesize(joinpath(path, "t1.msh")) > 0
end

@testset "t16.jl" begin
	include("test_t16.jl")
	@test filesize(joinpath(path, "t16.msh")) > 0
end

rm(path, recursive=true)

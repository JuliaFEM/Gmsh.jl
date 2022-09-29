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

@testset "Gmsh.(initialize|finalize) wrappers" begin
    Gmsh.finalize()
    # With exit hook
    l = length(Base.atexit_hooks)
    @test !Bool(gmsh.isInitialized())
    @test Gmsh.initialize()
    @test Bool(gmsh.isInitialized())
    @test length(Base.atexit_hooks) == l + 1
    Gmsh.finalize()
    # Without exit hook
    l = length(Base.atexit_hooks)
    @test !Bool(gmsh.isInitialized())
    @test Gmsh.initialize(; finalize_atexit=false)
    @test Bool(gmsh.isInitialized())
    @test length(Base.atexit_hooks) == l
    Gmsh.finalize()
    # argv
    @test Gmsh.initialize(["gmsh", "-v", "0"])
    @test Bool(gmsh.isInitialized())
    @test gmsh.option.getNumber("General.Verbosity") == 0
    Gmsh.finalize()
end

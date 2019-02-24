module Gmsh

const deps_path = abspath(joinpath(dirname(@__FILE__), "..", "deps"))

if !isfile(joinpath(deps_path, "deps.jl"))
    error("Gmsh not installed properly, run Pkg.build(\"Gmsh\"), restart Julia and try again")
end
include(joinpath(deps_path, "deps.jl"))
include(joinpath(deps_path, "usr", "lib", "gmsh.jl"))
global const api = gmsh

function __init__()
    # Always check your dependencies that live in `deps.jl`
    check_deps()
end


end # module

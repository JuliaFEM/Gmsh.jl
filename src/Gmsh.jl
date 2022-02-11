# Copied from https://github.com/gridap/GridapGmsh.jl/blob/master/deps/build.jl
# to use the new officially registered Gmsh JLL

module Gmsh

using Libdl

deps_jl = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(deps_jl)
  s = """
  Package Gmsh.jl not installed properly.
  Run Pkg.build(\"Gmsh\"), restart Julia and try again.
  """
  error(s)
end

include(deps_jl)

if GMSH_FOUND
    include(gmsh_jl)
    # Hack taken from MPI.jl
    function __init__()
      @static if Sys.isunix()
        Libdl.dlopen(gmsh.lib, Libdl.RTLD_LAZY | Libdl.RTLD_GLOBAL)
      end
    end
  else
      s = """
      Gmsh not found in system paths.
      Renstall Gmsh.jl or export `GMSHROOT` that points to a Gmsh installation and rebuild the project.
      Run Pkg.build(\"Gmsh\"), restart Julia and try again.
      """
      @warn s
  end
  
  macro check_if_loaded()
    quote
      if ! GMSH_FOUND
        error("Gmsh is not loaded or installed properly.")
      end
    end
  end
  
end # module

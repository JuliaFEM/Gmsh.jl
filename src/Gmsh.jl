# Copied from https://github.com/gridap/GridapGmsh.jl/blob/master/deps/build.jl
# to use the new officially registered Gmsh JLL

module Gmsh

deps_jl = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(deps_jl)
  s = """
  Package GridapGmsh not installed properly.
  Run Pkg.build(\"GridapGmsh\"), restart Julia and try again.
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
      Install Gmsh or export path to Gmsh and rebuild the project.
      Run Pkg.build(\"GridapGmsh\"), restart Julia and try again.
      """
      @warn s
  end
  
  macro check_if_loaded()
    quote
      if ! GMSH_FOUND
        error("GridapGmsh is not loaded or installed properly.")
      end
    end
  end
  
end # module

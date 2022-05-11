module Gmsh
using Reexport

import gmsh_jll
include(gmsh_jll.gmsh_api)
@reexport import .gmsh

end

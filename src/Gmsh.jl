module Gmsh

import gmsh_jll
include(gmsh_jll.gmsh_api)
import .gmsh
export gmsh

"""
    Gmsh.initialize(; finalize_atexit=true)

Wrapper around `gmsh.initialize` which make sure to only call it if `gmsh` is not already
initialized. Return `true` if `gmsh.initialize` was called, and `false` if `gmsh` was
already initialized.

If `finalize_atexit` is `true` a Julia exit hook is added, which calls `finalize()`.
"""
function initialize(; finalize_atexit=true)
    if Bool(gmsh.isInitialized())
        return false
    end
    gmsh.initialize()
    if finalize_atexit
        atexit(finalize)
    end
    return true
end

"""
    Gmsh.finalize()

Wrapper around `gmsh.finalize` which make sure to only call it if `gmsh` is initialized.
"""
function finalize()
    if Bool(gmsh.isInitialized())
        gmsh.finalize()
    end
end

end

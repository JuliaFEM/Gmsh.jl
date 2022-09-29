module Gmsh

import gmsh_jll
include(gmsh_jll.gmsh_api)
import .gmsh
export gmsh

"""
    Gmsh.initialize(argv=String[]; finalize_atexit=true)

Wrapper around `gmsh.initialize` which make sure to only call it if `gmsh` is not already
initialized. Return `true` if `gmsh.initialize` was called, and `false` if `gmsh` was
already initialized.

The argument vector `argv` is passed to `gmsh.initialize`. `argv` can be used to pass
command line options to Gmsh, see [Gmsh documentation for more
details](https://gmsh.info/doc/texinfo/gmsh.html#index-Command_002dline-options).

If `finalize_atexit` is `true` a Julia exit hook is added, which calls `finalize()`.
"""
function initialize(argv=String[]; finalize_atexit=true)
    if Bool(gmsh.isInitialized())
        return false
    end
    gmsh.initialize(argv)
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

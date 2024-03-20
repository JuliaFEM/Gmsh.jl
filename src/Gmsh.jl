module Gmsh

@static if VERSION >= v"1.6"
    using Preferences
end

@static if VERSION >= v"1.6"
    gmsh_provider = @load_preference("gmsh_provider","gmsh_jll")
else
    gmsh_provider = "gmsh_jll"
end

# The logic behind the preferences is inspired by the one found in PetscCall.jl

if gmsh_provider ∉ ("gmsh_jll","system")
    error("gmsh_provider is either gmsh_jll or system")
end

@static if gmsh_provider == "gmsh_jll"
    import gmsh_jll
    const gmsh_api = gmsh_jll.gmsh_api
end

@static if gmsh_provider == "system"
    const gmsh_jl_dir = @load_preference("gmsh_jl_dir","") 
    if gmsh_jl_dir == ""
        error("Using a system gmsh installation but gmsh_jl_dir not found in Preferences.toml file")
    end
    const gmsh_api = joinpath(gmsh_jl_dir,"gmsh.jl")
end

include(gmsh_api)
import .gmsh
export gmsh

#@static if gmsh_provider == "system"
#    using Libdl
#    function __init__()
#        @static if Sys.isunix()
#            Libdl.dlopen(gmsh.lib, Libdl.RTLD_LAZY | Libdl.RTLD_DEEPBIND)
#        end
#    end
#end

"""
    Gmsh.use_gmsh_jll()

Configure Gmsh to use the binary provided by gmsh_jll.
"""
function use_gmsh_jll()
    @static if VERSION >= v"1.6"
        gmsh_provider = "gmsh_jll"
        @set_preferences!(
                          "gmsh_provider"=>gmsh_provider,
                         )
        msg = """
        Gmsh preferences changed!
        The new preferences are:
        gmsh_provider = $(gmsh_provider)
        Restart Julia for these changes to take effect.
        """
        @info msg
    end
    nothing
end

"""
    Gmsh.use_system_gmsh([;gmsh_jl_dir])

Configure Gmsh to use the binary provided by a system installation.
Key-word argument `gmsh_jl_dir` contains the path of the directory containing `gmsh.jl`, the file with
the Julia API of gmsh. This file needs to be installed as part of the SDK of gmsh.
If `gmsh_jl_dir` is omitted, this function will look for `gmsh.jl` in `LD_LIBRARY_PATH`.
"""
function use_system_gmsh(;gmsh_jl_dir=nothing)
    @static if VERSION >= v"1.6"
        function findindir(route,fn)
            files = readdir(route,join=false)
            for file in files
                if file == fn
                    gmsh_jl_dir = joinpath(route,file)
                    return gmsh_jl_dir
                end
            end
            nothing
        end
        if gmsh_jl_dir === nothing
            if haskey(ENV,"LD_LIBRARY_PATH") && ENV["LD_LIBRARY_PATH"] != ""
                routes = split(ENV["LD_LIBRARY_PATH"],':')
                for route in routes
                    gmsh_jl_dir = findindir(route,"gmsh.jl")
                    if gmsh_jl_dir !== nothing
                        @info "Gmsh Julia API found in the system at $(gmsh_jl_dir)."
                        break
                    end
                end
            end
        end
        if gmsh_jl_dir === nothing
            msg = """
            Unable to find a Gmsh installation in the system.

            We looked for the Gmsh Julia API file gmsh.jl in the folders in LD_LIBRARY_PATH.

            You can also manualy specify the route with the key-word argument gmsh_jl_dir.

            Example
            =======

            julia> using Gmsh
            julia> using Gmsh.use_system_gmsh(;gmsh_jl_dir="path/to/gmsh.jl")
            """
            error(msg)
        end
        gmsh_provider = "system"
        @set_preferences!(
                          "gmsh_provider"=>gmsh_provider,
                          "gmsh_jl_dir"=>gmsh_jl_dir,
                         )
        msg = """
        Gmsh preferences changed!
        The new preferences are:
        gmsh_provider = $(gmsh_provider)
        gmsh_jl_dir = $(gmsh_jl_dir)
        Restart Julia for these changes to take effect.
        """
        @info msg
    end
    nothing
end

"""
    Gmsh.initialize(argv=String[]; finalize_atexit=true)

Wrapper around `gmsh.initialize` which make sure to only call it if `gmsh` is not already
initialized. Return `true` if `gmsh.initialize` was called, and `false` if `gmsh` was
already initialized.

The argument vector `argv` is passed to `gmsh.initialize`. `argv` can be used to pass
command line options to Gmsh, see [Gmsh documentation for more
details](https://gmsh.info/doc/texinfo/gmsh.html#index-Command_002dline-options). Note that
this wrapper prepends the program name to `argv` since Gmsh expects that to be the first
entry.

If `finalize_atexit` is `true` a Julia exit hook is added, which calls `finalize()`.

**Example**
```julia
Gmsh.initialize(["-v", "0"]) # initialize with decreased verbosity
```
"""
function initialize(argv=String[]; finalize_atexit=true)
    if Bool(gmsh.isInitialized())
        return false
    end
    # Prepend a dummy program name in case argv only contains options
    # see https://gitlab.onelab.info/gmsh/gmsh/-/issues/2112
    if length(argv) > 0 && startswith(first(argv), "-")
        argv = pushfirst!(copy(argv), "gmsh")
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

end # module

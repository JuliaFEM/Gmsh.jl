# Gmsh.jl

Gmsh.jl contains the Julia API for
[Gmsh: a three-dimensional finite element mesh generator](https://gmsh.info/).
Using Gmsh.jl, it is possible to construct parametric solid models and/or
perform automatic mesh generation.

The official [Gmsh API](https://gitlab.onelab.info/gmsh/gmsh/blob/master/api/gmsh.jl)
can be accessed by first adding the package:

```julia
pkg> add Gmsh
```

and then loading it in Julia:

```julia
julia> import Gmsh: gmsh
```


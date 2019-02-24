# Gmsh.jl

[![][gitter-img]][gitter-url]
[![][travis-img]][travis-url]
[![][pkg-1.0-img]][pkg-1.0-url]
[![][pkg-1.1-img]][pkg-1.1-url]
[![][coveralls-img]][coveralls-url]
[![][issues-img]][issues-url]

Gmsh.jl contains API for Gmsh: a three-dimensional finite element mesh generator.
With the help of Gmsh.jl, it is possible add parametric model construction and/or
automatic mesh generation to a FEM pipeline.

Gmsh official [API](https://gitlab.onelab.info/gmsh/gmsh/blob/master/api/gmsh.jl)
can be accessed by writing

```julia
import Gmsh: gmsh
```

After that, follow the official documentation of Gmsh. For example, `tutorial/t1`
using api is done as follows:

```julia
gmsh.initialize()
gmsh.option.setNumber("General.Terminal", 1)
gmsh.model.add("t1")
lc = 1e-2
gmsh.model.geo.addPoint(0, 0, 0, lc, 1)
gmsh.model.geo.addPoint(.1, 0,  0, lc, 2)
gmsh.model.geo.addPoint(.1, .3, 0, lc, 3)
gmsh.model.geo.addPoint(0, .3, 0, lc, 4)
gmsh.model.geo.addLine(1, 2, 1)
gmsh.model.geo.addLine(3, 2, 2)
gmsh.model.geo.addLine(3, 4, 3)
gmsh.model.geo.addLine(4, 1, 4)
gmsh.model.geo.addCurveLoop([4, 1, -2, 3], 1)
gmsh.model.geo.addPlaneSurface([1], 1)
gmsh.model.addPhysicalGroup(0, [1, 2], 1)
gmsh.model.addPhysicalGroup(1, [1, 2], 2)
gmsh.model.addPhysicalGroup(2, [1], 6)
gmsh.model.setPhysicalName(2, 6, "My surface")
gmsh.model.geo.synchronize()
gmsh.model.mesh.generate(2)
gmsh.write("t1.msh")
gmsh.finalize()
```

[gitter-img]: https://badges.gitter.im/Join%20Chat.svg
[gitter-url]: https://gitter.im/JuliaFEM/JuliaFEM.jl

[travis-img]: https://travis-ci.org/JuliaFEM/Gmsh.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaFEM/Gmsh.jl

[coveralls-img]: https://coveralls.io/repos/github/JuliaFEM/Gmsh.jl/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/github/JuliaFEM/Gmsh.jl?branch=master

[issues-img]: https://img.shields.io/github/issues/JuliaFEM/Gmsh.jl.svg
[issues-url]: https://github.com/JuliaFEM/Gmsh.jl/issues

[pkg-1.0-img]: http://pkg.julialang.org/badges/Gmsh_1.0.svg
[pkg-1.0-url]: http://pkg.julialang.org/?pkg=Gmsh&ver=1.0

[pkg-1.1-img]: http://pkg.julialang.org/badges/Gmsh_1.1.svg
[pkg-1.1-url]: http://pkg.julialang.org/?pkg=Gmsh&ver=1.1

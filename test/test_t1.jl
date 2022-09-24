# This file reimplements gmsh/tutorial/t1.geo in Julia.
# See the corresponding Python tutorial for detailed comments.
using Gmsh: Gmsh, gmsh

Gmsh.initialize()

gmsh.model.add("t1")

lc = 1e-2
gmsh.model.geo.addPoint(0, 0, 0, lc, 1)
gmsh.model.geo.addPoint(.1, 0,  0, lc, 2)
gmsh.model.geo.addPoint(.1, .3, 0, lc, 3)

p4 = gmsh.model.geo.addPoint(0, .3, 0, lc)

gmsh.model.geo.addLine(1, 2, 1)
gmsh.model.geo.addLine(3, 2, 2)
gmsh.model.geo.addLine(3, p4, 3)
gmsh.model.geo.addLine(4, 1, p4)

gmsh.model.geo.addCurveLoop([4, 1, -2, 3], 1)
gmsh.model.geo.addPlaneSurface([1], 1)

gmsh.model.geo.synchronize()

gmsh.model.addPhysicalGroup(0, [1, 2], 1)
gmsh.model.addPhysicalGroup(1, [1, 2], 2)
gmsh.model.addPhysicalGroup(2, [1], 6)

gmsh.model.setPhysicalName(2, 6, "My surface")

gmsh.model.mesh.generate(2)

if @isdefined path
	gmsh.write(joinpath(path, "t1.msh"))
end

if "-gui" in ARGS
    gmsh.fltk.run()
end

Gmsh.finalize()

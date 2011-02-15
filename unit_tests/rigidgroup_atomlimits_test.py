r= RigidGroup()
r.addAtom(PointND([-2,0,0]), PointND([-3,-1,-1]), PointND([-1,1,1]))
r.addAtom(PointND([2,0,0]), PointND([1,-1,-1]), PointND([3,1,1]))
tmp= calculateAtomLimits(r, 2)

print "bla!"
print tmp[r.atoms[0]]
print tmp[r.atoms[1]]


r=1
c1= PointND([5,6,7])
c2= PointND([1,2,4])

rigid= RigidGroup()
rigid.addAtom(c1, c1-r, c1+r)
rigid.addAtom(c2, c2-r, c2+r)
rigid.recalculateCenter()

assert rigid.center.c == [3,4,5.5]
assert rigid.atoms[0].position.c == [2,2,1.5]
assert rigid.atoms[1].position.c == [-2,-2,-1.5]

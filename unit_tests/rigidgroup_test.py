c1= PointND([-2,0,0])
c2= PointND([2,0,0])

rigid= RigidGroup()
rigid.addAtom(c1, c1-1, c1+1)
rigid.addAtom(c2, c2-8, c2+8)
rigid.recalculateCenter()

assert rigid.center.c == [0,0,0]
assert rigid.atoms[0].position.c == [-2,0,0]
assert rigid.atoms[1].position.c == [2,0,0]


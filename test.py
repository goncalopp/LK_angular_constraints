from region import Region
from pointnd import PointND
from sine import Sine
from atom import Atom
from rigidgroup import RigidGroup
import atomsine_calc

from math import sqrt, atan2

a= PointND([0,1,2])
b= PointND(a)
assert b[0]==0
assert b[1]==1
assert b[2]==2

b+1
assert b[0]==0
assert b[1]==1
assert b[2]==2
b+=1
assert b[0]==1
assert b[1]==2
assert b[2]==3
assert b.norm()== sqrt(1+2*2+3*3)

r= Region(a,b)
c= PointND(b)
assert r.pointInside(a)
assert r.pointInside(b)
assert r.pointInside(c)

c+=0.0
assert r.pointInside(c)
c+=0.1
assert not r.pointInside(c)
c-=0.1
assert r.pointInside(c)


#------------

a= PointND([2,2,2])
b= PointND([3,4,5])
s1= Sine.fromPoint(a, b, 0)
s2= Sine.fromPoint(a, b, 1)
s3= Sine.fromPoint(a, b, 2)
assert s1.p == atan2(3,2)
assert s2.p == atan2(1,3)
assert s3.p == atan2(2,1)
assert s1.calculateZeros() == [2.158798930342464, 5.3003915839322575]

si= s1.intersectWave(s2)
assert  si.calculateZeros() == [1.1071487177940913, 4.2487413713838844]

#----------------------

r=1
c1= PointND([1,2,3])
c2= PointND([1,4,4])

rigid= RigidGroup()
rigid.addAtom(c1, c1-r, c1+r)
rigid.addAtom(c2, c2-r, c2+r)
rigid.recalculateCenter()

assert rigid.center.c == [1,3,3.5]
assert rigid.atoms[0].position.c == [0,-1,-0.5]

atomsine_calc.addAtomToSines(rigid.atoms[0], 0)
atomsine_calc.addAtomToSines(rigid.atoms[1], 0)
print atomsine_calc.allsines

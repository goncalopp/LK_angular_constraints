from region import Region
from pointnd import PointND
from sine import Sine
from atom import Atom
from rigidgroup import RigidGroup
from orderedlist import *
import atomsine_calc

from math import sqrt, atan2, pi
import Gnuplot
g1 = Gnuplot.Gnuplot()
g2 = Gnuplot.Gnuplot()
g3 = Gnuplot.Gnuplot()


def sineToFunction(sine, xmin=0, xmax=2*pi):
	return  'x>=%f && x<=%f ? (%f*sin(x+%f)+%f) : 1/0'%(xmin, xmax, sine.a, sine.p, sine.y)
	
def plotSineList(gnuplotinstance, sinelist):
	f= ','.join([ sineToFunction(sine) for sine in sinelist])
	gnuplotinstance.plot(f, xrange=['0','2*pi'])
    

def plotAngularDomains(gnuplotinstance, angulardomains):
	f=[]
	for angulardomain in angulardomains:
		for region in angulardomain:
			f.append(sineToFunction(region.value, region[0][0], region[1][0]))
	gnuplotinstance.plot(','.join(f), xrange=['0','2*pi'])





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


#---------------------------------------------------------------

a= PointND([2,2,2])
b= PointND([3,4,5])
s1= Sine.fromPoint(a, b, 0)
s2= Sine.fromPoint(a, b, 1)
s3= Sine.fromPoint(a, b, 2)
assert s1.p == atan2(3,2)
assert s2.p == atan2(1,3)
assert s3.p == atan2(2,1)

assert [p[0] for p in s1.calculateZeros()] == [2.158798930342464, 5.3003915839322575]
si= s1.intersectWave(s2)
assert  [p[0] for p in si.calculateZeros()] == [1.1071487177940913, 4.2487413713838844]
s1.y=1
s1.zeros_calculated=False
assert [p[0] for p in s1.calculateZeros()] == [2.4398338318452781, 5.0193566824294438]


#----------------------------------------------------------


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

#--------------------------------------------------------


r=1
c1= PointND([5.2,4.3,0.4])
c2= PointND([-4.9,0.1,0.2])
c3= PointND([-2.1,4.1,5.1])



rigid= RigidGroup()
rigid.addAtom(c1, c1-1*r, c1+1*r)
rigid.addAtom(c2, c2-1*r, c2+1*r)
rigid.addAtom(c3, c3-1*r, c3+2*r)
rigid.recalculateCenter()


atomsine_calc.reset()
atomsine_calc.addAtomToSines(rigid.atoms[0], 2)
atomsine_calc.addAtomToSines(rigid.atoms[1], 2)
atomsine_calc.addAtomToSines(rigid.atoms[2], 2)


plotSineList(g1, atomsine_calc.allsines[0]+atomsine_calc.allsines[1])


#atomsine_calc.process()
i0=OrderedList(atomsine_calc.intersections[0], keyfunction=lambda x: x.angle)
i1=OrderedList(atomsine_calc.intersections[1], keyfunction=lambda x: x.angle)

atomsine_calc.angulardomains= atomsine_calc.calculate_bound_limits(atomsine_calc.allsines, [i0,i1])

plotAngularDomains(g3, atomsine_calc.angulardomains)

valid=atomsine_calc.validRegions()
valid.mergeAdjacentRegions()

for region in valid:
	print region

plotAngularDomains(g2, atomsine_calc.angulardomains)
#plotAngularDomains(g3, [valid])


#g.reset()
raw_input('Please press return to continue...\n')


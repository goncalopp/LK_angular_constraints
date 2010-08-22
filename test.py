from region import Region
from pointnd import PointND
from sine import Sine
from atom import Atom
from rigidgroup import RigidGroup
import atomsine_calc


from math import sqrt, atan2, pi
import Gnuplot
g1 = Gnuplot.Gnuplot()
g2 = Gnuplot.Gnuplot()

def sineToFunction(sine, xmin=0, xmax=2*pi):
	return  'x>=%f && x<=%f ? (%f*sin(x+%f)+%f) : 1/0'%(xmin, xmax, sine.a, sine.p, sine.y)
	
def plotSineList(gnuplotinstance, sinelist):
	f= ','.join([ sineToFunction(sine) for sine in sinelist])
	gnuplotinstance.plot(f, xrange=['0','2*pi'])
    

def plotSirList(gnuplotinstance, sirlist):
	f= ','.join([ sineToFunction(sir.sine, sir.region[0][0], sir.region[1][0]) for sir in sirlist])
	gnuplotinstance.plot(f, xrange=['0','2*pi'])



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

assert [p[0] for p in s1.calculateZeros()] == [2.158798930342464, 5.3003915839322575]
si= s1.intersectWave(s2)
assert  [p[0] for p in si.calculateZeros()] == [1.1071487177940913, 4.2487413713838844]
s1.y=1
s1.zeros_calculated=False
assert [p[0] for p in s1.calculateZeros()] == [2.4398338318452781, 5.0193566824294438]

#----------------------

r=1
c1= PointND([5,6,7])
c2= PointND([1,2,4])

rigid= RigidGroup()
rigid.addAtom(c1, c1-r, c1+r)
rigid.addAtom(c2, c2-r, c2+r)
rigid.recalculateCenter()

assert rigid.center.c == [3,4,5.5]
assert rigid.atoms[0].position.c == [2,2,1.5]


atomsine_calc.addAtomToSines(rigid.atoms[0], 0)
atomsine_calc.addAtomToSines(rigid.atoms[1], 0)

#import pdb; pdb.set_trace()

atomsine_calc.process()

assert atomsine_calc.sirs[0][0].sine==atomsine_calc.sirs[0][2].sine
print atomsine_calc.validRegions()



plotSineList(g1, atomsine_calc.allsines[0]+atomsine_calc.allsines[1])
plotSirList(g2, atomsine_calc.sirs[0]+atomsine_calc.sirs[1])
#todo represent sir in region

#g.reset()

#print atomsine_calc.allsines

raw_input('Please press return to continue...\n')

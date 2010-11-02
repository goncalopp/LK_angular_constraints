from src.pointnd import PointND
from src.rigidgroup import RigidGroup
from  src import atomsine_calc
from src.orderedlist import OrderedList


from math import sqrt, atan2, pi
import Gnuplot
g1 = Gnuplot.Gnuplot()
g2 = Gnuplot.Gnuplot()

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




#--------------------------------------------------------


from random import random as rd
r=1
rigid= RigidGroup()

for i in xrange(200):
	p= PointND([rd()*20-10, rd()*20-10, rd()*20-10])
	p0= p-PointND([rd()+1, rd()+1, rd()+1])
	p1= p+PointND([rd()+1, rd()+1, rd()+1])
	#rigid.addAtom(p, p0, p1)

c1= PointND([1.0,0.000001,2])
c2= PointND([1.0,3.0,2])
c3= PointND([1.0,3.0,-1])
rigid.addAtom(c1,PointND([0,0,5]),PointND([2,2,8]))
rigid.addAtom(c2,PointND([0,2,5]),PointND([2,4,7]))
rigid.addAtom(c3,PointND([0,4,5]),PointND([2,6,7]))
rigid.recalculateCenter()

for atom in rigid.atoms:
	print atom

#valid from 228.1963o-270.008o, or 3.98266-4.71239 in radians
#5-5.81282
#blender: first atom should be reduced to roughly 6.236-7

tmp= atomsine_calc.do_it(rigid.atoms, 0, debug= True)
plotAngularDomains(g1, tmp[1])
plotSineList(g2, tmp[0][0]+tmp[0][1])
raw_input()

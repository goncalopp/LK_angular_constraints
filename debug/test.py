from src.pointnd import PointND
from src.rigidgroup import RigidGroup
from src.orderedlist import OrderedList
from src.rigidgroup_centerlimits import calculateCenterLimits


from math import sqrt, atan2, pi
import Gnuplot
g1 = Gnuplot.Gnuplot()
g2 = Gnuplot.Gnuplot()
#g1.set_string("nokey")   #remove legend
#g2.set_string("nokey")   #remove legend


def sineToFunction(sine, xmin=0, xmax=2*pi):
	if not sine.cosine:
		return  'x>=%f && x<=%f ? (%f*sin(x+%f)+%f) : 1/0'%(xmin, xmax, sine.a, sine.p, sine.y)
	else:
		return  'x>=%f && x<=%f ? (%f*cos(x+%f)+%f) : 1/0'%(xmin, xmax, sine.a, sine.p, sine.y)
	
def plotSineList(gnuplotinstance, sinelist):
	f= ','.join([ sineToFunction(sine) for sine in sinelist])
	gnuplotinstance.plot(f, xrange=['0','2*pi'])

def printSineList(sinelist):
	f= ','.join([ sineToFunction(sine) for sine in sinelist])
	import os
	os.system('echo "'+f+'" | nc coulter 9999');
	
    

def plotAngularDomains(gnuplotinstance, angulardomains):
	f=[]
	for angulardomain in angulardomains:
		for region in angulardomain:
			f.append(sineToFunction(region.value, region[0][0], region[1][0]))
	gnuplotinstance.plot(','.join(f), xrange=['0','2*pi'])




#--------------------------------------------------------

def rigid1():
	r= RigidGroup()
	p1= PointND([-2,0,0])
	p2= PointND([2,0,0])
	r.addAtom(p1, p1-1, p1+1)
	r.addAtom(p2, p2-1, p2+1)
	return r
	

rigid= rigid1()

sines, angulardomains, validdomains= calculateCenterLimits(rigid, 1, 0, debug= True)

plotAngularDomains(g1, validdomains)
from src.sine import Sine

plotSineList(g2, sines[0]+sines[1])
#g1.hardcopy('gp_test.ps', enhanced=1, color=1)
raw_input()

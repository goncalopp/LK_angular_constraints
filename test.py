from src.pointnd import PointND
from src.rigidgroup import RigidGroup
from  src import atomsine_calc
from src.orderedlist import OrderedList


from math import sqrt, atan2, pi
import Gnuplot
g1 = Gnuplot.Gnuplot()
g2 = Gnuplot.Gnuplot()
#g1.set_string("nokey")   #remove legend
#g2.set_string("nokey")   #remove legend


def sineToFunction(sine, xmin=0, xmax=2*pi):
	return  'x>=%f && x<=%f ? (%f*sin(x+%f)+%f) : 1/0'%(xmin, xmax, sine.a, sine.p, sine.y)
	
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


from random import random as rd
r=1
rigid= RigidGroup()


#-------------

c1= PointND([-2,0,0])
c2= PointND([2,0,0])
rigid.addAtom(c1,c1-1, c1+1)
rigid.addAtom(c2,c2-8,c2+8)
rigid.recalculateCenter()

sines, angulardomains, validdomains= atomsine_calc.do_it(rigid.atoms, 2, debug= True)



plotAngularDomains(g1, validdomains)
plotSineList(g2, sines[0]+sines[1])
#g1.hardcopy('gp_test.ps', enhanced=1, color=1)
raw_input()

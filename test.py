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

for i in xrange(200):
	p= PointND([rd()*20-10, rd()*20-10, rd()*20-10])
	p0= p-PointND([rd()+1, rd()+1, rd()+1])
	p1= p+PointND([rd()+1, rd()+1, rd()+1])
	#rigid.addAtom(p, p0, p1)

#-------------

c1= PointND([-3,0,0])
c2= PointND([3,0,0])
rigid.addAtom(c1,c1-1, c1+1)
rigid.addAtom(c2,c2-9,c2+9)
rigid.recalculateCenter()

#for atom in rigid.atoms:
#	print atom

#valid from 228.1963o-270.008o, or 3.98266-4.71239 in radians
#papel: atomos 2 e 3 amplitude 2; ate 270o certos (atomos 1 e 2 verticais)
#facilita visualizacao a rotacao em torno do atomo 2
#regiao valida tem 2 segmentos:
#	primeiro segmento: limitado por atomos 2-3, amplitude inicial:2, amplitude final: ?
#	segundo  segmento: limitado por atomos 1-2, amplitude inicial:?, amplitude final: 3
#5-5.81282
#blender: first atom should be reduced to roughly 6.236-7

sines, angulardomains, validdomains, newlimits= rigid.solve_instance(2, debug= True)

for i in newlimits:
	print i, newlimits[i]

plotAngularDomains(g1, validdomains)
from src.sine import Sine

plotSineList(g2, sines[0]+sines[1])
#g1.hardcopy('gp_test.ps', enhanced=1, color=1)
raw_input()

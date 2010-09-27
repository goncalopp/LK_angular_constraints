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


r=1
c1= PointND([5.2,4.3,0.4])
c2= PointND([-4.9,0.1,0.2])
c3= PointND([-2.1,4.1,5.1])



rigid= RigidGroup()
rigid.addAtom(c1, c1-1*r, c1+1*r)
rigid.addAtom(c2, c2-1*r, c2+1*r)
rigid.addAtom(c3, c3-1*r, c3+2*r)
rigid.recalculateCenter()


tmp= atomsine_calc.do_it(rigid.atoms, 0, debug=True)

plotSineList(g1, tmp[0][0]+tmp[0][1])
plotAngularDomains(g2, tmp[1])

for region in tmp[2]:
	print region


#g.reset()
raw_input('Please press return to continue...\n')

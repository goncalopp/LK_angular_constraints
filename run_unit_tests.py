from src.region import Region
from src.pointnd import PointND
from src.sine import Sine
from src.atom import Atom
from src.atomsine import AtomSine
from src.rigidgroup import RigidGroup
from src.orderedlist import OrderedList
from src.angulardomain import AngularDomain
from src import atomsine_calc

from math import sqrt, atan2, atan, pi
from os import listdir

def equal(a,b):
	#round to 10 decimal places to prevend rounding errors
	return round(a,10)==round(b,10)

def equal_list(a,b):
	if len(a)!=len(b):
		return False
	return all([equal(x[0],x[1]) for x in zip(a,b)])
	


dir='unit_tests/'
for file in listdir(dir):
	print 'executing '+file+'...'
	execfile(dir+file)
	print 'no errors\n'




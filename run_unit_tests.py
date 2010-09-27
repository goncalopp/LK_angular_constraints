from src.region import Region
from src.pointnd import PointND
from src.sine import Sine
from src.atom import Atom
from src.rigidgroup import RigidGroup
from src.orderedlist import OrderedList
from src.angulardomain import AngularDomain
from src import atomsine_calc

from math import sqrt, atan2, atan, pi
from os import listdir

def equal(a,b):
	#round to 10 decimal places to prevend rounding errors
	return round(a,10)==round(b,10)


dir='unit_tests/'
for file in listdir(dir):
	print 'executing '+file+'...'
	execfile(dir+file)
	print 'no errors\n'




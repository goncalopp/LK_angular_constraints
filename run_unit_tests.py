from src.region import Region
from src.pointnd import PointND
from src.sine import Sine
from src.atom import Atom
from src.rigidgroup import RigidGroup
from src.orderedlist import OrderedList
from src.angulardomain import AngularDomain

from math import sqrt, atan2, atan, pi
from os import listdir

dir='unit_tests/'
for file in listdir(dir):
	print 'executing '+file+'...'
	execfile(dir+file)
	print 'no errors\n'




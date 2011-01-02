from region import Region
from sine import Sine
from pointnd import PointND

class Atom:
	'''this class represents an atom, storing both it's position and it's
	allowed domain'''
	def __init__(self, position, bound1, bound2):
		self.position= position
		self.region= Region(bound1, bound2)
	
	def __repr__(self):
		return '<Atom '+str(self.position)+str(self.region)+'>'

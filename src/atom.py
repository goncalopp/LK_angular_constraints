from region import Region
from sine import Sine
from pointnd import PointND

class Atom:
	def __init__(self, position, bound1, bound2):
		self.position= position
		self.region= Region(bound1, bound2)
	
	def __repr__(self):
		return '<Atom '+str(self.position)+str(self.region)+'>'
	
	def  toSine(self, bound, coordinate):
		s= Sine.fromPoint(self.position, PointND([0,0,0]), coordinate)
		s.y= self.region[bound][(coordinate+2)%3]
		return s

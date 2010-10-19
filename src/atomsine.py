from sine import Sine
from pointnd import PointND

class AtomSine(Sine):
	def __init__(self, atom, bound, coordinate):
		super(AtomSine, self).fromPoint(atom.position, PointND([0,0,0]), coordinate)
		self.y= atom.region[bound][(coordinate+2)%3]
		self.atom=atom		#store the associated atom object

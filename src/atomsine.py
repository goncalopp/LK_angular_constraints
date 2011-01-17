from sine import Sine
from pointnd import PointND

class AtomSine(Sine):
	'''descends from sine, represents the position of a atom's (or it's
	limit) coordinate while it rotates'''
	def __init__(self, atom, coordinate, bound=None):
		super(AtomSine, self).fromPoint(atom.position, PointND([0,0,0]), coordinate)
		self.atom=atom		#store the associated atom object
		if bound!=None:
			self.y= atom.region[bound][(coordinate+2)%3]
	
	@staticmethod
	def atomsineListsFromAtomList(atomlist, coordinate):
		'''given an atom list, gives a tuple of two lists of atomsine;
		the first is the lower bound, the second is the upper bound'''
		return [[AtomSine(atom, coordinate, i) for atom in atomlist] for i in (0,1)]

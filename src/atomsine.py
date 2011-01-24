from sine import Sine
from pointnd import PointND

class AtomSine(Sine):
	'''descends from sine, represents the position of a atom's (or it's
	limit) coordinate while it rotates'''
	def __init__(self, atom, rotation_axis, coordinate, bound=None):
		assert rotation_axis!=coordinate
		is_cosine= ((coordinate-rotation_axis)%3==1)
		super(AtomSine, self).fromPoint(atom.position, PointND([0,0,0]), rotation_axis, is_cosine)
		self.atom=atom		#store the associated atom object
		if bound!=None:
			self.y= atom.region[bound][(rotation_axis+2)%3]
	
	@staticmethod
	def atomsineListsFromAtomList(atomlist, rotation_axis, coordinate):
		'''given an atom list, a rotation axis RA and a coordinate C,
		calculates the sine waves associated with the values of C as the
		origin (0,0,0) rotates (in RA) around each atom;
		in other words, it represents how much the center can be translated
		(in the given coordinate), for each of the atoms. The result is
		given as a tuple with two lists of atomsine; the first is the lower
		bound, the second is the upper bound'''
		
		return [[AtomSine(atom, rotation_axis, coordinate, bound) for atom in atomlist] for bound in (0,1)]

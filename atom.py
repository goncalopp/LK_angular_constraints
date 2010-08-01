from region import Region

class Atom:
	def __init__(self, position, bound1, bound2):
		self.position= position
		self.region= Region(bound1, bound2)

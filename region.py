from pointnd import PointND
class Region:
	def __init__(self, bound0, bound1):
		if bound0<>None and bound1<>None and ((not isinstance(bound0, PointND)) or (not isinstance(bound1, PointND))):
			raise TypeError, "Region must be created with two PointND" 
		self.bounds= [bound0, bound1]
		
	def __getitem__(self, key):
		return self.bounds[key]

	def __setitem__(self, key, value):
		self.bounds[key]=value

	def __iter__(self):
		return self.bounds.__iter__()
		
	def __repr__(self):
		return '<Region '+str(self.bounds)+'>'

	def pointInside(self, point):
		'''returns True iff point is inside region'''
		for i in range(len(self[0])):
			if point[i]<self[0][i] or point[i]>self[1][i]:
				return False
		return True
		
	def pointsInside(self, list):
		'''return a list of the points that are inside the region,
		from a set of given points'''
		return filter(self.pointInside, list)

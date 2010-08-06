class Region:
	def __init__(self, bound0, bound1):
		self.bounds= [bound0, bound1]
		
	def __getitem__(self, key):
		return self.bounds[key]

	def __setitem__(self, key, value):
		self.bounds[key]=value

	def __iter__(self):
		return self.c.__iter__()
		
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
		filter(self.pointInside, list)

from pointnd import PointND
class Region:
	def __init__(self, bound0, bound1=0, v=None):
		if not isinstance(bound0, PointND) or not isinstance(bound1, PointND):
			raise TypeError, "Region must be created with two PointND" 
		self.bounds= [bound0, bound1]
		self.value=v
		
	def __getitem__(self, key):
		return self.bounds[key]

	def __setitem__(self, key, value):
		self.bounds[key]=value

	def __iter__(self):
		return self.bounds.__iter__()
		
	def __repr__(self):
		return '<Region '+str(self.bounds)+'>'

	def pointInsideExcludingBounds(self, point):
		'''returns True iff point is inside region, excluding bounds'''
		return all([point[i]<self[1][i] and point[i]>self[0][i] for i in range(len(self[0]))])

	def pointInsideIncludingBounds(self, point):
		return all([point[i]<=self[1][i] and point[i]>=self[0][i] for i in range(len(self[0]))])

	def pointsInside(self, list):
		'''return a list of the points that are inside the region,
		from a set of given points'''
		return filter(self.pointInsideIncludingBounds, list)

	def __contains__(self, point):
		return self.pointInsideIncludingBounds(point)
	
	def containsRegion(self, region):
		return all([(p in self) for p in region])
		
	def cutOnPoint(self, point):
		'''cuts the region along the Point, gives a list of Regions'''
		if not self.pointInsideExcludingBounds(point):
			return [self]
		return [Region(self[0], PointND(point), self.value),Region(PointND(point), self[1], self.value)]

	def cutOnPoints(self, pointlist):
		regions=self.cutOnPoint(pointlist[0])
		if len(pointlist)==1:
			return regions
		newlist=pointlist[1:]
		final=[]
		for r in regions:
			final+=r.cutOnPoints(newlist)
		return final

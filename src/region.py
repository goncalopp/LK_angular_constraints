from pointnd import PointND
class Region:
	def __init__(self, bound0, bound1=0, value=None):
		if bound0!=None and bound1!=None and (not isinstance(bound0, PointND) or not isinstance(bound1, PointND)):
			raise TypeError, "Region must be created with two PointND" 
		if bound0==bound1:
			raise Exception('Region starts and ends at the same point')
		self.bounds= [bound0, bound1]
		self.value=value
		
	def __getitem__(self, key):
		return self.bounds[key]

	def __setitem__(self, key, value):
		self.bounds[key]=value
		if self[0]==self[1]:
			raise Exception('Region starts and ends at the same point')

	def __iter__(self):
		return self.bounds.__iter__()
		
	def __repr__(self):
		return '<Region '+str(self.bounds)+'>'

	def __eq__(self, other):
		if isinstance(other, Region):
			if self[0]==other[0] and self[1]==other[1]:
					return True
			return False
		return NotImplemented
		
	def __ne__(self, other):
		if isinstance(other, PointND):
			return not self.__eq__(other)
		return NotImplemented
		
	def __cmp__(self, other):
		'''only compares region start'''
		if isinstance(other, Region):
			return cmp(self[0],other[0])
		else:
			return cmp(self[0],other)

	def pointInsideExcludingBounds(self, point):
		'''returns True iff point is inside region, excluding bounds'''
		return all([point[i]<self[1][i] and point[i]>self[0][i] for i in range(len(self[0]))])

	def pointInsideIncludingBounds(self, point):
		return all([point[i]<=self[1][i] and point[i]>=self[0][i] for i in range(len(self[0]))])

	def pointInside(self, point):
		return self.pointInsideIncludingBounds(point)

	def pointsInside(self, list):
		'''return a list of the points that are inside the region,
		from a set of given points'''
		return filter(self.pointInsideIncludingBounds, list)

	def __contains__(self, point):
		return self.pointInsideIncludingBounds(point)
	
	def containsRegion(self, region):
		return all([(p in self) for p in region])
		
	def cutOnPoint(self, point):
		'''cuts the region along the Point, gives a list of Regions.
		Works on one dimension only'''
		if len(self.bounds[0])>1 or len(self.bounds[1])>1:
			raise Exception("Cant cut *multidimentional* Region on Point" )
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

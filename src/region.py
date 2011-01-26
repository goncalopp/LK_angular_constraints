from pointnd import PointND
class Region:
	'''An N-dimensional Region. Optionally holds a value'''
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
		'''returns True iff given point is inside this (open) region'''
		return all([point[i]<self[1][i] and point[i]>self[0][i] for i in range(len(self[0]))])

	def pointInsideIncludingBounds(self, point):
		'''returns true iff given point is inside this (closed) region'''
		return all([point[i]<=self[1][i] and point[i]>=self[0][i] for i in range(len(self[0]))])

	def pointInside(self, point):
		return self.pointInsideIncludingBounds(point)

	def pointsInside(self, list):
		'''return a list of the points that are inside the region,
		from a set of given points'''
		return filter(self.pointInsideIncludingBounds, list)

	def __contains__(self, point):
		return self.pointInsideIncludingBounds(point)
	
	def relativePosition(self, other):
		'''gives the relative position of this (1D) region relative to
		another. return codes:
		1- self starts and ends before other
		2- self starts and ends  after other
		3- self starts before other, other ends after self
		4- other starts before self, self ends after other
		5- self contains other
		6- other contains self
		'''
		if other==None:
			return 1
		if self==None:	#may happen if called as class method
			return 2
		if self[0]<other[0]:
			if self[1]<=other[0]:
				return 1
			if self[1]>=other[1]:
				return 5
			else:
				return 3
		elif self[0]>other[0]:
			if other[1]<self[0]:
				return 2
			if other[1]>=self[1]:
				return 6
			else:
				return 4
		else:				#self[0]==other[0]
			if other[1]<=self[1]:
				return 5
			if other[1]>self[1]:
				return 6
		
	def cutOnPoint(self, point):
		'''cuts the region along the Point, gives a list of Regions.
		Works on one dimension only'''
		if len(self.bounds[0])>1 or len(self.bounds[1])>1:
			raise Exception("Cant cut *multidimentional* Region on Point" )
		if not self.pointInsideExcludingBounds(point):
			return [self]
		return [Region(self[0], PointND(point), self.value),Region(PointND(point), self[1], self.value)]

	def cutOnPoints(self, pointlist):
		'''similar to cutOnPoint, but for a list of cutting points'''
		if len(pointlist)==0:
			return [self]
		regions= self.cutOnPoint(pointlist[0])
		newlist=pointlist[1:]
		return [r.cutOnPoints(newlist) for t in regions]

	def midpoint(self):
		'''the midpoint of the region'''
		return (self[0]+self[1])*0.5

	def intersect(self,other):
		'''intersects this region with another, stores result on itself'''
		if self[0]<other[0]:
			if self[1]>other[1]:					#self contains other
				self[0]= PointND(other[0])
				self[1]= PointND(other[1])
			else:
				self[0]= PointND(other[0])
		else:
			if self[1]>other[1]:
				self[1]= PointND(other[1])
			else:													#other contains self
				pass


from math import pi
from pointnd import PointND
from region import Region
pi2= 2*pi

class AngularDomain:
	'''subdivides the 0--2pi interval into subintervals (regions)'''
	def __init__(self):
		self.regions=[]

	def __getitem__(self, key):
		return self.regions[key]

	def __setitem__(self, key, value):
		self.regions[key]=value

	def __iter__(self):
		return self.regions.__iter__()

	def __len__(self):
		return len(self.regions)

	def __repr__(self):
		s=["-"]*20
		for r in self.regions:
			s[r[0][0]]="|"
			s[r[1][0]]="|"
		return "".join(s)



	def insertRegion(self, region):
		self.regions.append(region)

	def cutRegionOnPoint(self, regionindex, point):
		newregions=self[regionindex].cutOnPoint(point)
		self.regions.pop(regionindex)
		for newregion in newregions:
			self.regions.insert(regionindex, newregion)
			regionindex+=1
		regionindex-=1
		return regionindex


	def doubleCut(self, other, doreverse=True):
		'''takes self and another AngularDomain, and slices both of them
		so that each region on one has an equivalent one on the other
		(the same end points for the region)'''
		otherindex=0
		for r in self[:-1]:
			while otherindex<len(other) and other[otherindex][1]<=r[1]:
				otherindex+=1
			if otherindex<len(other):
				otherindex= other.cutRegionOnPoint(otherindex, r[1])
		if doreverse:
			other.doubleCut(self, doreverse=False)

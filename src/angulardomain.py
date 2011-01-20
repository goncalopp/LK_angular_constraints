from math import pi
from pointnd import PointND
from region import Region
pi2= 2*pi

class AngularDomain:
	'''subdivides the 0--2pi interval into ordered subintervals (regions)'''
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
		s=["-"]*32
		for r in self.regions:
			a=int(r[0][0]*10)
			b=int(r[1][0]*10)
			s[a]="|"
			s[b]="|"
			for i in xrange(a+1,b):
				s[i]=":"
			
		return "".join(s)

	def lookup(self, point):
		'''returns the index of the region on this AngularDomain that contains point'''
		for i,r in enumerate(self.regions):
			if r.pointInside(point):
				return i

	def insertRegion(self, region):
		self.regions.append(region)

	def cutRegionOnPoint(self, regionindex, point):
		'''takes a point and a region index, and cuts the region on that point,
		inserting resulting regions in place''' 
		newregions=self[regionindex].cutOnPoint(point)
		self.regions.pop(regionindex)
		for newregion in newregions:
			self.regions.insert(regionindex, newregion)
			regionindex+=1
		regionindex-=1
		return regionindex


	def doubleCut(self, other, doreverse=True):
		'''takes self and another AngularDomain, and slices both of them,
		i.e.: cuts each region in the endpoints of the other AngularDomains
		regions, i.e.: ater this operation, for each region R1 in one
		AngularDomain, if there exists an Region R2 in the other so that R1
		contains R2 or R2 contains R1, the endpoints of R1 and R2 are the
		same.'''
		i,j= 0,0
		while i<len(self) and j<len(other):
			p= Region.relativePosition(self[i],other[j])
			if p==1:
				i+=1
			elif p==2:
				j+=1
			elif p==3:
				self.cutRegionOnPoint(i, other[j][0])
				i+=1
				other.cutRegionOnPoint(j, self[i][1])
				j+=1
			elif p==4:
				other.cutRegionOnPoint(j, self[i][0])
				j+=1
				self.cutRegionOnPoint(i, other[j][1])
				i+=1
			elif p==5:
				i= self.cutRegionOnPoint(i, other[j][0])
				i= self.cutRegionOnPoint(i, other[j][1])
				j+=1
			elif p==6:
				j= other.cutRegionOnPoint(j, self[i][0])
				j= other.cutRegionOnPoint(j, self[i][1])
				i+=1
		#if doreverse:
		#	other.doubleCut(self, doreverse=False)

	def doublecutIterator(self,other):
		'''iterates over two doublecut AngularDomain, giving tuples of
		either (r1,r2), (r1,None) or (None, r2), r1 belonging to self, r2
		belonging to the other AngularDomain'''
		i,j= 0,0
		while i<len(self) or j<len(other):
			if i>=len(self) or (self[i][0]>other[j][0] and self[i][1]>other[j][1]):
				yield (None, other[j])
				j+=1
			elif j>=len(other) or self[i][0]<other[j][0]:
				yield (self[i], None)
				i+=1
			elif self[i][0]==other[j][0]:
				if self[i][1]!=other[j]:
					raise Exception("The given AngularDomains are not doublecut")
				yield (self[i], other[j])
				i+=1
				j+=1
			else:
				raise Exception("The given AngularDomains are not doublecut")
		

	def intersect(self, other):
		'''takes self and other AngularDomain and removes from both the
		region "pieces" that don't belong to both, i.e.: after this
		operation, both AngularDomains become their intersection'''
		self.doubleCut(other)
		self_removals, other_removals= [],[]
		i,j= 0,0
		for a,b in self.doublecutIterator(other):
			if a==None:
				other_removals.append(j)
				j+=1
			elif b==None:
				self_removals.append(i)
				i+=1
			else:
				i+=1
				j+=1

		print self_removals
		print other_removals
		self.removeIndexes(self_removals)
		other.removeIndexes(other_removals)

	def removeIndexes(self, index_list):
		i=0
		for index in index_list:
			self.regions.pop(index-i)
			i+=1
		
	def mergeAdjacentRegions(self):
		'''joins adjacent regions'''
		i=0
		while i+1<len(self.regions):
			r1= self.regions[i]
			r2= self.regions[i+1]
			if r1[1]==r2[0]:
				r1[1]=r2[1]
				self.regions.pop(i+1)
			else:
				i+=1

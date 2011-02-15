from math import sqrt, atan2, sin, cos

class PointND:
	'''Represents a N-Dimentional point, where N is arbitrary.'''
	def __init__(self, cl):
		if isinstance(cl, PointND): #make clone
			self.c= cl.c[:]
			return
		if not getattr(cl, '__iter__', False):
			raise TypeError, "PointND must be created with a *list* of coordinates"
		if len(cl)<1:
			raise Exception("Can't create a PointND with 0 coordinates")
		if not type(cl[0])==type(1.0) and not type(cl[0])==type(1):
			raise TypeError, "PointND must be created with a list of *float* or *int*"
		self.c= cl
	
	def __len__(self):
		return len(self.c)

	def __getitem__(self, key):
		return self.c[key]

	def __setitem__(self, key, value):
		self.c[key]=value

	def __iter__(self):
		return self.c.__iter__()
		
	def __repr__(self):
		return '<PointND '+str(self.c)+'>'
	
	def __iadd__(self, op):
		if type(op) == type(self):
			self.c= [self.c[i] + op[i] for i in range(len(self.c))]
		else:
			self.c= [n+op for n in self.c]
		return self
	
	def __isub__(self, op):
		if type(op) == type(self):
			self.c= [self.c[i]-op[i] for i in range(len(self.c))]
		else:
			self.c= [n-op for n in self.c]
		return self
		
	def __imul__(self, op):
		if type(op) == type(self):
			self.c= [self.c[i]*op[i] for i in range(len(self.c))]
		else:
			self.c= [n*op for n in self.c]
		return self
			
	def __add__(self, op):
		return PointND(self).__iadd__(op)
		
	def __sub__(self, op):
		return PointND(self).__isub__(op)
		
	def __mul__(self, op):
		return PointND(self).__imul__(op)

	def __eq__(self, other):
		if isinstance(other, PointND):
			if len(self)!=len(other):
				return False
			for i in range(len(self)):
				if self[i]<>other[i]:
					return False
			return True
		return NotImplemented
		
	def __ne__(self, other):
		if isinstance(other, PointND):
			return not self.__eq__(other)
		return NotImplemented
		
	def __cmp__(self, other):
		if isinstance(other, PointND):
			if len(self)>1 or len(other)>1:
					raise Exception('Trying to compare PointNDs with more than one coordinate')
			return cmp(self[0],other[0])
		else:
			return cmp(self[0],other)
	
	
	def norm(self):
		'''returns the norm of the vector this point forms with the origin'''
		return sqrt(sum(n*n for n in self.c))
	
	def distance(self, other):
		'''returns the euclidian distance to another PointND'''
		return (self-other).norm()
	
	def angle(self):
		'''Returns angle point-origin makes with x-axis. point must be 2D.'''
		return atan2(self.c[1], self.c[0])
	
	def project(self, coordinate):
		'''projects a N-dimentional point over a coordinate ("ortographic").
		Example: projecting point (3,5,1) over coordinate (1) (y-plane) gives (1,3)'''
		c= self.c
		n= coordinate
		self.c= c[n+1:]+c[:n]
		return self
	
	def deproject(self, coordinate, value):
		'''De-projects a pointND, given the value of the projected coordinate.
		Example: let p be a 3D PointND;   p == p.project(1).deproject(1,5)'''
		c= self.c
		n= len(c)-coordinate
		self.c= c[n:]+[value]+c[:n]
		return self

	def rotate2D(self, angle):
		'''rotates 2D point over origin'''
		s,c= sin(angle), cos(angle)
		tmp= self[0]*s+self[1]*c
		self[0]= self[0]*c-self[1]*s
		self[1]= tmp
	
	def rotateOver2D(self, otherpoint, angle):
		'''rotates 2D point over another 2D point'''
		self-= otherpoint
		self.rotate2D(angle)
		self+= otherpoint
		
	
	def rotate3D(self, rotationaxis, angle):
		'''rotate 3D point over rotationaxis'''
		tmp= self[rotationaxis]
		self.project(rotationaxis)
		self.rotate2D(angle)
		self.deproject(rotationaxis, tmp)
	
	def rotateOver3D(self, otherpoint, rotationaxis, angle):
		'''rotate 3D point over another 3D point, along an axis'''
		self-= otherpoint
		self.rotate3D(rotationaxis, angle)
		self+=otherpoint




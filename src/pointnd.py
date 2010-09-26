from math import sqrt, atan2, sin, cos

class PointND:
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
		self.c= cl[:]
	
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
		 return sqrt(sum(n*n for n in self.c))
		 
	def distance(self, point):
		tmp= PointND(self)
		tmp-point
		return tmp.norm()
		
	def rotateOver3D(rotationaxis, point, angle):
		ce=  rotationaxis   #excluded coordinate
		c0=  (ce+1) % 3;  #first coordinate to process
		c1=  (ce+2) % 3;  #second coordinate to process

		vector=  PointND(self)
		vector-=	point
		vector[ce]= 0;				#project the vector into the plane of rotation...
		d=		vector.norm();		  #so we can calculate the distance in the plane
		current_angle= atan2(vector[c1], vector[c0])

		self[c0]=   point[c0]+d*cos(current_angle+angle)
		self[c1]=   point[c1]+d*sin(current_angle+angle)


	def rotate3D(rotationaxis, angle):
		origin= PointND(0,0,0)
		rotateOver3D(rotationaxis, origin, angle)

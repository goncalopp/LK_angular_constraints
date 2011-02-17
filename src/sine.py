from pointnd import PointND
from math import pi,atan2,asin, sin, cos, sqrt
pi2= 2*pi

class Sine(object):
	'''Represents a sine wave of fixed frequency 1/(2*pi)'''
	def __init__(self, amplitude=1.0, phase=0.0, y=0.0, cosine=False):
		if isinstance(amplitude, Sine):		#cloning...
			self.a= amplitude.a
			self.p= amplitude.p
			self.y= amplitude.y
			self.cosine= amplitude.cosine
		else:															#creating new
			self.a= amplitude
			self.p= phase
			self.y= y
			self.cosine= cosine
		self.zeros=[]
		self.zeros_calculated= False
		self.simplifyPhase()
		
	def __repr__(self):
		if not self.cosine:
			return '<Sine a=%f p=%f y=%f>'%(self.a, self.p, self.y)
		else:
			return '<coSine a=%f p=%f y=%f>'%(self.a, self.p, self.y)
		
	def simplifyPhase(self):
		self.p%= pi2;
	
	def invert(self):
		self.p= (self.p + pi) % pi2
		self.y=-self.y
	
	def __iadd__(self, other):
		undo_sinification_on= None
		if self.cosine ^ other.cosine:	#xor
			undo_sinification_on= (self if self.cosine else other)
			undo_sinification_on.sinificy()
			
		y= self.a*sin(self.p)+other.a*sin(other.p)
		x= self.a*cos(self.p)+other.a*cos(other.p)
		self.a=  sqrt(x*x + y*y)
		self.p=  atan2(y,x)
		self.y+= other.y

		if undo_sinification_on!=None:
			undo_sinification_on.cosinificy()
		return self
	
	def __isub__(self, other):
		self.invert()
		self+= other
		self.invert()
		return self
	
	def __add__(self, other):
		return Sine(self).__iadd__(other)
	
	def __sub__(self, other):
		return Sine(self).__isub__(other)


	def valueat(self, angle):
		if not self.cosine:
			return self.a*sin(angle+self.p)+self.y;
		else:
			return self.a*cos(angle+self.p)+self.y;

	def calculateZeros(self):
		if self.zeros_calculated:
			return self.zeros
		else:
			
			self.zeros_calculated=True
			self.simplifyPhase();
			try:
				tmp=asin(self.y/self.a);
			except:
				self.zeros= []
				return []
			
			if not self.cosine:
				z0= (pi  + tmp - self.p) % pi2
				z1= (pi2 - tmp - self.p) % pi2
			else:
				z0= (pi/2  + tmp - self.p) % pi2
				z1= (pi2 - pi/2 - tmp - self.p) % pi2
				
			if abs(z0-z1) < 1e-10:
				self.zeros=[PointND([min(z0,z1)])]
			elif z0<z1:
				self.zeros= [PointND([z0]),PointND([z1])]
			else:
				self.zeros= [PointND([z1]),PointND([z0])]
			return self.zeros

	def getMaximizant(self):
		if not self.cosine:
			return (pi/2 - self.p)%pi2
		else:
			return (-self.p)%pi2
			
	def getMinimizant(self):
		if not self.cosine:
			return (3*pi/2 - self.p)%pi2
		else:
			return (pi - self.p)%pi2
	
	
	def fromPoint(self, origin, point1, rotation_axis, cosine=False):
		'''given two 3D PointND, origin and point1, and a rotation
		axis, calculates the sine that represents the variation of the
		y-coordinate(sine) of point1 as it rotates (in the rotation_axis)
		around origin .If "cosine" option is True, calculates the
		x-coordinate(cosine) instead'''
		if origin!=None:
			vector= point1-origin
		else:
			vector= PointND(point1)
		vector.project(rotation_axis)
		self.a= vector.norm()
		self.p= vector.angle()
		self.cosine= cosine
		self.y=0
		self.zeros=[]
		self.zeros_calculated= False
		self.simplifyPhase()
		return self			# so we can do "new_s= Sine().fromPoint()"

	def minInRegion(self,region):
		'''returns the minimum value this sine takes inside a 1D region.
		assumes region is inside 0--2pi region'''
		angles= [region[0][0], region[1][0]]
		m= self.getMinimizant()
		if PointND([m]) in region:
			angles.append(m)
		return min(map(self.valueat, angles))
	
	def maxInRegion(self, region):
		'''similar to minInRegion, for maximum'''
		angles= [region[0][0], region[1][0]]
		m= self.getMaximizant()
		if PointND([m]) in region:
			angles.append(m)
		return max(map(self.valueat, angles))
		
	def sinificy(self):
		'''turns a cosine into a sine, without changing the image of an \
		angle (changes phase)'''
		if not self.cosine:
			raise Exception("Can't sinificy a sine")
		self.p+= pi/2
		self.simplifyPhase
		self.cosine= False
	
	def cosinificy(self):
		'''turns a sine into a cosine, without changing the image of an \
		angle (changes phase)'''
		if self.cosine:
			raise Exception("Can't cosinificy a cosine")
		self.p-= pi/2
		self.simplifyPhase
		self.cosine= True

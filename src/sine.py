from pointnd import PointND
from math import pi,atan2,asin, sin, cos, sqrt
pi2= 2*pi

class Sine(object):
	def __init__(self, amplitude=1.0, phase=0.0, y=0.0):
		if isinstance(amplitude, Sine):		#cloning...
			self.a= amplitude.a
			self.p= amplitude.p
			self.y= amplitude.y
		else:															#creating new
			self.a= amplitude
			self.p= phase
			self.y= y
		self.zeros=[]
		self.zeros_calculated= False
		self.simplifyPhase()
		
	def __repr__(self):
		return '<Sine a=%f p=%f y=%f>'%(self.a, self.p, self.y)
		
	def simplifyPhase(self):
		self.p%= pi2;
	
	def invert(self):
		self.p= (self.p + pi) % pi2
		self.y=-self.y
	
	def __iadd__(self, other):
		y= self.a*sin(self.p)+other.a*sin(other.p)
		x= self.a*cos(self.p)+other.a*cos(other.p)
		self.a= sqrt(x*x + y*y)
		self.p= atan2(y,x)
		self.y+= other.y
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
		return self.a*sin(angle+self.p)+self.y;

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
			
			z0= (pi  + tmp - self.p) % pi2
			z1= (pi2 - tmp - self.p) % pi2
			if z0<z1:
				self.zeros= [PointND([z0]),PointND([z1])]
			else:
				self.zeros= [PointND([z1]),PointND([z0])]
			return self.zeros

	def getMaximizant(self):
		return (pi/2 - self.p)%pi2
	def getMinimizant(self):
		return (3*pi/2 - self.p)%pi2
	
	
	
	def fromPoint(self, origin, point1, rotation_axis):
		'''given two 3D PointND, origion and point1, and a projection
		axis, projects the points and calculates the sine that 
		represents the variation of y-coordinate(sine) of point1 as it
		rotates around origin'''
		vector= point1-origin
		vector.project(rotation_axis)
		self.a= vector.norm()
		self.p= vector.angle()
		self.y=0
		self.zeros=[]
		self.zeros_calculated= False
		self.simplifyPhase()

	def minInRegion(self,region):
		angles= [region[0][0], region[1][0]]
		m= self.getMinimizant()
		if PointND([m]) in region:
			angles.append(m)
		return min(map(self.valueat, angles))
	
	def maxInRegion(self, region):
		angles= [region[0][0], region[1][0]]
		m= self.getMaximizant()
		if PointND([m]) in region:
			angles.append(m)
		return max(map(self.valueat, angles)) 

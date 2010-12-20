from pointnd import PointND
from math import pi,atan2,asin, sin, cos, sqrt
pi2= 2*pi

class Sine(object):
	def __init__(self, amplitude=1.0, phase=0.0, y=0.0):
		self.a= amplitude
		self.p= phase
		self.y= y
		self.zeros=[]
		self.zeros_calculated= False
		
	def __repr__(self):
		return '<Sine a=%f p=%f y=%f>'%(self.a, self.p, self.y)
		
	def simplifyPhase(self):
		self.p%= pi2;

	def invert(self):
		self.p= (self.p + pi) % pi2
		self.y=-self.y
		
	def addwave(self, sine):
		y= self.a*sin(self.p)+sine.a*sin(sine.p)
		x= self.a*cos(self.p)+sine.a*cos(sine.p)
		newa= sqrt(x*x + y*y)
		newp= atan2(y,x)
		newy= sine.y+self.y
		newsine= Sine(newa, newp, newy)
		return newsine
		
	def intersectWave(self, sine):
		self.invert()
		newsine= self.addwave(sine)
		self.invert()
		return newsine

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

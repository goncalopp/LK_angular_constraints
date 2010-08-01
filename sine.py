from math import pi,atan2,asin, sin, cos, sqrt
pi2= 2*pi

class Sine:
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
		
	def addwave(self, sine):
		y= self.a*sin(self.p)+sine.a*sin(sine.p)
		x= self.a*cos(self.p)+sine.a*cos(sine.p)
		newa= sqrt(x*x + y*y)
		newp= atan2(y,x)
		newy= -sine.y+self.y
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
				self.zeros= [z0,z1]
			else:
				self.zeros= [z1,z0]
			return self.zeros
			
	@staticmethod
	def fromPoint(origin, point1, rotation_axis):
		'''given two 3D PointND, origion and point1, and a projection
		axis, projects the points and calculates the sine that 
		represents the variation of y-coordinate(sine) of point1 as it
		rotates around origin'''
		tmp= point1-origin
		tmp[rotation_axis]=0
		a= tmp.norm()
		p= atan2(tmp[(rotation_axis+2)%3], tmp[(rotation_axis+1)%3])
		y=0
		s= Sine(a,p,y)
		s.simplifyPhase()
		return s

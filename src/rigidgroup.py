from pointnd import PointND
from atom import Atom
from math import pi, trunc

class RigidGroup:
	'''Represents a rigid group of atoms'''
	def __init__(self):
		self.center= PointND([0,0,0])
		self.atoms=[]
    
	def addAtom(self, position, lowerlimit, upperlimit):
		position-=		self.center	#
		lowerlimit-=	self.center	#transform in local coordinates
		upperlimit-=	self.center	#
		self.atoms.append(Atom(position, lowerlimit, upperlimit))                                                                       

	def recalculateCenter(self):
		sum= PointND([0,0,0])
		for atom in self.atoms:
			sum+=atom.position
		sum*= 1.0/len(self.atoms)
		translation= PointND(sum)
		translation-= self.center
		self.center= sum
		for atom in self.atoms:
			atom.position-=translation
			atom.region.bounds[0]-=translation;
			atom.region.bounds[1]-=translation;

	def rotateOver(self, rotationaxis, angle):
		for atom in self.atoms:
			atom.position.rotate3D(rotationaxis, angle)

	def calculateCenterRegion(self, x_angle_step, y_angle_step):
		centerRegion= Region(PointND(-10e9, -10e9, -10e9), PointND(10e9, 10e9, 10e9))
		y_steps= trunc((2*pi) / y_angle_step)
		x_steps=trunc( pi/x_angle_step )   #no need to do 360 to cover 3D space, only 180
		for x in range(x_steps):
			self.rotateOver(0, x_angle_step);
			for y in range(y_steps):
				self.rotateOver(1, y_angle_step)
				for atom in self.atoms:
					pass
					


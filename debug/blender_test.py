'''
#Run this in blender:
import sys
import Blender
sys.path.append('/home/goncalopp/angular_constraints')
Blender.Run('/home/goncalopp/angular_constraints/blender_test.py')
'''


import Blender
import random
import time
from src.pointnd import PointND
from src.rigidgroup import RigidGroup

def atomToBlenderObjects(atom):
	s = Blender.Mesh.Primitives.UVsphere(6,6,0.2)
	s_obj = Blender.Object.New('Mesh')
	s_obj.link(s)
	d = Blender.Mesh.Primitives.Cube(1)
	d_obj = Blender.Object.New('Mesh')
	d_obj.link(d)
	s_obj.setLocation(*atom.position[:])
	d_obj.setLocation(*((atom.region[0]+atom.region[1])*0.5))
	d_obj.setSize(*(atom.region[1]-atom.region[0]))
	
	return s_obj, d_obj

r=1
c1= PointND([5.2,4.3,0.4])
c2= PointND([-4.9,0.1,0.2])
c3= PointND([-2.1,4.1,5.1])

rigid= RigidGroup()
rigid.addAtom(c1, c1-1*r, c1+1*r)
rigid.addAtom(c2, c2-1*r, c2+1*r)
rigid.addAtom(c3, c3-1*r, c3+1*r)
rigid.recalculateCenter()



blender_atoms= [atomToBlenderObjects(atom) for atom in rigid.atoms]

sce = Blender.Scene.GetCurrent()
for a,b in blender_atoms:
	sce.link(a)
	sce.link(b)
	

Blender.Redraw()

tmp= atomsine_calc.do_it(rigid.atoms, 0, debug=False)



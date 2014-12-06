from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
import math
rt2 = math.sqrt(2)
rt3 = math.sqrt(3)

def displayInit():
    pass

def displayFun():
    glClearColor(1.0,1.0,1.0,0.0)
    glClear(GL_COLOR_BUFFER_BIT)
    glLoadIdentity()
    glMatrixMode(GL_PROJECTION)
    height = glutGet(GLUT_WINDOW_HEIGHT)
    width = glutGet(GLUT_WINDOW_WIDTH)
    aspect = float(width)/height
    glOrtho(-aspect,aspect,-1.0,1, -1.0,1.0)
    glColor3f(0.0,0.0, 1.0)

    glBegin(GL_TRIANGLE_FAN)
    
    glColor3d(1,1,1)
    glVertex2f(0,(1/rt3)-1)

    glColor3d(0,1,0)
    glVertex2f(0,rt3-1)

    glColor3d(1,0,0)
    glVertex2f(-1,-1)

    glColor3d(0,0,1)
    glVertex2f(1,-1)

    glColor3d(0,1,0)
    glVertex2f(0,rt3-1)

    glEnd()

    glFlush()

if __name__ == '__main__':
    glutInit()
    glutInitWindowSize(640,480)
    glutCreateWindow("RGBTriangle")
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB)
    glutDisplayFunc(displayFun)
    #displayInit()
    glutMainLoop()

//
//  MyOpenGLView.m
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/25.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyOpenGLView.h"
#import <OpenGL/gl.h>
// #import <OpenGL/glu.h>

@implementation MyOpenGLView

- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // initialize
    }
    return self;
}
// xibにViewを配置しているときはinitWithFrameが呼ばれないので注意
- (void)awakeFromNib
{
    NSLog(@"initialize");
    rectWidth = [self frame].size.width;
    rectHeight = [self frame].size.height;
}

- (void)drawRect:(NSRect)rect {
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f); // default background color
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // View Transform
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    // Modeling Transform
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    
    [self drawAxes];
    [self drawSceneX:0.0f Y:0.0f];
    glFlush();
}

- (void)reWriteX:(float)x Y:(float)y
{
    if (count > 2){
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f); // default background color
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
        [self drawAxes];
        [self drawSceneX:x Y:y];
        glFlush();
        //NSLog(@"rewrite");
        count = 0;
    } else{
        count++;
    }
}

- (void)reshape
{
    int width = [self frame].size.width;
    int height = [self frame].size.height;
    // view port transform
    glViewport(0, 0, width, height);
    // projection transform
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity(); // default
}

- (void)drawAxes
{
    glColor3f(0.8f, 0.8f, 0.8f);
    // Draw axes
    glBegin(GL_LINES);
    {
        glVertex3f(0.0f, 1.0f, 0.0f);
        glVertex3f(0.0f, -1.0f, 0.0f);
        glVertex3f(1.0f, 0.0f, 0.0f);
        glVertex3f(-1.0f, 0.0f, 0.0f);
    }
    glEnd();
}

- (void)drawSceneX:(float)x Y:(float)y
{
    float r = 0.08;
    int n = 10;
    
    glColor4f(1.0f, 0.0f, 0.0f, 0.5f);
    
    //draw circle that indicates COG
    glBegin(GL_POLYGON);
    for (int i = 0; i <= n; i++)
    {
        glVertex3f(  r*cos(2*M_PI/n*i)*rectHeight/rectWidth + x, r*sin(2*M_PI/n*i) + y, 0.0f);
    }
    glEnd();
    
    float racketHeight = 0.1;
    float racketWidth = 0.1;
    
    glColor4f(0.0f, 0.0f, 1.0f, 0.2f);
    glBegin(GL_LINES);
    {
        glVertex3f( x + racketWidth/2, racketHeight/2 , 0.0f);
        glVertex3f( x + racketWidth/2, -racketHeight/2 , 0.0f);
        glVertex3f( x + racketWidth/2, -racketHeight/2 , 0.0f);
        glVertex3f( x - racketWidth/2, -racketHeight/2 , 0.0f);
        glVertex3f( x - racketWidth/2, -racketHeight/2 , 0.0f);
        glVertex3f( x - racketWidth/2, racketHeight/2 , 0.0f);
        glVertex3f( x - racketWidth/2, racketHeight/2 , 0.0f);
        glVertex3f( x + racketWidth/2, racketHeight/2 , 0.0f);
    }
    glEnd();
}

@end
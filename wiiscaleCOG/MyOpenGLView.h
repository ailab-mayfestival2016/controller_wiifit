//
//  MyOpenGLView.h
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/25.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//

#ifndef MyOpenGLView_h
#define MyOpenGLView_h

#import <AppKit/AppKit.h>

/*
typedef struct{
    float x, y;
}fPoint;
*/
@interface MyOpenGLView : NSOpenGLView{
    int count;  // in order to reduce OpengGL drawing
    int rectWidth;
    int rectHeight;
}


- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format;
- (void)awakeFromNib;
- (void)drawRect:(NSRect)rect;
- (void)reWriteX:(float)x Y:(float)y;
- (void)reshape;
- (void)drawAxes;
- (void)drawSceneX:(float)x Y:(float)y;
@end

#endif /* MyOpenGLView_h */

//
//  Terrain.h
//  TinyAstro
//
//  Created by Betsy Serrano on 3/6/14.
//  Copyright 2014 XaevenCorp. All rights reserved.
//
#import "GLES-Render.h"

@class HelloWorldLayer;

@interface Terrain : CCNode
{
    
}

@property (retain) CCSprite * stripes;

-(void)setOffsetX:(float)newOffsetX;

@end

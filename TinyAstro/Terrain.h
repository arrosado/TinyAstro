//
//  Terrain.h
//  TinyAstro
//
//  Created by Betsy Serrano on 3/6/14.
//  Copyright 2014 XaevenCorp. All rights reserved.
//
#import "Box2D.h"

@class HelloWorldLayer;

@interface Terrain : CCNode
{
    
}

@property (retain) CCSprite * stripes;
@property (retain) CCSpriteBatchNode * batchNode;

-(id)initWithWorld:(b2World *)world;
-(void)setOffsetX:(float)newOffsetX;

@end

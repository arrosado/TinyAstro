//
//  Hero.h
//  TinyAstro
//
//  Created by Betsy Serrano on 3/6/14.
//  Copyright 2014 XaevenCorp. All rights reserved.
//
#import "Box2D.h"

@interface Hero : CCSprite

- (id)initWithWorld:(b2World *)world;
- (void)update;

@end

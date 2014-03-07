//
//  Hero.h
//  TinyAstro
//
//  Created by Betsy Serrano on 3/6/14.
//  Copyright 2014 XaevenCorp. All rights reserved.
//
#import "Box2D.h"

@interface Hero : CCSprite

@property (readonly) BOOL awake;
- (void)wake;
- (void)dive;
- (void)limitVelocity;
- (id)initWithWorld:(b2World *)world;
- (void)update;
- (void)nodive;
- (void)runForceAnimation;
- (void)runNormalAnimation;

@end

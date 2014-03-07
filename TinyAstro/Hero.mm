//
//  Hero.m
//  TinyAstro
//
//  Created by Betsy Serrano on 3/6/14.
//  Copyright 2014 XaevenCorp. All rights reserved.
//

#import "Hero.h"
#import "HelloWorldLayer.h"

@interface Hero() {
    b2World * _world;
    b2Body * _body;
    BOOL _awake;
}
@end

@implementation Hero

- (void)createBody {
    
    float radius = 16.0f;
    CGSize size = [[CCDirector sharedDirector] winSize];
    int screenH = size.height;
    
    CGPoint startPosition = ccp(0, screenH/2+radius);
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.1f;
    bd.fixedRotation = true;
    bd.position.Set(startPosition.x/PTM_RATIO, startPosition.y/PTM_RATIO);
    _body = _world->CreateBody(&bd);
    
    b2CircleShape shape;
    shape.m_radius = radius/PTM_RATIO;
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f / CC_CONTENT_SCALE_FACTOR();
    fd.restitution = 0.0f;
    fd.friction = 0.2;
    
    _body->CreateFixture(&fd);
    
}
- (void) wake {
    _awake = YES;
    _body->SetActive(true);
    _body->ApplyLinearImpulse(b2Vec2(1,2), _body->GetPosition());
}

- (void) dive {
    _body->ApplyForce(b2Vec2(5,-50),_body->GetPosition());
}

- (void) limitVelocity {
    if (!_awake) return;
    
    const float minVelocityX = 5;
    const float minVelocityY = -40;
    b2Vec2 vel = _body->GetLinearVelocity();
    if (vel.x < minVelocityX) {
        vel.x = minVelocityX;
    }
    if (vel.y < minVelocityY) {
        vel.y = minVelocityY;
    }
    _body->SetLinearVelocity(vel);
}

- (id)initWithWorld:(b2World *)world {
    
    if ((self = [super initWithSpriteFrameName:@"seal1.png"])) {
        _world = world;
        [self createBody];
    }
    return self;
    
}

- (void)update {
    
    self.position = ccp(_body->GetPosition().x*PTM_RATIO, _body->GetPosition().y*PTM_RATIO);
    b2Vec2 vel = _body->GetLinearVelocity();
    b2Vec2 weightedVel = vel;
    float angle = ccpToAngle(ccp(vel.x, vel.y));
    if (_awake) {
        self.rotation = -1 * CC_RADIANS_TO_DEGREES(angle);
    }
}

@end
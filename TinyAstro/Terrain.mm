#import "HelloWorldLayer.h"
#import "Terrain.h"

#define kMaxHillKeyPoints 1000

@interface Terrain() {
    int _offsetX;
    CGPoint _hillKeyPoints[kMaxHillKeyPoints];
    CCSprite *_stripes;
}
@end

@implementation Terrain

-(void)generateHills {
    CGSize winSize  = [CCDirector sharedDirector].winSize;
    float x = 0;
    float y = winSize.height/2;
    for(int i =0; i < kMaxHillKeyPoints; ++i)
    {
        _hillKeyPoints[i] = CGPointMake(x, y);
        x += winSize.width/2;
        y = (random() % (int)winSize.height);
    }
}

-(id)init {
    if ((self = [super init])) {
        [self generateHills];
    }
    return self;
}

-(void)draw {
    for(int i = 1; i < kMaxHillKeyPoints; ++i) {
        ccDrawLine(_hillKeyPoints[i-1], _hillKeyPoints[i]);
    }
}

- (void) setOffsetX:(float)newOffsetX {
    _offsetX = newOffsetX;
    self.position = CGPointMake(-_offsetX*self.scale, 0);
}

- (void)dealloc {
    [_stripes release];
    _stripes = NULL;
    [super dealloc];
}

@end

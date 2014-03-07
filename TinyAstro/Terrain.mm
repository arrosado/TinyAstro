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

- (void) generateHills {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    float minDX = 160;
    float minDY = 60;
    int rangeDX = 80;
    int rangeDY = 40;
    
    float x = -minDX;
    float y = winSize.height/2;
    
    float dy, ny;
    float sign = 1; // +1 - going up, -1 - going  down
    float paddingTop = 20;
    float paddingBottom = 20;
    
    for (int i=0; i<kMaxHillKeyPoints; i++) {
        _hillKeyPoints[i] = CGPointMake(x, y);
        if (i == 0) {
            x = 0;
            y = winSize.height/2;
        } else {
            x += rand()%rangeDX+minDX;
            while(true) {
                dy = rand()%rangeDY+minDY;
                ny = y + dy*sign;
                if(ny < winSize.height-paddingTop && ny > paddingBottom) {
                    break;
                }
            }
            y = ny;
        }
        sign *= -1;
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

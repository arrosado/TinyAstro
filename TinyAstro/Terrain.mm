#import "HelloWorldLayer.h"
#import "Terrain.h"

#define kMaxHillKeyPoints 1000
#define kHillSegmentWidth 10

@interface Terrain() {
    int _offsetX;
    CGPoint _hillKeyPoints[kMaxHillKeyPoints];
    CCSprite *_stripes;
    int _fromKeyPointI;
    int _toKeyPointI;
}
@end

@implementation Terrain

- (void)resetHillVertices {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    static int prevFromKeyPointI = -1;
    static int prevToKeyPointI = -1;
    
    // key points interval for drawing
    while (_hillKeyPoints[_fromKeyPointI+1].x < _offsetX-winSize.width/8/self.scale) {
        _fromKeyPointI++;
    }
    while (_hillKeyPoints[_toKeyPointI].x < _offsetX+winSize.width*12/8/self.scale) {
        _toKeyPointI++;
    }
    
}

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
        [self resetHillVertices];
    }
    return self;
}

-(void)draw {
    for(int i = MAX(_fromKeyPointI, 1); i <= _toKeyPointI; ++i) {
        ccDrawColor4F(1.0, 0, 0, 1.0);
        ccDrawLine(_hillKeyPoints[i-1], _hillKeyPoints[i]);
        
        ccDrawColor4F(1.0, 1.0, 1.0, 1.0);
        
        CGPoint p0 = _hillKeyPoints[i-1];
        CGPoint p1 = _hillKeyPoints[i];
        int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
        float dx = (p1.x - p0.x) / hSegments;
        float da = M_PI / hSegments;
        float ymid = (p0.y + p1.y) / 2;
        float ampl = (p0.y - p1.y) / 2;
        
        CGPoint pt0, pt1;
        pt0 = p0;
        for (int j = 0; j < hSegments+1; ++j) {
            
            pt1.x = p0.x + j*dx;
            pt1.y = ymid + ampl * cosf(da*j);
            
            ccDrawLine(pt0, pt1);
            
            pt0 = pt1;   
        }
    }
}

- (void) setOffsetX:(float)newOffsetX {
    _offsetX = newOffsetX;
    self.position = CGPointMake(-_offsetX*self.scale, 0);
    [self resetHillVertices];
}

- (void)dealloc {
    [_stripes release];
    _stripes = NULL;
    [super dealloc];
}

@end
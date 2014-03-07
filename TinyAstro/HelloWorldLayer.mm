#import "HelloWorldLayer.h"

@interface HelloWorldLayer() {
    CCSprite *_background;
}
@end

@implementation HelloWorldLayer

+(CCScene *)scene {
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [HelloWorldLayer node];
    [scene addChild: layer];
    return scene;
}

-(CCSprite *)spriteWithColor:(ccColor4F)bgColor textureWidth:(float)textureWidth textureHeight:(float)textureHeight {
    // 1: Create new CCRenderTexture
    CCRenderTexture *renderTexture = [CCRenderTexture renderTextureWithWidth:textureWidth height:textureHeight];
    
    // 2: Call CCRenderTexture:begin
    [renderTexture beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
    
    CC_NODE_DRAW_SETUP();
    
    // 3: Draw into the texture
    float gradientAlpha = 0.7f;
    CGPoint vertices[4];
    ccColor4F colors[4];
    int nVertices = 0;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F) {0, 0, 0, 0};
    vertices[nVertices] = CGPointMake(textureWidth, 0);
    colors[nVertices++] = (ccColor4F) {0, 0, 0, 0};
    vertices[nVertices] = CGPointMake(0, textureHeight);
    colors[nVertices++] = (ccColor4F) {0, 0, 0, gradientAlpha};
    vertices[nVertices] = CGPointMake(textureWidth, textureHeight);
    colors[nVertices++] = (ccColor4F) {0, 0, 0, gradientAlpha};
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color);
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    CCSprite *noise = [CCSprite spriteWithFile: @"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureWidth/2, textureHeight/2);
    [noise visit];
    
    // 4: Call CCRenderTexture:end
    [renderTexture end];
    
    return [CCSprite spriteWithTexture:renderTexture.sprite.texture];
}

-(ccColor4F)randomBrightColor {
    while(true) {
        float requiredBrightness = 192;
        ccColor4B randomColor =
            ccc4(arc4random() % 255,
                 arc4random() % 255,
                 arc4random() % 255,
                 255);
        if (randomColor.r > requiredBrightness ||
            randomColor.g > requiredBrightness ||
            randomColor.b > requiredBrightness) {
            return ccc4FFromccc4B(randomColor);
        }
    }
}

-(void)genBackground {
    
    
    [_background removeFromParentAndCleanup:YES];
    
    ccColor4F bgColor = [self randomBrightColor];
    _background = [self spriteWithColor:bgColor textureWidth:IS_IPHONE_5 ? 1024:512 textureHeight:512];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _background.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:_background z:-1];
}

-(void)onEnter {
    [super onEnter];
    [self genBackground];
    [self setTouchEnabled:YES];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self genBackground];
}

-(id)init {
    if ((self = [super init]))
    {
    }
    return self;
}

@end

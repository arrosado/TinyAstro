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

-(CCSprite *)stripedSpriteWithColor1:(ccColor4F)c1 color2:(ccColor4F)c2 textureWidth:(float)textureWidth
                       textureHeight:(float)textureHeight stripes:(int)nStripes {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureWidth height:textureHeight];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:c1.r g:c1.g b:c1.b a:c1.a];
    
    // 3: Draw into the texture
    
    // Layer 1: Stripes
    CGPoint vertices[nStripes*6];
    ccColor4F colors[nStripes*6];
    
    int nVertices = 0;
    float x1 = -textureHeight;
    float x2;
    float y1 = textureHeight;
    float y2 = 0;
    float dx = textureWidth / nStripes * 2;
    float stripeWidth = dx/2;
    for (int i=0; i<nStripes; i++) {
        x2 = x1 + textureHeight;
        
        vertices[nVertices] = CGPointMake(x1, y1);
        colors[nVertices++] = (ccColor4F){c2.r, c2.g, c2.b, c2.a};
        
        vertices[nVertices] = CGPointMake(x1+stripeWidth, y1);
        colors[nVertices++] = (ccColor4F){c2.r, c2.g, c2.b, c2.a};
        
        vertices[nVertices] = CGPointMake(x2, y2);
        colors[nVertices++] = (ccColor4F){c2.r, c2.g, c2.b, c2.a};
        
        vertices[nVertices] = vertices[nVertices-2];
        colors[nVertices++] = (ccColor4F){c2.r, c2.g, c2.b, c2.a};
        
        vertices[nVertices] = vertices[nVertices-2];
        colors[nVertices++] = (ccColor4F){c2.r, c2.g, c2.b, c2.a};
        
        vertices[nVertices] = CGPointMake(x2+stripeWidth, y2);
        colors[nVertices++] = (ccColor4F){c2.r, c2.g, c2.b, c2.a};
        x1 += dx;
    }
    
    self.shaderProgram =
    [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
    
    // Layer 2: Noise
    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureWidth/2, textureHeight/2);
    [noise visit];
    
    // Layer 3: Stripes
    CC_NODE_DRAW_SETUP();
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_TRUE, 0, colors);
    glDrawArrays(GL_TRIANGLES, 0, (GLsizei)nVertices);
    
    float gradientAlpha = 0.7;
    
    nVertices = 0;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    
    vertices[nVertices] = CGPointMake(textureWidth, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    
    vertices[nVertices] = CGPointMake(0, textureHeight);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    
    vertices[nVertices] = CGPointMake(textureWidth, textureHeight);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_TRUE, 0, colors);
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    // layer 3: top highlight
    float borderHeight = textureHeight/16;
    float borderAlpha = 0.3f;
    nVertices = 0;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F){0.5f, 0.5f, 0.5f, borderAlpha};
    
    vertices[nVertices] = CGPointMake(textureWidth, 0);
    colors[nVertices++] = (ccColor4F){0.5f, 0.5f, 0.5f, borderAlpha};
    
    vertices[nVertices] = CGPointMake(0, borderHeight);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    
    vertices[nVertices] = CGPointMake(textureWidth, borderHeight);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_TRUE, 0, colors);
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
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
    ccColor4F color2 = [self randomBrightColor];
    
    //_background = [self spriteWithColor:bgColor textureWidth:IS_IPHONE_5 ? 1024:512 textureHeight:512];
    int nStripes = ((arc4random() % 4) + 1) * 2;
    _background = [self stripedSpriteWithColor1:bgColor color2:color2
                                   textureWidth:IS_IPHONE_5?1024:512 textureHeight:512 stripes:nStripes];
    
    self.scale = 0.5;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _background.position = ccp(winSize.width/2, winSize.height/2);
    
    // Parameters to make the texture repeat over and over.
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [_background.texture setTexParameters:&tp];
    
    [self addChild:_background z:-1];
}

-(void)onEnter {
    [super onEnter];
    [self genBackground];
    [self setTouchEnabled:YES];
    [self scheduleUpdate];
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

- (void)update:(ccTime)dt {
    
    float PIXELS_PER_SECOND = 100;
    static float offset = 0;
    offset += PIXELS_PER_SECOND * dt;
    
    CGSize textureSize = _background.textureRect.size;
    [_background setTextureRect:CGRectMake(offset, 0, textureSize.width, textureSize.height)];
    
}

@end

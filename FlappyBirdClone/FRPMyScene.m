//
//  FRPMyScene.m
//  FlappyBirdClone
//
//  Created by Giordano Scalzo on 09/02/2014.
//  Copyright (c) 2014 Effective Code Ltd. All rights reserved.
//

#import "FRPMyScene.h"

@interface FRPMyScene ()
@property (nonatomic, weak) SKSpriteNode *sprite;
@property (nonatomic, weak) SKSpriteNode *terrain;
@end

@implementation FRPMyScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        self.sprite.physicsBody.velocity = CGVectorMake(0,0);
        [self.sprite.physicsBody applyImpulse:CGVectorMake(0, 15)];
}


- (void)update:(CFTimeInterval)currentTime
{
    [self setHeroRotationBasedOnVelocity];
}


- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

    [self createWorld];
    [self createHero];
    [self createMovingTerrain];
}

- (void)createWorld
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"background"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    [self addChild:background];

    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}

- (void)createMovingTerrain
{
    SKTexture *terrainTexture = [SKTexture textureWithImageNamed:@"terrain"];
    CGSize size = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height/10.0f);
    self.terrain = [SKSpriteNode spriteNodeWithTexture:terrainTexture size:size];
    CGPoint location = CGPointMake(0.0f, size.height);
    self.terrain.scale = 2.0f;
    self.terrain.position = location;
    [self addChild:self.terrain];
}

- (void)createHero
{
    CGPoint location = CGPointMake(self.size.width / 3.0f, self.size.height / 2.0f);
    self.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"hero1"];
    self.sprite.position = location;
    [self.sprite setScale:2.0f];
    self.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
            CGSizeMake(self.sprite.size.width * 0.95f, self.sprite.size.height * 0.95)];
    self.sprite.physicsBody.dynamic = YES;

    [self addChild:self.sprite];
    [self animateHero];
}

-(void)animateHero
{
    NSArray *animationFrames = @[
            [SKTexture textureWithImageNamed:@"hero1"],
            [SKTexture textureWithImageNamed:@"hero2"]
    ];
    [self.sprite runAction:[SKAction repeatActionForever:
            [SKAction animateWithTextures:animationFrames
                             timePerFrame:0.1f
                                   resize:NO
                                  restore:YES]] withKey:@"flyingHero"];
}

- (void)setHeroRotationBasedOnVelocity
{
    if(self.sprite.physicsBody.velocity.dy > 30.0) {
        self.sprite.zRotation = (CGFloat)M_PI/6.0f;
    } else if(self.sprite.physicsBody.velocity.dy < -100.0) {
        self.sprite.zRotation = -(CGFloat)M_PI/4.0f;
    } else {
        self.sprite.zRotation = 0.0f;
    }
}


@end

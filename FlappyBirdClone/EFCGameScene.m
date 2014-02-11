//
//  EFCGameScene.m
//  FlappyBirdClone
//
//  Created by Giordano Scalzo on 09/02/2014.
//  Copyright (c) 2014 Effective Code Ltd. All rights reserved.
//

#import "EFCGameScene.h"
#import "EFCMenuScene.h"
#import "YMCPhysicsDebugger.h"

typedef NS_OPTIONS(NSUInteger, CollisionCategory) {
    heroType = (1 << 0),
    terrainType = (1 << 1),
    pipeType = (1 << 2)
};

@interface EFCGameScene () <SKPhysicsContactDelegate>
@property (nonatomic, strong) SKSpriteNode *sprite;
@property (nonatomic, strong) SKSpriteNode *terrain;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation EFCGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [YMCPhysicsDebugger init];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.sprite.physicsBody.velocity = CGVectorMake(0, 0);
    [self.sprite.physicsBody applyImpulse:CGVectorMake(0, 2)];
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

    [self schedulePipe];
}


- (void)schedulePipe
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(addPipe:) userInfo:nil repeats:YES];
        [self addPipe:nil];
}


- (void)createWorld
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"background"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    [self addChild:background];

    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, -1);
}


- (void)createMovingTerrain
{
    SKTexture *terrainTexture = [SKTexture textureWithImageNamed:@"terrain"];
    SKSpriteNode *node1 = [SKSpriteNode spriteNodeWithTexture:terrainTexture];
    node1.anchorPoint = CGPointMake(0, 1);
    node1.position = CGPointMake(0, 0);
    SKSpriteNode *node2 = [SKSpriteNode spriteNodeWithTexture:terrainTexture];
    node2.anchorPoint = CGPointMake(0, 1);
    node2.position = CGPointMake(320, 0);

    CGSize size = CGSizeMake(640, 60);
    self.terrain = [SKSpriteNode spriteNodeWithTexture:terrainTexture size:size];
    self.terrain.zPosition = 1;
    CGPoint location = CGPointMake(0.0f, 60);
    self.terrain.anchorPoint = CGPointMake(0, 1);
    self.terrain.position = location;
    [self.terrain addChild:node1];
    [self.terrain addChild:node2];
    [self addChild:self.terrain];
    
    
    SKNode *terrainBody = [SKNode node];
    terrainBody.position = CGPointMake(160.0f, 45);;
    terrainBody.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(320, 20)];
    terrainBody.physicsBody.dynamic = NO;
    terrainBody.physicsBody.affectedByGravity = NO;
    terrainBody.physicsBody.collisionBitMask = 0;
    terrainBody.physicsBody.categoryBitMask = terrainType;
    terrainBody.physicsBody.contactTestBitMask = heroType;
    [self addChild:terrainBody];
    
    [self moveTerrain];
}


- (void)moveTerrain
{
    [self.terrain runAction:[SKAction repeatActionForever:
            [SKAction sequence:@[
                    [SKAction moveToX:-320 duration:5.0f],
                    [SKAction moveToX:0 duration:.0f]
            ]]]
    ];
}


- (void)createHero
{
    CGPoint location = CGPointMake(50.0f, 450.0f);
    self.sprite = [SKSpriteNode spriteNodeWithImageNamed:@"hero1"];
    self.sprite.position = location;
    self.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
            CGSizeMake(self.sprite.size.width * 0.95f, self.sprite.size.height * 0.95)];
    self.sprite.physicsBody.dynamic = YES;
    self.sprite.physicsBody.categoryBitMask = heroType;

    [self addChild:self.sprite];
    [self animateHero];
}


- (void)animateHero
{
    NSArray *animationFrames = @[
            [SKTexture textureWithImageNamed:@"hero1"],
            [SKTexture textureWithImageNamed:@"hero2"]
    ];
    [self.sprite                              runAction:[SKAction repeatActionForever:
            [SKAction animateWithTextures:animationFrames
                             timePerFrame:0.1f
                                   resize:NO
                                  restore:YES]] withKey:@"flyingHero"];
}


- (void)setHeroRotationBasedOnVelocity
{
    if (self.sprite.physicsBody.velocity.dy > 30.0) {
        self.sprite.zRotation = (CGFloat) M_PI/ 6.0f;
    } else if (self.sprite.physicsBody.velocity.dy < -100.0) {
        self.sprite.zRotation = -(CGFloat) M_PI/ 4.0f;
    } else {
        self.sprite.zRotation = 0.0f;
    }
}


- (void)die
{
    [self.sprite removeAllActions];
    [self.terrain removeAllActions];
    self.sprite.physicsBody = nil;
    [self.timer invalidate];

    SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
    EFCMenuScene *newScene = [[EFCMenuScene alloc] initWithSize:self.size];
    [self.scene.view presentScene:newScene transition:reveal];
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [self die];
}


- (void)didEndContact:(SKPhysicsContact *)contact
{
    // do whatever you need to do when a contact ends
}


- (void)addPipe:(NSTimer *)timer
{
    NSLog(@"NEW PIPE");
    CGFloat offset = 610;
    CGFloat startY = -50 + arc4random() % 4 * 60;

    SKSpriteNode *topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe"];
    topPipe.position = CGPointMake(320, startY + offset);
    topPipe.zPosition = 0.1;
    topPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:topPipe.size];
    topPipe.physicsBody.dynamic = NO;
    topPipe.physicsBody.collisionBitMask = 0;
    topPipe.physicsBody.categoryBitMask = pipeType;
    topPipe.physicsBody.contactTestBitMask = heroType;
    [self addChild:topPipe];

    SKSpriteNode *bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe"];
    bottomPipe.position = CGPointMake(320, startY);
    bottomPipe.yScale = -1.0f;
    bottomPipe.zPosition = 0;
    bottomPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bottomPipe.size];
    bottomPipe.physicsBody.dynamic = NO;
    bottomPipe.physicsBody.collisionBitMask = 0;
    bottomPipe.physicsBody.categoryBitMask = pipeType;
    bottomPipe.physicsBody.contactTestBitMask = heroType;
    [self addChild:bottomPipe];

    CGFloat finalPosition = -50;
    CGFloat duration = 6.0;

    [topPipe runAction:[SKAction repeatActionForever:
            [SKAction sequence:@[
                    [SKAction moveToX:finalPosition duration:duration],
                    [SKAction removeFromParent]
            ]]]
    ];
    [bottomPipe runAction:[SKAction repeatActionForever:
            [SKAction sequence:@[
                    [SKAction moveToX:finalPosition duration:duration],
                    [SKAction removeFromParent]
            ]]]
    ];

    [self drawPhysicsBodies];
}

@end

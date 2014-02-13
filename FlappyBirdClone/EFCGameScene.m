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
#import "EFCConstants.h"
#import "EFCTerrain.h"

@interface EFCGameScene () <SKPhysicsContactDelegate>
@property (nonatomic, strong) SKSpriteNode *hero;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) NSTimer *pipeTimer;
@property (nonatomic, strong) SKAction *pipeSound;
@property (nonatomic, strong) SKAction *terrainSound;
@property (nonatomic, assign) NSUInteger score;
@end

@implementation EFCGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        //[YMCPhysicsDebugger init];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.hero.physicsBody.velocity = CGVectorMake(0, 0);
    [self.hero.physicsBody applyImpulse:CGVectorMake(0, 3)];
}


- (void)update:(CFTimeInterval)currentTime
{
    [self setHeroRotationBasedOnVelocity];
}


- (void)createScoreLabel
{
    self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
    [self.scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height-50)];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.score]]];
    [self addChild:self.scoreLabel];
}

- (void)preloadSounds
{
    self.pipeSound = [SKAction playSoundFileNamed:@"pipe.mp3" waitForCompletion:YES];
    self.terrainSound = [SKAction playSoundFileNamed:@"punch.mp3" waitForCompletion:YES];
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

    [self preloadSounds];
    [self createWorld];
    [self createHero];
    [self createScoreLabel];

    [EFCTerrain addNewNodeTo:self];
    
    [self schedulePipe];
}

- (void)schedulePipe
{
    self.pipeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(addPipe:) userInfo:nil repeats:YES];
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
    self.physicsWorld.gravity = CGVectorMake(0, -3);
}


- (void)createHero
{
    CGPoint location = CGPointMake(50.0f, 450.0f);
    self.hero = [SKSpriteNode spriteNodeWithImageNamed:@"hero1"];
    self.hero.position = location;
    self.hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
            CGSizeMake(self.hero.size.width * 0.95f, self.hero.size.height * 0.95)];
    self.hero.physicsBody.dynamic = YES;
    self.hero.physicsBody.collisionBitMask = pipeType;
    self.hero.physicsBody.categoryBitMask = heroType;
    self.hero.physicsBody.contactTestBitMask |= holeType;

    [self addChild:self.hero];
    [self animateHero];
}


- (void)animateHero
{
    NSArray *animationFrames = @[
            [SKTexture textureWithImageNamed:@"hero1"],
            [SKTexture textureWithImageNamed:@"hero2"]
    ];
    [self.hero                              runAction:[SKAction repeatActionForever:
            [SKAction animateWithTextures:animationFrames
                             timePerFrame:0.1f
                                   resize:NO
                                  restore:YES]] withKey:@"flyingHero"];
}


- (void)setHeroRotationBasedOnVelocity
{
    if (self.hero.physicsBody.velocity.dy > 30.0) {
        self.hero.zRotation = (CGFloat) M_PI/ 6.0f;
    } else if (self.hero.physicsBody.velocity.dy < -100.0) {
        self.hero.zRotation = -(CGFloat) M_PI/ 4.0f;
    } else {
        self.hero.zRotation = 0.0f;
    }
}


- (void)die
{
    [self.hero removeAllActions];
    self.hero.physicsBody = nil;
    [self.pipeTimer invalidate];

    SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
    EFCMenuScene *newScene = [[EFCMenuScene alloc] initWithSize:self.size];
    [self.scene.view presentScene:newScene transition:reveal];
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    if (collision == (heroType | pipeType)) {
        [self.hero.physicsBody applyImpulse:CGVectorMake(0, -10)];

        [self runAction:self.terrainSound completion:^{
         [self die];
        }];
    } else if (collision == (heroType | terrainType)) {
        [self runAction:self.terrainSound completion:^{
             [self die];
         }];
    }
}


- (void)didEndContact:(SKPhysicsContact *)contact
{
    uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    if (collision == (heroType | holeType)) {
        self.score++;
        [self runAction:self.pipeSound completion:^{
            [self renderScore];
        }];
    }
}


- (void)addPipe:(NSTimer *)timer
{
    CGFloat offset = 610;
    CGFloat startY = -50 + arc4random() % 4 * 60;
    CGFloat finalPosition = -50;
    CGFloat duration = 6.0;

    SKSpriteNode *topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe"];
    topPipe.position = CGPointMake(320, startY + offset);
    topPipe.zPosition = 0.1;
    topPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:topPipe.size];
    topPipe.physicsBody.dynamic = NO;
    topPipe.physicsBody.collisionBitMask = heroType;
    topPipe.physicsBody.categoryBitMask = pipeType;
    topPipe.physicsBody.contactTestBitMask = heroType;
    [self addChild:topPipe];
    [topPipe runAction:[SKAction repeatActionForever:
                        [SKAction sequence:@[
                                             [SKAction moveToX:finalPosition duration:duration],
                                             [SKAction removeFromParent]
                                             ]]]
     ];
    
    SKSpriteNode *bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe"];
    bottomPipe.position = CGPointMake(320, startY);
    bottomPipe.yScale = -1.0f;
    bottomPipe.zPosition = 0;
    bottomPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bottomPipe.size];
    bottomPipe.physicsBody.dynamic = NO;
    bottomPipe.physicsBody.collisionBitMask = heroType;
    bottomPipe.physicsBody.categoryBitMask = pipeType;
    bottomPipe.physicsBody.contactTestBitMask = heroType;
    [self addChild:bottomPipe];
    [bottomPipe runAction:[SKAction repeatActionForever:
            [SKAction sequence:@[
                    [SKAction moveToX:finalPosition duration:duration],
                    [SKAction removeFromParent]
            ]]]
    ];

    CGSize holeSize = CGSizeMake(bottomPipe.size.width, 75);
    SKSpriteNode *holeInPipe = [SKSpriteNode node];
    holeInPipe.position = CGPointMake(320, startY+bottomPipe.size.height/2.0f+35);
    holeInPipe.yScale = -1.0f;
    holeInPipe.zPosition = 0;
    holeInPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:holeSize];
    holeInPipe.physicsBody.dynamic = NO;
    holeInPipe.physicsBody.collisionBitMask = 0x00000000;
    holeInPipe.physicsBody.categoryBitMask = holeType;
    holeInPipe.physicsBody.contactTestBitMask = 0x00000000;
    [self addChild:holeInPipe];
    [holeInPipe runAction:[SKAction repeatActionForever:
                           [SKAction sequence:@[
                                                [SKAction moveToX:finalPosition duration:duration],
                                                [SKAction removeFromParent]
                                                ]]]
     ];

    //t[self drawPhysicsBodies];
}

- (void)renderScore
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", self.score]];
}

@end

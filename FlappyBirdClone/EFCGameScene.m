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
#import "EFCHero.h"

@interface EFCGameScene () <SKPhysicsContactDelegate>
@property (nonatomic, strong) EFCHero *hero;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) NSTimer *pipeTimer;
@property (nonatomic, strong) SKAction *pipeSound;
@property (nonatomic, strong) SKAction *terrainSound;
@property (nonatomic, assign) NSUInteger score;
@end

@implementation EFCGameScene

#pragma mark - Scene Cycle

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
    [self.hero flap];
}

- (void)update:(CFTimeInterval)currentTime
{
    [self.hero update];
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    [self setup];
}

#pragma mark - Creators

- (void)setup
{
    [self preloadSounds];
    [self createWorld];
    [self createScoreLabel];
    [self createHero];
    [self createTerrain];
    [self schedulePipe];
}

- (void)preloadSounds
{
    self.pipeSound = [SKAction playSoundFileNamed:@"pipe.mp3" waitForCompletion:YES];
    self.terrainSound = [SKAction playSoundFileNamed:@"punch.mp3" waitForCompletion:YES];
}

- (void)createScoreLabel
{
    self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
    [self.scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height-50)];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.score]]];
    [self addChild:self.scoreLabel];
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
    self.hero = [EFCHero createNodeOn:self];
    self.hero.position = CGPointMake(50.0f, 450.0f);
}

- (void)createTerrain
{
    [EFCTerrain addNewNodeTo:self];
}

#pragma mark - Actions

- (void)schedulePipe
{
    self.pipeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(addPipe:) userInfo:nil repeats:YES];
    [self addPipe:nil];
}


- (void)die
{
    [self.pipeTimer invalidate];

    SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
    EFCMenuScene *newScene = [[EFCMenuScene alloc] initWithSize:self.size];
    [self.scene.view presentScene:newScene transition:reveal];
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

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    if (collision == (heroType | pipeType)) {
        [self.hero goDown];
        
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


@end

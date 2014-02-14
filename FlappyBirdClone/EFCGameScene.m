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
#import "EFCPipe.h"

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
    self.pipeTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(addPipe:) userInfo:nil repeats:YES];
}

- (void)addPipe:(NSTimer *)timer
{
    [EFCPipe addNewNodeTo:self];
}

- (void)die
{
    [self.pipeTimer invalidate];

    SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
    EFCMenuScene *newScene = [[EFCMenuScene alloc] initWithSize:self.size];
    [self.scene.view presentScene:newScene transition:reveal];
}

#pragma mark - Score

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

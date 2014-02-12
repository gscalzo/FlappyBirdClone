//
// EFCMenuScene
// Created by giordanoscalzo on 10/02/2014.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "EFCMenuScene.h"
#import "EFCGameScene.h"
#import "EFCTerrain.h"

@interface EFCMenuScene ()
@property (nonatomic, strong)SKSpriteNode *startButton;
@end

@implementation EFCMenuScene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

    [self createWorld];
    [self createHero];
    [EFCTerrain addNewNodeTo:self];
    [self createStartButton];

}



- (void)createStartButton
{
    CGPoint location = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame) + 150 };
    self.startButton = [SKSpriteNode spriteNodeWithImageNamed:@"start"];
    self.startButton.position = location;
    [self addChild:self.startButton];
}

- (void)createWorld
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"background"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    [self addChild:background];

    self.scaleMode = SKSceneScaleModeAspectFit;
}


- (void)createHero
{
    CGPoint location = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"hero1"];
    sprite.position = location;

    [self addChild:sprite];
    [self animateHero:sprite];
}


- (void)animateHero:(SKSpriteNode *)sprite
{
    NSArray *animationFrames = @[
            [SKTexture textureWithImageNamed:@"hero1"],
            [SKTexture textureWithImageNamed:@"hero2"]
    ];
    [sprite                                   runAction:[SKAction repeatActionForever:
            [SKAction animateWithTextures:animationFrames
                             timePerFrame:0.1f
                                   resize:NO
                                  restore:YES]] withKey:@"flyingHero"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    //check if your button is tapped
    if(CGRectContainsPoint(self.startButton.frame, positionInScene))
    {
        SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
        EFCGameScene *newScene = [[EFCGameScene alloc] initWithSize: self.size];
        [self.scene.view presentScene: newScene transition: reveal];
    }
}

@end
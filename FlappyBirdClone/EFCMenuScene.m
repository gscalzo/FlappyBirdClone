//
// EFCMenuScene
// Created by giordanoscalzo on 10/02/2014.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "EFCMenuScene.h"
#import "EFCGameScene.h"
#import "EFCTerrain.h"
#import "EFCHero.h"

@interface EFCMenuScene ()
@property (nonatomic, strong)SKSpriteNode *startButton;
@end

@implementation EFCMenuScene


- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

    [self setup];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    if(CGRectContainsPoint(self.startButton.frame, positionInScene))
    {
        SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
        EFCGameScene *newScene = [[EFCGameScene alloc] initWithSize: self.size];
        [self.scene.view presentScene: newScene transition: reveal];
    }
}

- (void)setup
{
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
    SKSpriteNode *hero = [EFCHero createSpriteOn:self];
    hero.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};;

}

@end
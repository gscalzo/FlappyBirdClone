//
//  EFCHero.m
//  FlappyBirdClone
//
//  Created by Giordano Scalzo on 13/02/2014.
//  Copyright (c) 2014 Effective Code Ltd. All rights reserved.
//

#import "EFCHero.h"
#import "EFCConstants.h"

@implementation EFCHero

- (id)init
{
    self = [super initWithImageNamed:@"hero1"];
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
                            CGSizeMake(self.size.width * .95f,
                                       self.size.height * .95f)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.collisionBitMask = pipeType;
        self.physicsBody.categoryBitMask = heroType;
        self.physicsBody.contactTestBitMask |= holeType;
        
        [self animate];
    }
    return self;
}


- (void)animate
{
    NSArray *animationFrames = @[
                                 [SKTexture textureWithImageNamed:@"hero1"],
                                 [SKTexture textureWithImageNamed:@"hero2"]
                                 ];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:animationFrames
                                      timePerFrame:0.1f
                                            resize:NO
                                           restore:YES]] withKey:@"flyingHero"];
}

+ (id)createNodeOn:(SKNode *)parent
{
    id hero = [EFCHero new];
    [parent addChild:hero];
    return hero;
}

+ (id)createSpriteOn:(SKNode *)parent
{
    SKNode *hero = [self createNodeOn:parent];
    hero.physicsBody = nil;
    return hero;
}

- (void)update
{
    if (self.physicsBody.velocity.dy > 30.0) {
        self.zRotation = (CGFloat) M_PI/ 6.0f;
    } else if (self.physicsBody.velocity.dy < -100.0) {
        self.zRotation = -(CGFloat) M_PI/ 4.0f;
    } else {
        self.zRotation = 0.0f;
    }
}

- (void)goDown
{
    [self.physicsBody applyImpulse:CGVectorMake(0, -10)];
}

- (void)flap
{
    self.physicsBody.velocity = CGVectorMake(0, 0);
    [self.physicsBody applyImpulse:CGVectorMake(0, 3)];
}

@end

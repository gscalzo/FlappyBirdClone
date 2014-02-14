//
//  EFCPipe.m
//  FlappyBirdClone
//
//  Created by Giordano Scalzo on 14/02/2014.
//  Copyright (c) 2014 Effective Code Ltd. All rights reserved.
//

#import "EFCPipe.h"
#import "EFCConstants.h"

@implementation EFCPipe

+ (void)addNewNodeTo:(SKNode *)parentNode;
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
    [parentNode addChild:topPipe];
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
    [parentNode addChild:bottomPipe];
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
    [parentNode addChild:holeInPipe];
    [holeInPipe runAction:[SKAction repeatActionForever:
                           [SKAction sequence:@[
                                                [SKAction moveToX:finalPosition duration:duration],
                                                [SKAction removeFromParent]
                                                ]]]
     ];
    
    //[self drawPhysicsBodies];
}

@end

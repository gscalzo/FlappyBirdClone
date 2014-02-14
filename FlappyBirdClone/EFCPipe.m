//
//  EFCPipe.m
//  FlappyBirdClone
//
//  Created by Giordano Scalzo on 14/02/2014.
//  Copyright (c) 2014 Effective Code Ltd. All rights reserved.
//

#import "EFCPipe.h"
#import "EFCConstants.h"

static const CGFloat finalPosition = -50;
static const CGFloat duration = 6.0;

@implementation EFCPipe

+ (void)addNewNodeTo:(SKNode *)parentNode;
{
    CGFloat offset = 620;
    CGFloat startY = -50 + arc4random() % 4 * 60;
    
    [parentNode addChild:[self createPipeAtY:(startY + offset) isTopPipe:YES]];
    [parentNode addChild:[self createPipeAtY:startY isTopPipe:NO]];
}

+ (id)createPipeAtY:(CGFloat)startY isTopPipe:(BOOL)isTopPipe
{
    SKSpriteNode *pipeNode = [SKSpriteNode spriteNodeWithImageNamed:@"pipe"];
    pipeNode.position = CGPointMake(320, startY);
    pipeNode.yScale = (isTopPipe) ? 1.0f : -1.0f;
    pipeNode.zPosition = 0;
    pipeNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeNode.size];
    pipeNode.physicsBody.dynamic = NO;
    pipeNode.physicsBody.collisionBitMask = heroType;
    pipeNode.physicsBody.categoryBitMask = pipeType;
    pipeNode.physicsBody.contactTestBitMask = heroType;
    [self animate:pipeNode];
    return pipeNode;
}

+ (void)animate:(SKNode *)node
{
    [node runAction:
      [SKAction sequence:@[
                           [SKAction moveToX:finalPosition duration:duration],
                           [SKAction removeFromParent]
                           ]
       ]
     ];
}

@end

//
//  EFCTerrain.m
//  FlappyBirdClone
//
//  Created by Giordano Scalzo on 11/02/2014.
//  Copyright (c) 2014 Effective Code Ltd. All rights reserved.
//

#import "EFCTerrain.h"
#import "EFCConstants.h"

@implementation EFCTerrain

+ (void)addNewNodeTo:(SKNode *)parentNode
{
    SKTexture *terrainTexture = [SKTexture textureWithImageNamed:@"terrain"];
    SKSpriteNode *node1 = [SKSpriteNode spriteNodeWithTexture:terrainTexture];
    node1.anchorPoint = CGPointMake(0, 1);
    node1.position = CGPointMake(0, 0);
    SKSpriteNode *node2 = [SKSpriteNode spriteNodeWithTexture:terrainTexture];
    node2.anchorPoint = CGPointMake(0, 1);
    node2.position = CGPointMake(320, 0);
    
    CGSize size = CGSizeMake(640, 60);
    SKSpriteNode *terrain = [SKSpriteNode spriteNodeWithTexture:terrainTexture size:size];
    terrain.zPosition = 1;
    CGPoint location = CGPointMake(0.0f, 60);
    terrain.anchorPoint = CGPointMake(0, 1);
    terrain.position = location;
    [terrain addChild:node1];
    [terrain addChild:node2];
    [parentNode addChild:terrain];
    
    
    SKNode *terrainBody = [SKNode node];
    terrainBody.position = CGPointMake(160.0f, 35);;
    terrainBody.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(320, 20)];
    terrainBody.physicsBody.dynamic = NO;
    terrainBody.physicsBody.affectedByGravity = NO;
    terrainBody.physicsBody.collisionBitMask = 0;
    terrainBody.physicsBody.categoryBitMask = terrainType;
    terrainBody.physicsBody.contactTestBitMask = heroType;
    [parentNode addChild:terrainBody];
    
    [terrain runAction:[SKAction repeatActionForever:
                             [SKAction sequence:@[
                                                  [SKAction moveToX:-320 duration:5.0f],
                                                  [SKAction moveToX:0 duration:.0f]
                                                  ]]]
     ];
    
}


@end

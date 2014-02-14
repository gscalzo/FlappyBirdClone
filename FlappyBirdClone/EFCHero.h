//
//  EFCHero.h
//  FlappyBirdClone
//
//  Created by Giordano Scalzo on 13/02/2014.
//  Copyright (c) 2014 Effective Code Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EFCHero : SKSpriteNode

+ (id)createNodeOn:(SKNode *)parent;
+ (id)createSpriteOn:(SKNode *)parent;
- (void)update;
- (void)goDown;
- (void)flap;

@end

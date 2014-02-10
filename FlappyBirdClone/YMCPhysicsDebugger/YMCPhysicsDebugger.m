//
//  YMCPhysicsDebugger.m
//  PhysicsDebugger
//
//  Created by ymc-thzi on 17.10.13.
//  Copyright (c) 2013 YMC. All rights reserved.
//

#import "YMCPhysicsDebugger.h"
#import <SpriteKit/SpriteKit.h>
//import the swizzler to catch physicsBody method calls
#import "YMCSwizzler.h"

@implementation YMCPhysicsDebugger

+(void)init {
    
    SEL circleSelector = sel_registerName("bodyWithCircleOfRadiusSwizzled:");
    SEL rectangleSelector = sel_registerName("bodyWithRectangleOfSizeSwizzled:");
    SEL polygonSelector = sel_registerName("bodyWithPolygonFromPathSwizzled:");
    SEL edgechainSelector = sel_registerName("bodyWithEdgeChainFromPathSwizzled:");
    
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithCircleOfRadius:), circleSelector);
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithRectangleOfSize:), rectangleSelector);
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithPolygonFromPath:), polygonSelector);
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithEdgeChainFromPath:), edgechainSelector);
}
@end

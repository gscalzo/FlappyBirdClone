//
//  SKPhysicsBody+Swizzle.m
//  PhysicsDebugger
//
//  Created by ymc-thzi on 15.10.13.
//  Copyright (c) 2013 YMC. All rights reserved.
//

#import "YMCSKPhysicsBody+Swizzle.h"
#import "YMCPhysicsDebugProperties.h"

void YMCSwizzler(Class originalClass,
                 SEL orig,
                 SEL new);

@implementation SKPhysicsBody (Swizzle)


+ (SKPhysicsBody *)bodyWithCircleOfRadiusSwizzled:(float)radius
{
    
    //Save the physicsBody Radius to draw a shape with this afterwards
    YMCPhysicsDebugProperties *physicsBodyProperty = [YMCPhysicsDebugProperties instance];

    NSArray *keys = [NSArray arrayWithObjects:
                     @"type",
                     @"radius",
                     nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        @"circle",
                        [NSNumber numberWithFloat:radius],
                        nil];
    NSDictionary *bodyProps = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [physicsBodyProperty.nodesNBodies addObject:bodyProps];
    
    
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithCircleOfRadiusSwizzled:), @selector(bodyWithCircleOfRadius:));
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithCircleOfRadius:), @selector(bodyWithCircleOfRadiusSwizzled:));
    
    return body;
}

+ (SKPhysicsBody *)bodyWithRectangleOfSizeSwizzled:(CGSize)size
{        
    //Save the physicsBody RectSize to draw a shape with this afterwards
    YMCPhysicsDebugProperties *physicsBodyProperty = [YMCPhysicsDebugProperties instance];

    NSArray *keys = [NSArray arrayWithObjects:
                     @"type",
                     @"width",
                     @"height",
                     nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        @"rectangle",
                        [NSNumber numberWithFloat:size.width],
                        [NSNumber numberWithFloat:size.height],
                        nil];
    NSDictionary *bodyProps = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [physicsBodyProperty.nodesNBodies addObject:bodyProps];
    
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithRectangleOfSizeSwizzled:), @selector(bodyWithRectangleOfSize:));
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:size];
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithRectangleOfSize:), @selector(bodyWithRectangleOfSizeSwizzled:));
    
    return body;
}

+ (SKPhysicsBody *)bodyWithPolygonFromPathSwizzled:(CGPathRef)path
{
    //Save the physicsBody polygonPath to draw a shape with this afterwards
    YMCPhysicsDebugProperties *physicsBodyProperty = [YMCPhysicsDebugProperties instance];
    NSArray *keys = [NSArray arrayWithObjects:
                     @"type",
                     @"path",
                     nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        @"polygon",
                        [UIBezierPath bezierPathWithCGPath:path],
                        nil];
    NSDictionary *bodyProps = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [physicsBodyProperty.nodesNBodies addObject:bodyProps];
    
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithPolygonFromPathSwizzled:), @selector(bodyWithPolygonFromPath:));
    SKPhysicsBody *body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithPolygonFromPath:), @selector(bodyWithPolygonFromPathSwizzled:));
    
    return body;
}

+ (SKPhysicsBody *)bodyWithEdgeChainFromPathSwizzled:(CGPathRef)path
{
    //Save the physicsBody polygonPath to draw a shape with this afterwards
    YMCPhysicsDebugProperties *physicsBodyProperty = [YMCPhysicsDebugProperties instance];
    NSArray *keys = [NSArray arrayWithObjects:
                     @"type",
                     @"path",
                     nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        @"polygon",
                        [UIBezierPath bezierPathWithCGPath:path],
                        nil];
    NSDictionary *bodyProps = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [physicsBodyProperty.nodesNBodies addObject:bodyProps];
    
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithEdgeChainFromPathSwizzled:), @selector(bodyWithEdgeChainFromPath:));
    SKPhysicsBody *body = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    YMCSwizzler([SKPhysicsBody class], @selector(bodyWithEdgeChainFromPath:), @selector(bodyWithEdgeChainFromPathSwizzled:));
    
    return body;
}

@end

//
//  SKNode+DrawPhysicsBodies.m
//  PhysicsDebugger
//
//  Created by ymc-thzi on 14.10.13.
//  Copyright (c) 2013 YMC. All rights reserved.
//

#import "YMCSKNode+PhysicsDebug.h"
#import "YMCPhysicsDebugProperties.h"

@implementation SKNode (PhysicsDebug)


//The switch to enable/disable physicsBody drawing
static BOOL debug = TRUE;

//The debugLayers Identifier name
static NSString* debugLayerName = @"physicsDebugLayer";

/*
 * Color definition for the rendered physicDebugLayers
 * draw methods on them
 */
-(SKColor*) debugLayerColor {
    return [SKColor colorWithRed:1 green:0 blue:0 alpha:1];
}

/*
 * Iterate all physicsBodies and call 
 * draw methods on them
 */
- (void)drawPhysicsBodies {
    
    //If Debugging switch is off do nothing
    if (debug == FALSE) {
        return;
    }
    
    //First of all, remove all existing physicsDebugLayer
    [[self childNodeWithName:debugLayerName] removeFromParent];
    
    int i = 0;
    //draw all children with physicsBodies
    for (SKNode *node in [self children]) {
 
        //sort out if it has no physics body
        if(!node.physicsBody) {
            continue;
        }
        
        //clear all drawn physicDebugLayers of this node
        [[node childNodeWithName:debugLayerName] removeFromParent];
        
        //Draw the physics shape and attach it to the child node
        NSString *type = [[[YMCPhysicsDebugProperties instance].nodesNBodies objectAtIndex:i] valueForKey:@"type"];
        
        if([type isEqualToString:@"circle"]) {
            
            float radius = [[[[YMCPhysicsDebugProperties instance].nodesNBodies objectAtIndex:i] valueForKey:@"radius"] floatValue];
            [self drawCircleLayer:node radius:radius];
        }
        
        if([type isEqualToString:@"rectangle"]) {
            
            float rectWidth = [[[[YMCPhysicsDebugProperties instance].nodesNBodies objectAtIndex:i] valueForKey:@"width"] floatValue];
            float rectHeight = [[[[YMCPhysicsDebugProperties instance].nodesNBodies objectAtIndex:i] valueForKey:@"height"] floatValue];
            [self drawRectangleLayer:node rectWidth:rectWidth rectHeight:rectHeight];
            
        }
        
        if([type isEqualToString:@"polygon"]) {
            
            UIBezierPath *path = [[[YMCPhysicsDebugProperties instance].nodesNBodies objectAtIndex:i] valueForKey:@"path"];
            SKShapeNode* shapeNode = (SKShapeNode*) node;
            [self drawPolygonLayer:shapeNode path:path.CGPath];
        }
        
        i++;
        
        if([[YMCPhysicsDebugProperties instance].nodesNBodies count] == i) {
            [YMCPhysicsDebugProperties instance].nodesNBodies = nil;
        }

    }
}

/*
 * Draw a Rectangle with the given node dimensions
 * and attach it to the given node
 */
- (void)drawRectangleLayer:(SKNode*)node rectWidth:(float)rectWidth rectHeight:(float)rectHeight{
    CGPathRef bodyPath = CGPathCreateWithRect( CGRectMake(-rectWidth/2,
                                                          -rectHeight/2,
                                                          rectWidth,
                                                          rectHeight),
                                              nil);
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = bodyPath;
    shape.name = debugLayerName;
    shape.strokeColor = [self debugLayerColor];
    shape.lineWidth = 0.1;
    shape.zPosition = 99;
    [node addChild:shape];
    CGPathRelease(bodyPath);
}

/*
 * Draw a Circle with the given node dimensions
 * and attach it to the given node
 */
- (void)drawCircleLayer:(SKNode*)node radius:(float)radius {
    
    radius = radius*2;
    
    CGPathRef bodyPath = CGPathCreateWithEllipseInRect(CGRectMake(-radius/2,
                                                                  -radius/2,
                                                                  radius,
                                                                  radius),
                                                       nil);
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = bodyPath;
    shape.name = debugLayerName;
    shape.strokeColor = [self debugLayerColor];
    shape.lineWidth = 0.1;
    shape.zPosition = 99;
    [node addChild:shape];
    CGPathRelease(bodyPath);
}

/*
 * Draw a Polygon with the given node dimensions
 * and attach it to the given node
 */
- (void)drawPolygonLayer:(SKShapeNode*)node path:(CGPathRef)path{
    
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = path;
    shape.name = debugLayerName;
    shape.strokeColor = [self debugLayerColor];
    shape.lineWidth = 0.1;
    shape.zPosition = 99;
    [node addChild:shape];
    
}
@end

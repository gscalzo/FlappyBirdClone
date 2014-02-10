//
//  YMCPhysicsProperty.m
//  PhysicsDebugger
//
//  Created by ymc-thzi on 15.10.13.
//  Copyright (c) 2013 YMC. All rights reserved.
//

#import "YMCPhysicsDebugProperties.h"

@implementation YMCPhysicsDebugProperties

static YMCPhysicsDebugProperties *gInstance = NULL;

+ (YMCPhysicsDebugProperties *)instance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
        {
            gInstance = [[self alloc] init];
            gInstance.nodesNBodies = [NSMutableArray array];
        }
    }
    
    return(gInstance);
}
@end

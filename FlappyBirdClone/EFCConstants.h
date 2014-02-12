//
//  EFCConstants.h
//  FlappyBirdClone
//
//  Created by Giordano Scalzo on 11/02/2014.
//  Copyright (c) 2014 Effective Code Ltd. All rights reserved.
//

#ifndef FlappyBirdClone_EFCConstants_h
#define FlappyBirdClone_EFCConstants_h

typedef NS_OPTIONS(NSUInteger, CollisionCategory) {
    heroType    = (1 << 0),
    terrainType = (1 << 1),
    pipeType    = (1 << 2)
};

#endif

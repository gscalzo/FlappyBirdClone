//
//  YMCSwizzler.m
//  YMCSwizzler
//
//  Created by ymc-thzi on 14.10.13.
//  Copyright (c) 2013 YMC. All rights reserved.
//

#import <objc/runtime.h>
#import "YMCSwizzler.h"

void YMCSwizzler(Class originalClass,
                 SEL calledMethod,
                 SEL swizzledMethod) {

    //get the methods
    Method origMethod = class_getClassMethod(originalClass,
                                             calledMethod);
    
    Method newMethod = class_getClassMethod(originalClass,
                                            swizzledMethod);

    originalClass = object_getClass((id)originalClass);

    //method swizzling by replacing the method call
    if(class_addMethod(originalClass,
                       calledMethod,
                       method_getImplementation(newMethod),
                       method_getTypeEncoding(newMethod))) {
        
        class_replaceMethod(originalClass,
                            swizzledMethod,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

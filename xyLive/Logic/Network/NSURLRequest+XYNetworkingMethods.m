//
//  NSURLRequest+XYNetworkingMethods.m
//  xyLive
//
//  Created by xyxxllh on 16/7/6.
//  Copyright © 2016年 XunLei. All rights reserved.
//

#import "NSURLRequest+XYNetworkingMethods.h"
#import <objc/runtime.h>

static void *CTNetworkingRequestParams;

@implementation NSURLRequest (XYNetworkingMethods)

- (void)setParams:(NSDictionary *)params{
    objc_setAssociatedObject(self, &CTNetworkingRequestParams, params, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)params{
    return objc_getAssociatedObject(self, &CTNetworkingRequestParams);
}

@end

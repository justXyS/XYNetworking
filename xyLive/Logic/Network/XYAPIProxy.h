//
//  XYAPIProxy.h
//  xyLive
//
//  Created by xyxxllh on 16/7/6.
//  Copyright © 2016年 XunLei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYNetConfig.h"

@class XYAPIProxy;
@class XYHTTPResponse;

@protocol XYAPIProxyDelegate <NSObject>

@optional

- (BOOL)APIProxy:(XYAPIProxy *)proxy shouldBeginWithRequest:(NSURLRequest *)request;

- (NSURLRequest *)APIProxy:(XYAPIProxy *)proxy willBeginWithRequest:(NSURLRequest *)request;

- (void)APIProxyDidEnd:(XYAPIProxy *)proxy;

- (void)APIProxy:(XYAPIProxy *)proxy complementHandler:(XYHTTPResponse *)response;

@end

@interface XYAPIProxy : NSObject

@property (nonatomic, weak) id<XYAPIProxyDelegate> delegate;

//+ (instancetype)sharedInstance;

- (void)cancelWithRequestId:(XYHTTPRequestID *)requestId;
- (void)cancelWithRequestIdList:(NSArray<XYHTTPRequestID *> *)requestIds;

@end

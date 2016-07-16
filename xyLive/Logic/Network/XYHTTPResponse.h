//
//  XYHTTPResponse.h
//  xyLive
//
//  Created by xyxxllh on 16/7/6.
//  Copyright © 2016年 XunLei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYNetConfig.h"

@interface XYHTTPResponse : NSObject

@property (nonatomic, strong, readonly) id content;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, strong, readonly) NSData *responseData;
@property (nonatomic, assign, readonly) XYHttpStatus statusCode;
@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) XYHTTPRequestID *requestId;
@property (nonatomic, strong, readonly) NSDictionary *params;

- (instancetype)initWithRequest:(NSURLRequest *)request requestId:(XYHTTPRequestID *)requestId responseData:(NSData *)responseData status:(XYHttpStatus)statusCode;

@end

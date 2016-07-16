//
//  XYHTTPResponse.m
//  xyLive
//
//  Created by xyxxllh on 16/7/6.
//  Copyright © 2016年 XunLei. All rights reserved.
//

#import "XYHTTPResponse.h"
#import "NSURLRequest+XYNetworkingMethods.h"

@interface XYHTTPResponse()

@property (nonatomic, strong, readwrite) id content;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) XYHttpStatus statusCode;
@property (nonatomic, strong, readwrite) NSURLRequest *request;
@property (nonatomic, strong, readwrite) XYHTTPRequestID *requestId;
@property (nonatomic, strong, readwrite) NSDictionary *params;

@end

@implementation XYHTTPResponse

- (instancetype)initWithRequest:(NSURLRequest *)request requestId:(XYHTTPRequestID *)requestId responseData:(NSData *)responseData status:(XYHttpStatus)statusCode{
    if (self = [super init]) {
        _request = request;
        _requestId = requestId;
        _responseData = responseData;
        if (responseData) {
            _content = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
            _contentString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        }
        _params = request.params;
        _statusCode = XYHttpStatusSuccess;
    }
    return self;
}

@end

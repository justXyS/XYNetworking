//
//  XYAPIProxy.m
//  xyLive
//
//  Created by xyxxllh on 16/7/6.
//  Copyright © 2016年 XunLei. All rights reserved.
//

#import "XYAPIProxy.h"
#import "AFNetworking.h"
#import "XYHTTPResponse.h"
#import "NSURLRequest+XYNetworkingMethods.h"

//typedef void(^XYAPICallBack)(XYHTTPResponse *response);

@interface XYAPIProxy()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *,NSURLSessionTask *> *dispatchTable;

@end

@implementation XYAPIProxy

#pragma makr
//+ (instancetype)sharedInstance{
//    static dispatch_once_t token;
//    static XYAPIProxy *sharedInstance;
//    dispatch_once(&token, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
//}

#pragma mark - public methods

- (XYHTTPRequestID *)callGETWithParams:(NSDictionary *)params serviceIdentifier:(XYServiceIdentifier)serviceIdentifier methodName:(NSString *)methodName{
    NSURLRequest *request = [self requestWithServiceIdentifier:serviceIdentifier methodName:methodName params:params];
    BOOL shouldCall = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(APIProxy:shouldBeginWithRequest:)]) {
        shouldCall = [self.delegate APIProxy:self shouldBeginWithRequest:request];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(APIProxy:willBeginWithRequest:)]) {
        request = [self.delegate APIProxy:self willBeginWithRequest:request];
    }
    XYHTTPRequestID *requestId = [self callAPIWithRequest:request];
    return requestId;
}

- (XYHTTPRequestID *)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(XYServiceIdentifier)serviceIdentifier methodName:(NSString *)methodName{
    NSURLRequest *request = [self requestWithServiceIdentifier:serviceIdentifier methodName:methodName params:params];
    XYHTTPRequestID *requestId = [self callAPIWithRequest:request];
    return requestId;
}

- (void)cancelWithRequestId:(XYHTTPRequestID *)requestId{
    NSURLSessionTask *task = self.dispatchTable[requestId];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestId];
}

- (void)cancelWithRequestIdList:(NSArray<XYHTTPRequestID *> *)requestIds{
    for (XYHTTPRequestID *reqid in requestIds) {
        NSURLSessionTask *task = self.dispatchTable[reqid];
        [task cancel];
        [self.dispatchTable removeObjectForKey:reqid];
    }
}

#pragma mark - private methods

- (NSURLRequest *)requestWithServiceIdentifier:(XYServiceIdentifier)identifier methodName:(NSString *)methodName params:(NSDictionary *)params{
    NSString *url = [NSString stringWithFormat:@"%@/%@",[self serviceBaseURLByServiceIdentifier:identifier],methodName];
    NSURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:NULL];
    request.params = params;
    return request;
}

- (XYHTTPRequestID *)callAPIWithRequest:(NSURLRequest *)request{
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * response, id responseObject, NSError *error) {
        XYHTTPRequestID *requestId = @(task.taskIdentifier);
        [self.dispatchTable removeObjectForKey:requestId];
        XYHTTPResponse *res = nil;
        if (error) {
            res = [[XYHTTPResponse alloc] initWithRequest:request requestId:requestId responseData:responseObject status:XYHttpStatusNoNetwork];
        }else{
            res = [[XYHTTPResponse alloc] initWithRequest:request requestId:requestId responseData:responseObject status:XYHttpStatusSuccess];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(APIProxy:complementHandler:)]) {
            [self.delegate APIProxy:self complementHandler:res];
        }
    }];
    [self.dispatchTable setObject:task forKey:@(task.taskIdentifier)];
    [task resume];
    if ([self.delegate respondsToSelector:@selector(APIProxyDidEnd:)]) {
        [self.delegate APIProxyDidEnd:self];
    }
    return @(task.taskIdentifier);
}

- (NSString *)serviceBaseURLByServiceIdentifier:(XYServiceIdentifier)serviceIdentifier{
    NSString *url = nil;
    switch (serviceIdentifier) {
        case XYLIBServiceIdentifier:
            url = @"";
            break;
    }
    return url;
}

#pragma makr - getter and setter
- (AFHTTPSessionManager *)sessionManager{
    if (!_sessionManager) {
        AFHTTPSessionManager *sessionManager= [AFHTTPSessionManager manager];
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sessionManager.requestSerializer.timeoutInterval = 15.;
    }
    return _sessionManager;
}

- (NSMutableDictionary *)dispatchTable{
    if (!_dispatchTable) {
        _dispatchTable = @{}.mutableCopy;
    }
    return _dispatchTable;
}

@end

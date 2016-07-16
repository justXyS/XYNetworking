//
//  XYNetConfig.h
//  xyLive
//
//  Created by xyxxllh on 16/7/7.
//  Copyright © 2016年 XunLei. All rights reserved.
//

#ifndef XYNetConfig_h
#define XYNetConfig_h

typedef NSNumber XYHTTPRequestID;

typedef NS_ENUM(NSInteger,XYServiceIdentifier){
    XYLIBServiceIdentifier = 1 << 0
};

typedef NS_ENUM(NSInteger,XYHttpStatus){
    XYHttpStatusSuccess = 1 << 0,
    XYHttpStatusNoNetwork = 1 << 1,
};


#endif /* XYNetConfig_h */

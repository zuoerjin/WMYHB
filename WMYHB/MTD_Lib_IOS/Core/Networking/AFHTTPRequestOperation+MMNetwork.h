//
//  AFHTTPRequestOperation+MMNetwork.h
//  MTDMetal
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

typedef void(^AFHttpOperationSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^AFHttpOperationFailedHandler)(AFHTTPRequestOperation *operation, NSError *error);
typedef void(^ApiCompleteHandler)(NSError *error, id resultData, id pharsedData, AFHTTPRequestOperation *reqOpt);

@interface AFHTTPRequestOperation (MMNetwork)

- (ApiCompleteHandler)getUICallback;
- (void)setUICallback:(ApiCompleteHandler)handler;

@end

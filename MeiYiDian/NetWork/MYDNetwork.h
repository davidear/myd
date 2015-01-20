//
//  MYDNetwork.h
//  MeiYiDian
//
//  Created by dfy on 15/1/8.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//
//封装网络层的作用，防止重复发起网络请求
//单纯使用queue的做法是把左右的网络交互做标记，在发起时将交互方法加入queue，根据queue是否已存在来决定是否发起，可以规避重复请求的问题
//而如果需要下载序列的话，可能就不适用了，这是采用ASINetworkQueue
#import <Foundation/Foundation.h>
#import "MYDConfig.h"
#import "ASINetworkQueue.h"

@interface MYDNetwork : NSObject
{
    NSMutableDictionary *queue;
    ASINetworkQueue *networkQueue;
}

+(MYDNetwork *)getInstant;

- (void)PostRequestWithSoapMessage:(NSString *)soapMessage
                        soapAction:(NSString *)soapAction
                          success:(void (^)(NSString *responseString, id responseData))success
                          failure:(void (^)(NSError *error))failure
                             task:(NetworkTask)task;

@end

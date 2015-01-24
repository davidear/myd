//
//  MYDNetwork.m
//  MeiYiDian
//
//  Created by dfy on 15/1/8.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDNetwork.h"
#import "ASIHTTPRequest.h"

@implementation MYDNetwork
#pragma mark - 单例
static MYDNetwork *instant = nil;
+(MYDNetwork *)getInstant
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instant=[[[self class] alloc] init];
    });
    return instant;
}

- (id)init{
    self = [super init];
    if (self) {
        queue = [[NSMutableDictionary alloc] init];
        networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue go];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if(instant==nil)
    {
        instant=[super allocWithZone:zone];
    }
    return instant;
}

-(id)copyWithZone:(NSZone *)zone
{
    return instant;
}
#pragma mark - 网络方法
- (void)PostRequestWithSoapMessage:(NSString *)soapMessage soapAction:(NSString *)soapAction success:(void (^)(NSString *, id))success failure:(void (^)(NSError *))failure task:(NetworkTask)task
{
/*这里是之前的仅使用queue的方法
 id taskInQueue = [queue objectForKey:[NSNumber numberWithInt:task]];
 if (taskInQueue == nil) {
 ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:kMYDServerId]];
 [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
 [request addRequestHeader:@"SOAPAction" value:soapAction];
 NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
 [request addRequestHeader:@"Content-Length" value:msgLength];
 [request setRequestMethod:@"Post"];
 [request setPostBody:[NSMutableData dataWithData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]]];
 
 __block ASIHTTPRequest *blockRequest = request;
 [request setCompletionBlock:^{
 [queue removeObjectForKey:[NSNumber numberWithInt:task]];
 success([blockRequest responseString],[blockRequest responseData]);
 }];
 [request setFailedBlock:^{
 [queue removeObjectForKey:[NSNumber numberWithInt:task]];
 failure([blockRequest error]);
 }];
 [queue setObject:request forKey:[NSNumber numberWithInt:task]];
 [request startAsynchronous];
 }else {
 MYD_Network_NSLog(@"重复的网络请求(taskID:%d)",task);
 }
 */

//使用ASINetworkQueue
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:kMYDServerId]];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"SOAPAction" value:soapAction];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [request addRequestHeader:@"Content-Length" value:msgLength];
    [request setRequestMethod:@"Post"];
    [request setPostBody:[NSMutableData dataWithData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]]];
    
    __block ASIHTTPRequest *blockRequest = request;
    [request setCompletionBlock:^{
        success([blockRequest responseString],[blockRequest responseData]);
    }];
    [request setFailedBlock:^{
        failure([blockRequest error]);
    }];
    
//    request.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:task] forKey:@"task"];
    [networkQueue addOperation:request];
    NSLog(@"networkQueue's request count is %d",networkQueue.requestsCount);
}

//#pragma mark - ASIHttpQueueDelegate
- (void)queueDidFinished
{
    
}
@end

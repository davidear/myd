//
//  MYDMediator.h
//  MeiYiDian
//
//  Created by dfy on 15/1/6.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYDNetWork.h"
#import "MYDPackageManager.h"
#pragma 定义回调block
typedef void (^SuccessBlock)(NSString *responseString);
typedef void (^FailureBlock)(NSError *error);
@interface MYDMediator : NSObject
{
    MYDNetwork *network;
    MYDPackageManager *packageManager;
}
+(MYDMediator *)getInstant;
/*!
 * @brief 登录
 * @param NSString userName NSString password
 * @return nil
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
/*!
 * @brief 获取数据版本号
 * @param NSString departmentId
 * @return nil
 */
- (void)getDataVersionWithDepartmentId:(NSString *)departmentId success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
/*!
 * @brief 获取基础数据
 * @param NSString departmentId
 * @return nil
 */
- (void)getBaseDataWithDepartmentId:(NSString *)departmentId success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
/*!
 * @brief 获取图片
 * @param NSString departmentId NSString typeCode NSString fileName
 * @return nil
 */
- (void)getPictureWithDepartmentId:(NSString *)departmentId typeCode:(NSString *)typeCode fileName:(NSString *)fileName success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end

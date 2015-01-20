//
//  MYDPackageManager.h
//  MeiYiDian
//
//  Created by dfy on 15/1/6.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYDPackageManager : NSObject

+(MYDPackageManager *)getInstant;

/*!
 * @brief 登录返回包解析
 * @param NSString responseString
 * @return nil
 */
- (void)unpackLoginBag:(NSString *)responseString;
/*!
 * @brief 数据版本号包解析
 * @param NSString responseString
 * @return nil
 */
- (void)unpackDataVersionBag:(NSString *)responseString;
/*!
 * @brief 基础数据包解析
 * @param NSString responseString
 * @return nil
 */
- (void)unpackBaseDataBag:(NSString *)responseString;
/*!
 * @brief 图片包解析
 * @param NSData responseData base64Binary
 * @return nil
 */
- (void)unpackPictureBag:(NSString *)responseString fileName:(NSString *)fileName;
@end

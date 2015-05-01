//
//  MYDConfig.h
//  MeiYiDian
//
//  Created by dfy on 15/1/6.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#ifndef MeiYiDian_MYDConfig_h
#define MeiYiDian_MYDConfig_h

#define kMYDServerId @"http://121.41.106.38:8088/services/webservice.asmx"
#define kMYDPartyId                 @"http://121.41.106.38:8088/Publics/Party.aspx?id=%@"
#define kMYDIntroduction            @"http://121.41.106.38:8088/Publics/Introduction.aspx?id=%@"

//SoapAction
#define kMYDLoginSoapActionId @"http://tempuri.org/Login"
#define kMYDGetBaseDataSoapActionId @"http://tempuri.org/GetBaseData"
#define kMYDGetDataVersionSoapActionId @"http://tempuri.org/DataVersion"
#define kMYDGetPictureSoapActionId @"http://tempuri.org/GetPicture"



typedef enum {
    NetworkLogin,
    NetworkGetDataVersion,
    NetworkGetBaseData,
    NetworkGetPictures,
    NetworkGetMaterialPictures,
    NetworkGetScrollPictures,
    NetworkGetWritingPictures,
    NetworkGetProjectPictures
}NetworkTask;

#define LoginUserKeyArray @[@"Id",@"Name",@"PasswordHash",@"PasswordSalt",@"FirstLastName",@"Qq",@"WeiXing",@"Email",@"Tel",@"DepartmentId",@"DepartmentName"]
#define MaterialCatalogsKeyArray @[@"Id",@"Name",@"Code",@"ParentId",@"OrderCode"]
#define MaterialsKeyArray @[@"Id",@"Name",@"Code",@"CatalogId",@"UnitName",@"StandardName",@"Price",@"TypeCodeX",@"OrderCode",@"TitlePictureFileName",@"Description"]
#define PicturesKeyArray @[@"Id",@"CatalogId",@"FKId",@"FileName",@"Description",@"OrderCode"]
#define PlanCatalogsKeyArray @[@"Id",@"Name",@"Code",@"ParentId",@"OrderCode"]
#define PlansKeyArray @[@"Id",@"Name",@"Code",@"CatalogId",@"Price",@"ProjectId",@"OrderCode",@"TitlePictureFileName",@"Description"]
#define PartiesKeyArray @[@"Id",@"Name",@"Code",@"Content",@"OrderCode"]
#define CatalogsKeyArray @[@"Id",@"Name",@"Code",@"OrderCode"]
#define IntroductionsKeyArray @[@"Id",@"CatalogId",@"OrderCode"]
#define WritingsKeyArray @[@"Id",@"CatalogId",@"Title",@"OrderCode",@"TitlePictureFileName"]
#define AnnouncementsKeyArray  @[@"Id",@"Title",@"Content",@"OrderCode"]
#define ProjectsKeyArray @[@"Id",@"Name",@"Code",@"CatalogId",@"UnitName",@"StandardName",@"Price",@"OrderCode",@"TitlePictureFileName",@"Description"]
#define TeamsKeyArray @[@"Id",@"Name",@"NickName",@"Number",@"PositionName",@"Description",@"OrderCode",@"TitlePictureFileName"]
//打印SDK日志开关  1-开，0-关
#define SDK_DEBUG 1
#if SDK_DEBUG
#define MYD_Network_NSLog(format,...){   \
NSDateFormatter* formatter = [[NSDateFormatter alloc]init];\
[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
NSString* date = [formatter stringFromDate:[NSDate date]];\
NSString * printLog=nil;\
printLog=[NSString stringWithFormat:@"[RouteMap] [%@] [SDKLog] [LINE:%d %s] [%@]",date,__LINE__,__FUNCTION__,[NSString stringWithFormat:format,##__VA_ARGS__]];\
const char* contentChars = [printLog cStringUsingEncoding:NSUTF8StringEncoding];\
printf("%s\n", contentChars);\
}
#else
#define MYD_Network_NSLog(format,...){   \
}
#endif
#endif



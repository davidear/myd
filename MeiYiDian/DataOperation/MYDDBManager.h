//
//  MYDDBManager.h
//  MeiYiDian
//
//  Created by dfy on 15/1/9.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//
//在LoginResult表中存一个dataVersion，自建一个单独的dataVersion来存本地数据对应的版本号，每次登录或者取dataVersion就更新LoginResult中的dataVersion，然后根据两个dataVersion是否一致来决定是否需要更新数据


#import <Foundation/Foundation.h>

@interface MYDDBManager : NSObject
+(MYDDBManager *)getInstant;
//登录
- (void)saveLoginResultWithDataVersion:(int)dataVersion DepartmentId:(NSString *)departmentId;
//查dataVersion
- (void)saveDataVersionWithDataVersion:(int)dataVersion;
//查baseData
////存LoginUser
- (void)saveLoginUserWithDic:(NSMutableDictionary *)dic keyArrayForDic:(NSArray *)keyArray;
////存MaterialCatalogEntity
- (void)saveMaterialCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存MaterialEntity
- (void)saveMaterialsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PictureEntity
- (void)saveMaterialPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PlanCatalogEntity
- (void)savePlanCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PlanEntity
- (void)savePlansWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PictureEntity
- (void)savePlanPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PictureEntity
- (void)saveScrollPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PartyEntity
- (void)savePartiesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存IntroductionCatalogEntity
- (void)saveIntroductionCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存IntroductionEntity
- (void)saveIntroductionsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存WritingCatalogEntity
- (void)saveWritingCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存WritingEntity
- (void)saveWritingsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PictureEntity
- (void)saveWritingPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存AnnouncementEntity
- (void)saveAnnouncementsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存ProjectCatalogEntity
- (void)saveProjectCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存ProjectEntity
- (void)saveProjectsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存ProjectPictureEntity
- (void)saveProjectPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存baseData中的DataVersion
- (void)saveDataVersionWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;

//下载Picture
//读数据库数据
- (int)readDataVersionFromLoginResult;
- (NSMutableArray *)readLoginUser;
- (NSMutableArray *)readMaterialCatalogs;
- (NSMutableArray *)readMaterials;
- (NSMutableArray *)readMaterialPictures;
- (NSMutableArray *)readPlanCatalogs;
- (NSMutableArray *)readPlans;
- (NSMutableArray *)readPlanPictures;
- (NSMutableArray *)readScrollPictures;
- (NSMutableArray *)readParties;
- (NSMutableArray *)readIntroductionCatalogs;
- (NSMutableArray *)readIntroductions;
- (NSMutableArray *)readWritingCatalogs;
- (NSMutableArray *)readWritings;
- (NSMutableArray *)readWritingPictures;
- (NSMutableArray *)readAnnouncements;
- (NSMutableArray *)readProjectCatalogs;
- (NSMutableArray *)readProjectPictures;
- (int)readDataVersionFromBaseData;//baseData表中的DataVersion
@end

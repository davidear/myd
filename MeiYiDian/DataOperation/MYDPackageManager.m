//
//  MYDPackageManager.m
//  MeiYiDian
//
//  Created by dfy on 15/1/6.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDPackageManager.h"
#import "DDXML.h"
#import "MYDDBManager.h"
#import "MYDConfig.h"
#import "SDImageCache.h"

@implementation MYDPackageManager
#pragma mark - 单例
static MYDPackageManager *instant = nil;
+(MYDPackageManager *)getInstant
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

#pragma mark - XML解包
- (BOOL)unpackLoginBag:(NSString *)responseString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:responseString];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Body>"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<LoginResponse xmlns=\"http://tempuri.org/\">"]];
    
    
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"</LoginResponse></soap:Body></soap:Envelope>"]];
    NSError *error = nil;
    DDXMLDocument *XMLDocument = [[DDXMLDocument alloc] initWithXMLString:mutableString options:0 error:&error];
    
    //开始通过XPath取数据并使用fmdb操作
    //child.XMLString   <Succeed>true</Succeed>
    //DDXMLNode的name为标签，这里是 Succeed，而stringValue为值,这里是true
    
    
    //换一种思维，当出现多用户切换的时候，如何处理，这里采用根据departmentId来命名数据库，将departmentId存入userdefaults.
    DDXMLNode *child = (DDXMLNode *)[[XMLDocument nodesForXPath:@"//LoginResult/Succeed" error:nil] objectAtIndex:0];
    if ([child.stringValue isEqualToString:@"true"]) {
        //存userdefaults
        
        NSString *DataVersionStr = ((DDXMLNode *)[[XMLDocument nodesForXPath:@"//LoginResult/DataVersion" error:nil] lastObject]).stringValue;
        NSString *DepartmentId = ((DDXMLNode *)[[XMLDocument nodesForXPath:@"//LoginResult/DepartmentId" error:nil] lastObject]).stringValue;
//        //表里只有一个元素，然后我希望每次直接更新这个元素，始终只有一个元素，我目前方法是使用Success来定位
//        NSString *Success = @"true";
        
        //为什么用NSUserDefaults，因为要跟MYDDbManager传值，在一开始就是用NSUserDefaults中的DepartmentId来判定是否创建新数据库
        [[NSUserDefaults standardUserDefaults] setObject:DepartmentId forKey:@"DepartmentId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[MYDDBManager getInstant] saveLoginResultWithDataVersion:[DataVersionStr intValue] DepartmentId:DepartmentId];
        return YES;
    }else{
        return NO;
    }
}

- (void)unpackDataVersionBag:(NSString *)responseString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:responseString];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Body>"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<DataVersionResponse xmlns=\"http://tempuri.org/\">"]];
    
    
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"</DataVersionResponse></soap:Body></soap:Envelope>"]];
    NSError *error = nil;
    DDXMLDocument *XMLDocument = [[DDXMLDocument alloc] initWithXMLString:mutableString options:0 error:&error];
    
//    DDXMLNode *child = (DDXMLNode *)[[XMLDocument nodesForXPath:@"//DataVersionResult" error:nil] objectAtIndex:0];
//    

    NSString *DataVersionStr = ((DDXMLNode *)[[XMLDocument nodesForXPath:@"//LoginResult/DataVersion" error:nil] lastObject]).stringValue;
//        //表里只有一个元素，然后我希望每次直接更新这个元素，始终只有一个元素，我目前方法是使用Success来定位
//        NSString *Success = @"true";
    if (DataVersionStr != nil) {
        [[MYDDBManager getInstant] saveDataVersionWithDataVersion:[DataVersionStr intValue]];
    }
        
        
        /*
        //操作数据库
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
        
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
        if (![db open]) {
            NSLog(@"Could not open db.");
            return ;
        }
        
        //为数据库设置缓存，提高查询效率
        [db setShouldCacheStatements:YES];
        if (![db tableExists:@"departmentIdTable"]) {
            NSLog(@"no departmentIdTable");
            return;
        }
        
        //现在表中查询有没有该条记录，有则操作
        FMResultSet *rs = [db executeQuery:@"select * from departmentIdTable where Success = ?",Success];
        if ([rs next]) {
            [db executeUpdate:@"update departmentIdTable set DataVersion = ? where Success = ?",DataVersion,Success];
        }

        FMResultSet *rs2 = [db executeQuery:@"SELECT * FROM departmentIdTable"];
        
        while ([rs2 next]) {
            NSLog(@"DateVersion is %d",[rs2 intForColumn:@"DataVersion"]);
        }
        */
}

- (void)unpackBaseDataBag:(NSString *)responseString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:responseString];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Body>"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<GetBaseDataResponse xmlns=\"http://tempuri.org/\">"]];
    
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"</GetBaseDataResponse></soap:Body></soap:Envelope>"]];
    NSError *error = nil;
    DDXMLDocument *XMLDocument = [[DDXMLDocument alloc] initWithXMLString:mutableString options:0 error:&error];
    
    [self readLoginUserWithXMLDocument:XMLDocument];
    [self readMaterialCatalogsWithXMLDocument:XMLDocument];
    [self readMaterialsWithXMLDocument:XMLDocument];
    [self readMaterialPicturesWithXMLDocument:XMLDocument];
    [self readPlanCatalogsWithXMLDocument:XMLDocument];
    [self readPlansWithXMLDocument:XMLDocument];
    [self readPlanPicturesWithXMLDocument:XMLDocument];
    [self readScrollPicturesWithXMLDocument:XMLDocument];
    [self readPartiesWithXMLDocument:XMLDocument];
    [self readIntroductionCatalogsWithXMLDocument:XMLDocument];
    [self readIntroductionsWithXMLDocument:XMLDocument];
    [self readWritingCatalogsWithXMLDocument:XMLDocument];
    [self readWritingsWithXMLDocument:XMLDocument];
    [self readWritingPicturesWithXMLDocument:XMLDocument];
    [self readAnnouncementsWithXMLDocument:XMLDocument];
    [self readProjectCatalogsWithXMLDocument:XMLDocument];
    [self readProjectsWithXMLDocument:XMLDocument];
    [self readProjectPicturesWithXMLDocument:XMLDocument];
    [self readDataVersionWithXMLDocument:XMLDocument];
    
    
    
}

- (void)unpackPictureBag:(NSString *)responseString fileName:(NSString *)fileName
{
    NSMutableString *mutableString = [NSMutableString stringWithString:responseString];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"]];
    [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Body>"]];
    
    //无GetPictureResult时，其数据结构有异，所以做判断
    NSRange range = [mutableString rangeOfString:@"<GetPictureResponse xmlns=\"http://tempuri.org/\" />"];
    if (range.length != 0) {
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<GetPictureResponse xmlns=\"http://tempuri.org/\" />"]];
    }else{
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<GetPictureResponse xmlns=\"http://tempuri.org/\">"]];
    }
    NSRange range1 = [mutableString rangeOfString:@"</GetPictureResponse></soap:Body></soap:Envelope>"];
    if (range1.length != 0) {
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"</GetPictureResponse></soap:Body></soap:Envelope>"]];
    }else{
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"</soap:Body></soap:Envelope>"]];
    }
//    if ([mutableString containsString:@"<GetPictureResponse xmlns=\"http://tempuri.org/\" />"]) {
//        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<GetPictureResponse xmlns=\"http://tempuri.org/\" />"]];
//    }else{
//        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<GetPictureResponse xmlns=\"http://tempuri.org/\">"]];
//    }
//    if ([mutableString containsString:@"</GetPictureResponse></soap:Body></soap:Envelope>"]) {
//        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"</GetPictureResponse></soap:Body></soap:Envelope>"]];
//    }else{
//        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"</soap:Body></soap:Envelope>"]];
//    }
    
    NSError *error = nil;
    DDXMLDocument *XMLDocument = [[DDXMLDocument alloc] initWithXMLString:mutableString options:0 error:&error];
    
    DDXMLNode *child = (DDXMLNode *)[[XMLDocument nodesForXPath:@"//GetPictureResult" error:nil] objectAtIndex:0];
    if (child == nil) {
        return;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:child.stringValue options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [[UIImage alloc] initWithData:data];
    [[SDImageCache sharedImageCache] storeImage:image forKey:fileName toDisk:YES];
}
#pragma mark - 分解baseData的数据读取
#pragma mark 基础方法
- (NSMutableArray *)dicArrayWithStringArray:(NSArray *)array xPathHeader:(NSString *)xPathHeader XMLDocument:(DDXMLDocument *)XMLDocument
{
    NSString *xPath;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        xPath = [NSString stringWithFormat:@"%@%@",xPathHeader,array[i]];
        NSArray *nodeArray = [XMLDocument nodesForXPath:xPath error:nil];
        for (int j = 0; j < nodeArray.count; j++) {
            DDXMLNode *node = nodeArray[j];
            if ([array[i] isEqualToString:@"Id"] | [array[i] isEqualToString:@"DataVersion"]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [mutableArray addObject:dic];
            }
            [mutableArray[j] setObject:node.stringValue forKey:array[i]];
        }
    }
    return mutableArray;
}
#pragma mark 具体方法
- (void)readLoginUserWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"PasswordHash",@"PasswordSalt",@"FirstLastName",@"Qq",@"WeiXing",@"Email",@"Tel",@"DepartmentId",@"DepartmentName"];
    NSString *xPath;
    DDXMLNode *node;
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    for (NSString *str in LoginUserKeyArray) {
        xPath = [NSString stringWithFormat:@"//LoginUser/%@",str];
        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
        [mutableDictionary setObject:node.stringValue forKey:str];
    }
    [[MYDDBManager getInstant] saveLoginUserWithDic:mutableDictionary keyArrayForDic:LoginUserKeyArray];

}

- (void)readMaterialCatalogsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"ParentId",@"OrderCode"];
//    NSString *xPath;
////    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    for (int i = 0; i < array.count; i++) {
//        xPath = [NSString stringWithFormat:@"//MaterialCatalogs/MaterialCatalogEntity/%@",array[i]];
//        NSArray *nodeArray = [XMLDocument nodesForXPath:xPath error:nil];
//        for (int j = 0; j < nodeArray.count; j++) {
//            DDXMLNode *node = nodeArray[j];
//            if ([array[i] isEqualToString:@"Id"]) {
//                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                [mutableArray addObject:dic];
//            }
//            [mutableArray[j] setObject:node.stringValue forKey:array[i]];
//        }
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:MaterialCatalogsKeyArray xPathHeader:@"//MaterialCatalogs/MaterialCatalogEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveMaterialCatalogsWithDicArray:mutableArray keyArrayForDic:MaterialCatalogsKeyArray];
}

- (void)readMaterialsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"CatalogId",@"UnitName",@"StandardName",@"Price",@"TypeCodeX",@"OrderCode",@"TitlePictureFileName",@"Description"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//Materials/MaterialEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:MaterialsKeyArray xPathHeader:@"//Materials/MaterialEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveMaterialsWithDicArray:mutableArray keyArrayForDic:MaterialsKeyArray];

}

- (void)readMaterialPicturesWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"CatalogId",@"FKId",@"FileName",@"Description",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//MaterialPictures/PictureEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:PicturesKeyArray xPathHeader:@"//MaterialPictures/PictureEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveMaterialPicturesWithDicArray:mutableArray keyArrayForDic:PicturesKeyArray];

}

//PlanCatalogEntity
/*
 <PlanCatalogEntity>
 <Id>bfd767a6-1922-420c-8f12-189d7b61b4b1</Id>
 <Name>111</Name>
 <Code>CPLB-0000001</Code>
 <ParentId>00000000-0000-0000-0000-000000000000</ParentId>
 <OrderCode>1</OrderCode>
 </PlanCatalogEntity>
*/
- (void)readPlanCatalogsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"ParentId",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//PlanCatalogs/PlanCatalogEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:PlanCatalogsKeyArray xPathHeader:@"//PlanCatalogs/PlanCatalogEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] savePlanCatalogsWithDicArray:mutableArray keyArrayForDic:PlanCatalogsKeyArray];
}
//PlanEntity
/*
 <PlanEntity>
 <Id>5cd471e1-d210-4b20-85e5-5e28c7f50511</Id>
 <Name>12WQ</Name>
 <Code>CPB-0000002</Code>
 <CatalogId>bfd767a6-1922-420c-8f12-189d7b61b4b1</CatalogId>
 <Price>90.00</Price>
 <ProjectId>00000000-0000-0000-0000-000000000000</ProjectId>
 <OrderCode>2</OrderCode>
 <TitlePictureFileName>Title_5926d0b8-d467-4a32-95ba-85d1a317dd4a.png</TitlePictureFileName>
 <Description>Q</Description>
 </PlanEntity>
 */
- (void)readPlansWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"CatalogId",@"Price",@"ProjectId",@"OrderCode",@"TitlePictureFileName",@"Description"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//Plans/PlanEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:PlansKeyArray xPathHeader:@"//Plans/PlanEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] savePlansWithDicArray:mutableArray keyArrayForDic:PlansKeyArray];
}

- (void)readPlanPicturesWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"CatalogId",@"FKId",@"FileName",@"Description",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//PlanPictures/PictureEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:PicturesKeyArray xPathHeader:@"//PlanPictures/PictureEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] savePlanPicturesWithDicArray:mutableArray keyArrayForDic:PicturesKeyArray];

}

- (void)readScrollPicturesWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"CatalogId",@"FKId",@"FileName",@"Description",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//ScrollPictures/PictureEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:PicturesKeyArray xPathHeader:@"//ScrollPictures/PictureEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveScrollPicturesWithDicArray:mutableArray keyArrayForDic:PicturesKeyArray];
}

/*
 <PartyEntity>
 <Id>48749750-960d-4887-9c3d-5d6b9a422e24</Id>
 <Name>风格美容2周年店庆</Name>
 <Code/>
 <Content>&lt;p&gt;
 &lt;img alt="" src="/content/TempFiles/6c758ef2-a041-4a52-bef5-857fcef5b5b9userfiles/images/4898351_093818085054_2.jpg" style="width: 1024px; height: 768px" /&gt;&lt;/p&gt;
 </Content>
 <OrderCode>1</OrderCode>
 </PartyEntity>
 */
- (void)readPartiesWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"Content",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//Parties/PartyEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:PartiesKeyArray xPathHeader:@"//Parties/PartyEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] savePartiesWithDicArray:mutableArray keyArrayForDic:PartiesKeyArray];

}
//IntroductionCatalogs
/*
 <IntroductionCatalogEntity>
 <Id>eeb312e0-5805-4d3c-a6ac-e9ee9bc1fb71</Id>
 <Name>企业简介</Name>
 <Code>JSLB-0000001</Code>
 <OrderCode>1</OrderCode>
 </IntroductionCatalogEntity>
*/
- (void)readIntroductionCatalogsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//IntroductionCatalogs/IntroductionCatalogEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:CatalogsKeyArray xPathHeader:@"//IntroductionCatalogs/IntroductionCatalogEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveIntroductionCatalogsWithDicArray:mutableArray keyArrayForDic:CatalogsKeyArray];

}
//Introductions
/*
 <IntroductionEntity>
 <Id>7a093741-a655-455b-984d-9094762a96d3</Id>
 <CatalogId>5d4fd4b8-6e14-4dd4-945b-40b2cbadbb8d</CatalogId>
 <OrderCode>3</OrderCode>
 </IntroductionEntity>
 */
- (void)readIntroductionsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"CatalogId",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//Introductions/IntroductionEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:IntroductionsKeyArray xPathHeader:@"//Introductions/IntroductionEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveIntroductionsWithDicArray:mutableArray keyArrayForDic:IntroductionsKeyArray];
}
//WritingCatalogs
/*
 <WritingCatalogEntity>
 <Id>affec015-0e3a-465d-bfa3-927830d48c7d</Id>
 <Name>美发</Name>
 <Code>ZPLB-0000001</Code>
 <OrderCode>1</OrderCode>
 </WritingCatalogEntity>
 */
- (void)readWritingCatalogsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//WritingCatalogs/WritingCatalogEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:CatalogsKeyArray xPathHeader:@"//WritingCatalogs/WritingCatalogEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveWritingCatalogsWithDicArray:mutableArray keyArrayForDic:CatalogsKeyArray];

}

//Writings
/*
 <WritingEntity>
 <Id>26c2d039-beac-4bc6-9f15-aa3e95e70057</Id>
 <CatalogId>affec015-0e3a-465d-bfa3-927830d48c7d</CatalogId>
 <Title>波波</Title>
 <OrderCode>1</OrderCode>
 <TitlePictureFileName>Title_fa405a1f-0ed8-47f4-b120-959aa873091b.jpg</TitlePictureFileName>
 </WritingEntity>
 */
- (void)readWritingsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"CatalogId",@"Title",@"OrderCode",@"TitlePictureFileName"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//Writings/WritingEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:WritingsKeyArray xPathHeader:@"//Writings/WritingEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveWritingsWithDicArray:mutableArray keyArrayForDic:WritingsKeyArray];

}

//WritingPictures
/*
 <PictureEntity>
 <Id>085fe9ad-20dc-4eed-b621-7e621ce87823</Id>
 <CatalogId>00000000-0000-0000-0000-000000000000</CatalogId>
 <FKId>26c2d039-beac-4bc6-9f15-aa3e95e70057</FKId>
 <FileName>d38fc6f7-f240-4fb9-9f22-d453f0854d0f.jpg</FileName>
 <Description/>
 <OrderCode>1</OrderCode>
 </PictureEntity>
 */
- (void)readWritingPicturesWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"CatalogId",@"FKId",@"FileName",@"Description",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//WritingPictures/PictureEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:PicturesKeyArray xPathHeader:@"//WritingPictures/PictureEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveWritingPicturesWithDicArray:mutableArray keyArrayForDic:PicturesKeyArray];
}

//Announcements
/*
 <AnnouncementEntity>
 <Id>7031f1e3-578d-407e-a2c1-060af72deb6c</Id>
 <Title>热烈庆祝美易点智能接待系统正式上线！</Title>
 <Content>大df震荡左左基基载震荡地大工</Content>
 <OrderCode>1</OrderCode>
 </AnnouncementEntity>
 */
- (void)readAnnouncementsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Title",@"Content",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//Announcements/AnnouncementEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:AnnouncementsKeyArray xPathHeader:@"//Announcements/AnnouncementEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveAnnouncementsWithDicArray:mutableArray keyArrayForDic:AnnouncementsKeyArray];
    
}

//ProjectCatalogs
/*
 <ProjectCatalogEntity>
 <Id>d7603b0f-1abc-4353-80f7-bc8d76632c40</Id>
 <Name>面部护理</Name>
 <Code>WLB-0000001</Code>
 <ParentId>00000000-0000-0000-0000-000000000000</ParentId>
 <OrderCode>1</OrderCode>
 </ProjectCatalogEntity>
*/
- (void)readProjectCatalogsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"ParentId",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//ProjectCatalogs/ProjectCatalogEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:CatalogsKeyArray xPathHeader:@"//ProjectCatalogs/ProjectCatalogEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveProjectCatalogsWithDicArray:mutableArray keyArrayForDic:CatalogsKeyArray];
    
}

//Projects
/*
 <ProjectEntity>
 <Id>bcdff309-01e2-4aaa-8c3b-9cedde11acdd</Id>
 <CatalogId>d7603b0f-1abc-4353-80f7-bc8d76632c40</CatalogId>
 <Name>三合一鸡尾酒面部护理---水凝保湿系列</Name>
 <Description>时    间：2小时
 
 推荐指数：★★★★★
 
 疗程推荐：   2次/周
 
 特    色：拥有卓越的锁水能力，改善皮肤因干燥而引起的疲倦状态，提高皮肤自身吸收能力，使肌肤水润光洁，面色饱满红润。
 
 针对人群：主要针对于紧肤缺水、干燥、易起皮屑、皮肤松弛、经常面对电脑等人群
 我四大护法iohdfaihdfia是的粉红色的佛阿三 大宋饭后爱的回复哦碍事的阿三大佛爱说大话覅上的佛啊四大活佛isdfiohd阿斯顿和覅是覅哦电话费啊送到覅哦啊是到哈佛iahdihdfoid
 圣诞节覅哦啊s
 简单的都</Description>
 <Code>XMB-0000001</Code>
 <OrderCode>1</OrderCode>
 <TitlePictureFileName>Title_82ad2f25-e329-4f9a-992f-9f1cdeb3da96.jpg</TitlePictureFileName>
 <UnitName/>
 <StandardName/>
 <Price>298.00</Price>
 </ProjectEntity>
*/
- (void)readProjectsWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"Name",@"Code",@"CatalogId",@"UnitName",@"StandardName",@"Price",@"OrderCode",@"TitlePictureFileName",@"Description"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//Projects/ProjectEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }

    NSMutableArray *mutableArray = [self dicArrayWithStringArray:ProjectsKeyArray xPathHeader:@"//Projects/ProjectEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveProjectsWithDicArray:mutableArray keyArrayForDic:ProjectsKeyArray];
    
}

//ProjectPictures
/*
 <ProjectPictureEntity>
 <Id>3cd382d3-f609-4db5-87bb-8bf47ddc1737</Id>
 <CatalogId>d7603b0f-1abc-4353-80f7-bc8d76632c40</CatalogId>
 <FKId>bcdff309-01e2-4aaa-8c3b-9cedde11acdd</FKId>
 <FileName>0143368f-5d11-4753-8ea6-9a3179a3dbe9.jpg</FileName>
 <Description/>
 <OrderCode>1</OrderCode>
 </ProjectPictureEntity>
 */
- (void)readProjectPicturesWithXMLDocument:(DDXMLDocument *)XMLDocument
{
//    NSArray *array = @[@"Id",@"CatalogId",@"FKId",@"FileName",@"Description",@"OrderCode"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//ProjectPictures/ProjectPictureEntity/%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:PicturesKeyArray xPathHeader:@"//ProjectPictures/ProjectPictureEntity/" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveProjectPicturesWithDicArray:mutableArray keyArrayForDic:PicturesKeyArray];
}
//DataVersion
//<DataVersion>121</DataVersion>
- (void)readDataVersionWithXMLDocument:(DDXMLDocument *)XMLDocument
{
    NSArray *array = @[@"DataVersion"];
//    NSString *xPath;
//    DDXMLNode *node;
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (NSString *str in array) {
//        xPath = [NSString stringWithFormat:@"//%@",str];
//        node = (DDXMLNode *)[[XMLDocument nodesForXPath:xPath error:nil] lastObject];
//        [mutableDictionary setObject:node.stringValue forKey:str];
//    }
    NSMutableArray *mutableArray = [self dicArrayWithStringArray:array xPathHeader:@"//" XMLDocument:XMLDocument];
    [[MYDDBManager getInstant] saveDataVersionWithDicArray:mutableArray keyArrayForDic:array];
}
@end

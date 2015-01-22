//
//  MYDDBManager.m
//  MeiYiDian
//
//  Created by dfy on 15/1/9.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDDBManager.h"
#import "FMDB.h"
#import "MYDConfig.h"

@implementation MYDDBManager
{
    NSString *_dbPath;
    FMDatabase *_db;
    FMDatabaseQueue *_queue;
}
#pragma mark - 单例
static MYDDBManager *instant = nil;
+(MYDDBManager *)getInstant
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
        //操作数据库
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        //调试期先写死
//        NSString *dataBaseName = [NSString stringWithFormat:@"%@_Database.db",[[NSUserDefaults standardUserDefaults] objectForKey:@"DepartmentId"]];
//        _dbPath = [documentDirectory stringByAppendingPathComponent:dataBaseName];
        _dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDataBase.db"];
        _db = [FMDatabase databaseWithPath:_dbPath];
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

#pragma mark - 数据库操作
- (BOOL)openDB
{
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO;
    }
    //为数据库设置缓存，提高查询效率
    [_db setShouldCacheStatements:YES];
    return YES;
}

- (BOOL)closeDB
{
    if (![_db close]) {
        NSLog(@"Could not close db.");
        return NO;
    }
    return YES;
}

//登录返回转存数据库
- (void)saveLoginResultWithDataVersion:(int)dataVersion DepartmentId:(NSString *)departmentId
{
    if (![self openDB]) {
        return;
    }
    //表里只有一个元素，然后我希望每次直接更新这个元素，始终只有一个元素，我目前方法是使用Success来定位
    NSString *Success = @"true";
    //创建表格
    if (![_db tableExists:@"LoginResult"]) {
        [_db executeUpdate:@"CREATE TABLE LoginResult (DepartmentId text, DataVersion integer, Success text)"];
    }
    //现在表中查询有没有相同的元素，如果有，做修改操作
    FMResultSet *rs = [_db executeQuery:@"select * from LoginResult where Success = ?",Success];
    if ([rs next]) {
        [_db executeUpdate:@"update LoginResult set DepartmentId = ?, DataVersion = ?, Success = ?",departmentId,[NSNumber numberWithInt:dataVersion],Success];
    }else{
        [_db executeUpdate:@"INSERT INTO LoginResult (DepartmentId,DataVersion,Success) VALUES (?,?,?)", departmentId, [NSNumber numberWithInt:dataVersion], Success];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM LoginResult"];
    
    while ([rs2 next]) {
        NSLog(@"DataVersion is %d,DepartmentId is %@",[rs2 intForColumn:@"DataVersion"],[rs2 stringForColumn:@"DepartmentId"]);
    }
    
    [self closeDB];
    
}

//查dataVersion返回转存数据库
- (void)saveDataVersionWithDataVersion:(int)dataVersion
{
    if (![self openDB]) {
        return;
    }
    //表里只有一个元素，然后我希望每次直接更新这个元素，始终只有一个元素，我目前方法是使用Success来定位
    NSString *Success = @"true";
    //创建表格
    if (![_db tableExists:@"LoginResult"]) {
        [_db executeUpdate:@"CREATE TABLE LoginResult (DepartmentId text, DataVersion integer, Success text)"];
    }
    
    //为数据库设置缓存，提高查询效率
    [_db setShouldCacheStatements:YES];
    if (![_db tableExists:@"LoginResult"]) {
        NSLog(@"no LoginResult");
        return;
    }
    
    //现在表中查询有没有该条记录，有则操作
    FMResultSet *rs = [_db executeQuery:@"select * from LoginResult where Success = ?",Success];
    if ([rs next]) {
        [_db executeUpdate:@"update LoginResult set DataVersion = ? where Success = ?",[NSNumber numberWithInt:dataVersion],Success];
    }
    [rs close];
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM LoginResult"];
    
    while ([rs2 next]) {
        NSLog(@"DataVersion is %d",[rs2 intForColumn:@"DataVersion"]);
    }
    [rs2 close];
    [self closeDB];
}

#pragma mark baseData
/*
 /// <summary>
 /// 登录用户。
 /// </summary>
public class LoginUser
{
    /// <summary>
    /// 用户唯一编号。
    /// </summary>
    public Guid Id { get; set; }
    
    /// <summary>
    /// 登录用户名。
    /// </summary>
    public string Name { get; set; }
    
    /// <summary>
    /// 密码hash。
    /// </summary>
    public string PasswordHash { get; set; }
    
    /// <summary>
    /// 密码slat，用户登录验证 md5( 密码明文 + salt) == hash
    /// </summary>
    public string PasswordSalt { get; set; }
    
    /// <summary>
    /// 用户姓名。
    /// </summary>
    public string FirstLastName { get; set; }
    
    /// <summary>
    /// QQ
    /// </summary>
    public string Qq { get; set; }
    
    /// <summary>
    /// 微信号。
    /// </summary>
    public string WeiXing { get; set; }
    
    /// <summary>
    /// 邮箱。
    /// </summary>
    public string Email { get; set; }
    
    /// <summary>
    /// 电话。
    /// </summary>
    public string Tel { get; set; }
    
    /// <summary>
    /// 门店编号。
    /// </summary>
    public Guid DepartmentId{ get; set; }
    
    /// <summary>
    /// 门店名称。
    /// </summary>
    public string DepartmentName { get; set; }
}
 */
- (void)saveLoginUserWithDic:(NSMutableDictionary *)dic keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"LoginUser"]) {
        [_db executeUpdate:@"CREATE TABLE LoginUser (Id text, Name text, PasswordHash text, PasswordSalt text, FirstLastName text, Qq text, WeiXing text, Email text, Tel text, DepartmentId text, DepartmentName text)"];
    }
//    现在表中查询有没有相同的元素，如果有，做修改操作
    FMResultSet *rs = [_db executeQuery:@"select * from LoginUser where Id = ?",[dic objectForKey:@"Id"]];
    if ([rs next]) {
        for (NSString *str in keyArray) {
            NSString *tempStr = [NSString stringWithFormat:@"update LoginUser set %@ = ? where Id = ?",str];
            [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
        }
    }else {
        [_db executeUpdate:@"INSERT INTO LoginUser (Id,Name,PasswordHash,PasswordSalt,FirstLastName,Qq,WeiXing,Email,Tel,DepartmentId,DepartmentName) VALUES (?,?,?,?,?,?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"PasswordHash"],[dic objectForKey:@"PasswordSalt"],[dic objectForKey:@"FirstLastName"],[dic objectForKey:@"Qq"],[dic objectForKey:@"WeiXing"],[dic objectForKey:@"Email"],[dic objectForKey:@"Tel"],[dic objectForKey:@"DepartmentId"],[dic objectForKey:@"DepartmentName"]];
    }
    [rs close];
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM LoginUser"];
    
    while ([rs2 next]) {
        NSLog(@"DepartmentId is %@",[rs2 stringForColumn:@"DepartmentId"]);
    }
    [rs2 close];
    [self closeDB];
}
/*
 /// <summary>
 /// 产品分类。
 /// </summary>
 public class MaterialCatalogEntity
 {
 /// <summary>
 /// 唯一ID。
 /// </summary>
 public Guid Id { get; set; }
 
 /// <summary>
 /// 名称。
 /// </summary>
 public string Name { get; set; }
 
 /// <summary>
 /// 编码。
 /// </summary>
 public string Code { get; set; }
 
 /// <summary>
 /// 父编号，使用该编号查找父分类。
 /// </summary>
 public Guid ParentId { get; set; }
 
 /// <summary>
 /// 排序编号。
 /// </summary>
 public int OrderCode { get; set; }
 
 }
 */
- (void)saveMaterialCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"MaterialCatalogs"]) {
        [_db executeUpdate:@"CREATE TABLE MaterialCatalogs (Id text, Name text, Code text, ParentId text, OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from MaterialCatalogs where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update MaterialCatalogs set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO MaterialCatalogs (Id,Name,Code,ParentId,OrderCode) VALUES (?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[dic objectForKey:@"ParentId"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"] intValue]]];
        }
        [rs close];
    }
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM MaterialCatalogs"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
}

/*
 /// <summary>
 /// 产品。
 /// </summary>
 public class MaterialEntity
 {
 /// <summary>
 /// 唯一ID。
 /// </summary>
 public Guid Id { get; set; }
 
 /// <summary>
 /// 名称。
 /// </summary>
 public string Name { get; set; }
 
 /// <summary>
 /// 编码。
 /// </summary>
 public string Code { get; set; }
 
 /// <summary>
 /// 分类编号。
 /// </summary>
 public Guid CatalogId { get; set; }
 
 /// <summary>
 /// 单位。
 /// </summary>
 public string UnitName { get; set; }
 
 /// <summary>
 /// 规格。
 /// </summary>
 public string StandardName { get; set; }
 
 /// <summary>
 /// 单价。
 /// </summary>
 public decimal Price { get; set; }
 
 /// <summary>
 /// 类型编号， 标识是服务还是产品。
 /// </summary>
 public string TypeCodeX { get; set; }
 
 /// <summary>
 /// 排序编号。
 /// </summary>
 public int OrderCode { get; set; }
 
 /// <summary>
 /// 封面图片。
 /// </summary>
 public string TitlePictureFileName { get; set; }
 
 /// <summary>
 /// 描述。
 /// </summary>
 public string Description { get; set; }
 }
 */
- (void)saveMaterialsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"Materials"]) {
        [_db executeUpdate:@"CREATE TABLE Materials (Id text, Name text, Code text, CatalogId text, UnitName text, StandardName text, Price float, TypeCodeX text, OrderCode integer, TitlePictureFileName text, Description text)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from Materials where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update Materials set %@ = ? where Id = ?",str];
                if ([str isEqualToString:@"Price"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] floatValue]],[dic objectForKey:@"Id"]];
                }else if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO Materials (Id,Name,Code,CatalogId,UnitName,StandardName,Price,TypeCodeX,OrderCode,TitlePictureFileName,Description) VALUES (?,?,?,?,?,?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[dic objectForKey:@"CatalogId"],[dic objectForKey:@"UnitName"],[dic objectForKey:@"StandardName"],[NSNumber numberWithInt:[[dic objectForKey:@"Price"] floatValue]],[dic objectForKey:@"TypeCodeX"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]],[dic objectForKey:@"TitlePictureFileName"],[dic objectForKey:@"Description"]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM Materials"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
}
/*
 <PictureEntity>
 <Id>7eadcefc-286d-472f-86f5-630438cf01e7</Id>
 <CatalogId>619e40bd-1e1e-43f4-8a2c-3aa2626c48ad</CatalogId>
 <FKId>106761c8-037f-46d1-9404-306f90792758</FKId>
 <FileName>be685f13-4e69-4308-85e5-3b273e31c204.jpg</FileName>
 <Description/>
 <OrderCode>1</OrderCode>
 </PictureEntity>
 */
- (void)saveMaterialPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"MaterialPictures"]) {
        [_db executeUpdate:@"CREATE TABLE MaterialPictures (Id text, CatalogId text, FKId text, FileName text, Description text,  OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from MaterialPictures where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update MaterialPictures set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO MaterialPictures (Id,CatalogId,FKId,FileName,Description,OrderCode) VALUES (?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"CatalogId"],[dic objectForKey:@"FKId"],[dic objectForKey:@"FileName"],[dic objectForKey:@"Description"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"] intValue]]];
        }
        [rs close];
    }
        FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM MaterialPictures"];
    
    while ([rs2 next]) {
        NSLog(@"CatalogId is %@",[rs2 stringForColumn:@"CatalogId"]);
    }
    [rs2 close];
    [self closeDB];
}

/*
 <PlanCatalogEntity>
 <Id>bfd767a6-1922-420c-8f12-189d7b61b4b1</Id>
 <Name>111</Name>
 <Code>CPLB-0000001</Code>
 <ParentId>00000000-0000-0000-0000-000000000000</ParentId>
 <OrderCode>1</OrderCode>
 </PlanCatalogEntity>
 */
- (void)savePlanCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"PlanCatalogs"]) {
        [_db executeUpdate:@"CREATE TABLE PlanCatalogs (Id text, Name text, Code text, ParentId text, OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from PlanCatalogs where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update PlanCatalogs set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO PlanCatalogs (Id,Name,Code,ParentId,OrderCode) VALUES (?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[dic objectForKey:@"ParentId"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"] intValue]]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM PlanCatalogs"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
}

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
- (void)savePlansWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"Plans"]) {
        [_db executeUpdate:@"CREATE TABLE Plans (Id text, Name text, Code text, CatalogId text,Price float, ProjectId text, OrderCode integer, TitlePictureFileName text, Description text)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from Plans where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update Plans set %@ = ? where Id = ?",str];
                if ([str isEqualToString:@"Price"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] floatValue]],[dic objectForKey:@"Id"]];
                }else if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO Plans (Id,Name,Code,CatalogId,Price,ProjectId,OrderCode,TitlePictureFileName,Description) VALUES (?,?,?,?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[dic objectForKey:@"CatalogId"],[NSNumber numberWithInt:[[dic objectForKey:@"Price"] floatValue]],[dic objectForKey:@"ProjectId"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]],[dic objectForKey:@"TitlePictureFileName"],[dic objectForKey:@"Description"]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM Plans"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
}

/*
 <PictureEntity>
 <Id>7eadcefc-286d-472f-86f5-630438cf01e7</Id>
 <CatalogId>619e40bd-1e1e-43f4-8a2c-3aa2626c48ad</CatalogId>
 <FKId>106761c8-037f-46d1-9404-306f90792758</FKId>
 <FileName>be685f13-4e69-4308-85e5-3b273e31c204.jpg</FileName>
 <Description/>
 <OrderCode>1</OrderCode>
 </PictureEntity>
 */
- (void)savePlanPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"PlanPictures"]) {
        [_db executeUpdate:@"CREATE TABLE PlanPictures (Id text, CatalogId text, FKId text, FileName text, Description text,  OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from PlanPictures where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update PlanPictures set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO PlanPictures (Id,CatalogId,FKId,FileName,Description,OrderCode) VALUES (?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"CatalogId"],[dic objectForKey:@"FKId"],[dic objectForKey:@"FileName"],[dic objectForKey:@"Description"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"] intValue]]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM PlanPictures"];
    
    while ([rs2 next]) {
        NSLog(@"FileName is %@",[rs2 stringForColumn:@"FileName"]);
    }
    [rs2 close];
    [self closeDB];
}
/*
 <PictureEntity>
 <Id>7eadcefc-286d-472f-86f5-630438cf01e7</Id>
 <CatalogId>619e40bd-1e1e-43f4-8a2c-3aa2626c48ad</CatalogId>
 <FKId>106761c8-037f-46d1-9404-306f90792758</FKId>
 <FileName>be685f13-4e69-4308-85e5-3b273e31c204.jpg</FileName>
 <Description/>
 <OrderCode>1</OrderCode>
 </PictureEntity>
 */
- (void)saveScrollPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"ScrollPictures"]) {
        [_db executeUpdate:@"CREATE TABLE ScrollPictures (Id text, CatalogId text, FKId text, FileName text, Description text,  OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from ScrollPictures where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update ScrollPictures set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO ScrollPictures (Id,CatalogId,FKId,FileName,Description,OrderCode) VALUES (?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"CatalogId"],[dic objectForKey:@"FKId"],[dic objectForKey:@"FileName"],[dic objectForKey:@"Description"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"] intValue]]];
        }
        [rs close];
    }
        FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM ScrollPictures"];
    
    while ([rs2 next]) {
        NSLog(@"FileName is %@",[rs2 stringForColumn:@"FileName"]);
    }
    [rs2 close];
    [self closeDB];
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
- (void)savePartiesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"Parties"]) {
        [_db executeUpdate:@"CREATE TABLE Parties (Id text, Name text, Code text, Content text, OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from Parties where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update Parties set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO Parties (Id,Name,Code,Content,OrderCode) VALUES (?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[dic objectForKey:@"Content"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM Parties"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
}
/*
 <IntroductionCatalogEntity>
 <Id>eeb312e0-5805-4d3c-a6ac-e9ee9bc1fb71</Id>
 <Name>企业简介</Name>
 <Code>JSLB-0000001</Code>
 <OrderCode>1</OrderCode>
 </IntroductionCatalogEntity>
 */
- (void)saveIntroductionCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"IntroductionCatalogs"]) {
        [_db executeUpdate:@"CREATE TABLE IntroductionCatalogs (Id text, Name text, Code text, OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from IntroductionCatalogs where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update IntroductionCatalogs set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO IntroductionCatalogs (Id,Name,Code,OrderCode) VALUES (?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]]];
        }
        [rs close];
    }
    
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM IntroductionCatalogs"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
}
//Introductions
/*
 <IntroductionEntity>
 <Id>7a093741-a655-455b-984d-9094762a96d3</Id>
 <CatalogId>5d4fd4b8-6e14-4dd4-945b-40b2cbadbb8d</CatalogId>
 <OrderCode>3</OrderCode>
 </IntroductionEntity>
 */
- (void)saveIntroductionsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"Introductions"]) {
        [_db executeUpdate:@"CREATE TABLE Introductions (Id text, CatalogId text, OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from Introductions where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update Introductions set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO Introductions (Id,CatalogId,OrderCode) VALUES (?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"CatalogId"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]]];
        }
        [rs close];
    }
    
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM Introductions"];
    
    while ([rs2 next]) {
        NSLog(@"Id is %@",[rs2 stringForColumn:@"Id"]);
    }
    [rs2 close];
    [self closeDB];
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
- (void)saveWritingCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"WritingCatalogs"]) {
        [_db executeUpdate:@"CREATE TABLE WritingCatalogs (Id text, Name text, Code text, OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from WritingCatalogs where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update WritingCatalogs set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO WritingCatalogs (Id,Name,Code,OrderCode) VALUES (?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM WritingCatalogs"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
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
- (void)saveWritingsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"Writings"]) {
        [_db executeUpdate:@"CREATE TABLE Writings (Id text, CatalogId text, Title text, OrderCode integer, TitlePictureFileName text)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from Writings where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update Writings set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO Writings (Id,CatalogId,Title,OrderCode,TitlePictureFileName) VALUES (?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"CatalogId"],[dic objectForKey:@"Title"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]],[dic objectForKey:@"TitlePictureFileName"]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM Writings"];
    
    while ([rs2 next]) {
        NSLog(@"Title is %@",[rs2 stringForColumn:@"Title"]);
    }
    [rs2 close];
    [self closeDB];
}

//WritingPictures
/*
 <PictureEntity>
 <Id>7eadcefc-286d-472f-86f5-630438cf01e7</Id>
 <CatalogId>619e40bd-1e1e-43f4-8a2c-3aa2626c48ad</CatalogId>
 <FKId>106761c8-037f-46d1-9404-306f90792758</FKId>
 <FileName>be685f13-4e69-4308-85e5-3b273e31c204.jpg</FileName>
 <Description/>
 <OrderCode>1</OrderCode>
 </PictureEntity>
 */
- (void)saveWritingPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"WritingPictures"]) {
        [_db executeUpdate:@"CREATE TABLE WritingPictures (Id text, CatalogId text, FKId text, FileName text, Description text,  OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from WritingPictures where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update WritingPictures set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO WritingPictures (Id,CatalogId,FKId,FileName,Description,OrderCode) VALUES (?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"CatalogId"],[dic objectForKey:@"FKId"],[dic objectForKey:@"FileName"],[dic objectForKey:@"Description"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"] intValue]]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM WritingPictures"];
    
    while ([rs2 next]) {
        NSLog(@"FileName is %@",[rs2 stringForColumn:@"FileName"]);
    }
    [rs2 close];
    [self closeDB];
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
- (void)saveAnnouncementsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"Announcements"]) {
        [_db executeUpdate:@"CREATE TABLE Announcements (Id text, Title text, Content text, OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from Announcements where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update Announcements set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO Announcements (Id,Title,Content,OrderCode) VALUES (?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Title"],[dic objectForKey:@"Content"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]]];
        }
        [rs close];
    }
    
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM Announcements"];
    
    while ([rs2 next]) {
        NSLog(@"Title is %@",[rs2 stringForColumn:@"Title"]);
    }
    [rs2 close];
    [self closeDB];
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
- (void)saveProjectCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"ProjectCatalogs"]) {
        [_db executeUpdate:@"CREATE TABLE ProjectCatalogs (Id text, Name text, Code text, ParentId text, OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from ProjectCatalogs where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update ProjectCatalogs set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO ProjectCatalogs (Id,Name,Code,ParentId,OrderCode) VALUES (?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[dic objectForKey:@"ParentId"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM ProjectCatalogs"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
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
- (void)saveProjectsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"Projects"]) {
        [_db executeUpdate:@"CREATE TABLE Projects (Id text, Name text, Code text, CatalogId text, UnitName text, StandardName text, Price float, OrderCode integer, TitlePictureFileName text, Description text)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from Projects where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update Projects set %@ = ? where Id = ?",str];
                if ([str isEqualToString:@"Price"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] floatValue]],[dic objectForKey:@"Id"]];
                }else if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO Projects (Id,Name,Code,CatalogId,UnitName,StandardName,Price,OrderCode,TitlePictureFileName,Description) VALUES (?,?,?,?,?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"Code"],[dic objectForKey:@"CatalogId"],[dic objectForKey:@"UnitName"],[dic objectForKey:@"StandardName"],[NSNumber numberWithInt:[[dic objectForKey:@"Price"] floatValue]],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"]intValue]],[dic objectForKey:@"TitlePictureFileName"],[dic objectForKey:@"Description"]];
        }
        [rs close];
    }
    
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM Projects"];
    
    while ([rs2 next]) {
        NSLog(@"Name is %@",[rs2 stringForColumn:@"Name"]);
    }
    [rs2 close];
    [self closeDB];
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
- (void)saveProjectPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"ProjectPictures"]) {
        [_db executeUpdate:@"CREATE TABLE ProjectPictures (Id text, CatalogId text, FKId text, FileName text, Description text,  OrderCode integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from ProjectPictures where Id = ?",[dic objectForKey:@"Id"]];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update ProjectPictures set %@ = ? where Id = ?",str];
                if([str isEqualToString:@"OrderCode"]) {
                    [_db executeUpdate:tempStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]],[dic objectForKey:@"Id"]];
                }else {
                    [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
                }
            }
        }else {
            [_db executeUpdate:@"INSERT INTO ProjectPictures (Id,CatalogId,FKId,FileName,Description,OrderCode) VALUES (?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"CatalogId"],[dic objectForKey:@"FKId"],[dic objectForKey:@"FileName"],[dic objectForKey:@"Description"],[NSNumber numberWithInt:[[dic objectForKey:@"OrderCode"] intValue]]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM ProjectPictures"];
    
    while ([rs2 next]) {
        NSLog(@"FileName is %@",[rs2 stringForColumn:@"FileName"]);
    }
    [rs2 close];
    [self closeDB];
}

//DataVersion
//<DataVersion>121</DataVersion>
//该表有2个数据，一个Id，一个DataVersion，将Id一致置为ONLYONE;
- (void)saveDataVersionWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray
{
    NSString *onlyOneStr = @"ONLYONE";
    if (![self openDB]) {
        return;
    }
    //创建表格
    if (![_db tableExists:@"BaseDataVersion"]) {
        [_db executeUpdate:@"CREATE TABLE BaseDataVersion (Id text, DataVersion integer)"];
    }
    //    现在表中查询有没有相同的元素，如果有，做修改操作
    for (NSDictionary *dic in dicArray) {
        FMResultSet *rs = [_db executeQuery:@"select * from BaseDataVersion where Id = ?",onlyOneStr];
        if ([rs next]) {
            for (NSString *str in keyArray) {
                NSString *tempStr = [NSString stringWithFormat:@"update BaseDataVersion set %@ = ? where Id = ?",str];
                [_db executeUpdate:tempStr,onlyOneStr,[NSNumber numberWithInt:[[dic objectForKey:str] intValue]]];
            }
        }else {
            [_db executeUpdate:@"INSERT INTO BaseDataVersion (Id,DataVersion) VALUES (?,?)", onlyOneStr,[NSNumber numberWithInt:[[dic objectForKey:@"DataVersion"] intValue]]];
        }
        [rs close];
    }
    
    FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM BaseDataVersion"];
    
    while ([rs2 next]) {
        NSLog(@"DataVersion is %@",[rs2 stringForColumn:@"DataVersion"]);
    }
    [rs2 close];
    [self closeDB];
}
#pragma mark - 读数据库
//读数据库数据
- (int)readDataVersionFromLoginResult
{
    if (![self openDB]) {
        return 0;
    }
    if (![_db tableExists:@"LoginResult"]) {
        return 0;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from LoginResult"];
    if ([rs next]) {
        int DV = [[rs objectForColumnName:@"DataVersion"] intValue];
        [rs close];
        [self closeDB];
        return DV;
    }
    return 0;
}

- (NSMutableArray *)readLoginUser
{
    /*
     if (![self openDB]) {
     return;
     }
     //创建表格
     if (![_db tableExists:@"LoginUser"]) {
     [_db executeUpdate:@"CREATE TABLE LoginUser (Id text, Name text, PasswordHash text, PasswordSalt text, FirstLastName text, Qq text, WeiXing text, Email text, Tel text, DepartmentId text, DepartmentName text)"];
     }
     //    现在表中查询有没有相同的元素，如果有，做修改操作
     FMResultSet *rs = [_db executeQuery:@"select * from LoginUser where Id = ?",[dic objectForKey:@"Id"]];
     if ([rs next]) {
     for (NSString *str in keyArray) {
     NSString *tempStr = [NSString stringWithFormat:@"update LoginUser set %@ = ? where Id = ?",str];
     [_db executeUpdate:tempStr,[dic objectForKey:str],[dic objectForKey:@"Id"]];
     }
     }else {
     [_db executeUpdate:@"INSERT INTO LoginUser (Id,Name,PasswordHash,PasswordSalt,FirstLastName,Qq,WeiXing,Email,Tel,DepartmentId,DepartmentName) VALUES (?,?,?,?,?,?,?,?,?,?,?)", [dic objectForKey:@"Id"],[dic objectForKey:@"Name"],[dic objectForKey:@"PasswordHash"],[dic objectForKey:@"PasswordSalt"],[dic objectForKey:@"FirstLastName"],[dic objectForKey:@"Qq"],[dic objectForKey:@"WeiXing"],[dic objectForKey:@"Email"],[dic objectForKey:@"Tel"],[dic objectForKey:@"DepartmentId"],[dic objectForKey:@"DepartmentName"]];
     }
     [rs close];
     
     FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM LoginUser"];
     
     while ([rs2 next]) {
     NSLog(@"DepartmentId is %@",[rs2 stringForColumn:@"DepartmentId"]);
     }
     [rs2 close];
     [self closeDB];

     */
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"LoginUser"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from LoginUser"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    if ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in LoginUserKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readMaterialCatalogs
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"MaterialCatalogs"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from MaterialCatalogs"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in MaterialCatalogsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readMaterials
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"Materials"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from Materials"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in MaterialsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readMaterialPictures
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"MaterialPictures"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from MaterialPictures"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in PicturesKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readPlanCatalogs
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"PlanCatalogs"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from PlanCatalogs"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in PlanCatalogsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readPlans
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"Plans"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from Plans"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in PlansKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readPlanPictures
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"PlanPictures"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from PlanPictures"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in PicturesKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readScrollPictures
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"ScrollPictures"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from ScrollPictures"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in PicturesKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readParties
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"Parties"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from Parties"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in PartiesKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readIntroductionCatalogs
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"IntroductionCatalogs"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from IntroductionCatalogs"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in CatalogsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readIntroductions
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"Introductions"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from Introductions"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in IntroductionsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readWritingCatalogs
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"WritingCatalogs"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from WritingCatalogs"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in CatalogsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readWritings
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"Writings"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from Writings"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in WritingsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readWritingPictures
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"WritingPictures"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from WritingPictures"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in PicturesKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readAnnouncements
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"Announcements"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from Announcements"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in AnnouncementsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readProjectCatalogs
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"ProjectCatalogs"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from ProjectCatalogs"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in CatalogsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (NSMutableArray *)readProjects
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"Projects"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from Projects"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in ProjectsKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}

- (NSMutableArray *)readProjectPictures
{
    if (![self openDB]) {
        return nil;
    }
    if (![_db tableExists:@"ProjProjectPicturesectCatalogs"]) {
        return nil;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from ProjectPictures"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in PicturesKeyArray) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return mutableArray;
}
- (int)readDataVersionFromBaseData
{
    if (![self openDB]) {
        return 0;
    }
    if (![_db tableExists:@"BaseDataVersion"]) {
        return 0;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from BaseDataVersion"];
    if ([rs next]) {
        int DV = [[rs objectForColumnName:@"DataVersion"] intValue];
        [rs close];
        [self closeDB];
        return DV;
    }
    return 0;
}
@end

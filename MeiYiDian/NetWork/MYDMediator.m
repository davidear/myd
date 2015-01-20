//
//  MYDMediator.m
//  MeiYiDian
//
//  Created by dfy on 15/1/6.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDMediator.h"
#import "ASIHTTPRequest.h"
#import "MYDConfig.h"

@implementation MYDMediator
#pragma mark - 单例
static MYDMediator *instant = nil;
+(MYDMediator*)getInstant
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instant=[[[self class] alloc] init];
    });
    return instant;
}

- (id)init
{
    self = [super init];
    if (self) {
        network = [MYDNetwork getInstant];
        packageManager = [MYDPackageManager getInstant];
//        [DFYAMPackageManager getInstant];
//
//        
//        //         四川移动的环境
//        self.ver = [NSString stringWithFormat:@"1.0"];
//        self.DFYapp_key = [NSString stringWithFormat:@"8M7HHCGec1FbwhGY_alAdxmpfjka"];
//        //         self.username = [NSString stringWithFormat:@"%%2B8613808691368"];//注意，此处是%%2B
//        self.username = [NSString stringWithFormat:@"13808691368"];
//        self.password = [NSString stringWithFormat:@"Confdemo789"];
//        //         self.app_secert = [NSString stringWithFormat:@"5052c9af-4363-4650-abe7-b78edb746b82"];
//        
//        /**
//         华为的测试后台
//         
//         self.ver = [NSString stringWithFormat:@"1.0"];
//         self.DFYapp_key = [NSString stringWithFormat:@"861b79ab-a8f7-4489-ac07-03e6d842a3a3"];
//         self.username = [NSString stringWithFormat:@"%%2B8615084958900"];//注意，此处是%%2B
//         self.password = [NSString stringWithFormat:@"MediaX3600"];
//         //        self.app_secert = [NSString stringWithFormat:@"5052c9af-4363-4650-abe7-b78edb746b82"];
//         */
//        self.format = [NSString stringWithFormat:@"json"];
        
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

#pragma mark - 方法
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    /*
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<Login xmlns=\"http://tempuri.org/\">\n"
                             "<userName>%@</userName>\n"
                             "<pwd>%@</pwd>\n"
                             "</Login>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",userName,password
                             ];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:kMYDServerId]];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    //    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/Login"];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetBaseData"];
    
    [request addRequestHeader:@"Content-Length" value:msgLength];
    
    [request setRequestMethod:@"Post"];
    
    [request setPostBody:[NSMutableData dataWithData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]]];
*/
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<Login xmlns=\"http://tempuri.org/\">\n"
                             "<userName>%@</userName>\n"
                             "<pwd>%@</pwd>\n"
                             "</Login>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",userName,password
                             ];
    NSString *soapAction = kMYDLoginSoapActionId;
    [network PostRequestWithSoapMessage:soapMessage soapAction:soapAction success:^(NSString *responseString, id responseData) {
//处理返回的数据
        [packageManager unpackLoginBag:responseString];
        
        
        
        
        
        successBlock(responseString);
        
    } failure:^(NSError *error) {
        failureBlock(error);
    } task:NetworkLogin];
}

/*
 POST /services/webservice.asmx HTTP/1.1
 Host: pad.zmmyd.com
 Content-Type: text/xml; charset=utf-8
 Content-Length: length
 SOAPAction: "http://tempuri.org/DataVersion"
 
 <?xml version="1.0" encoding="utf-8"?>
 <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
 <soap:Body>
 <DataVersion xmlns="http://tempuri.org/">
 <depId>guid</depId>
 </DataVersion>
 </soap:Body>
 </soap:Envelope>
 */
- (void)getDataVersionWithDepartmentId:(NSString *)departmentId success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<DataVersion xmlns=\"http://tempuri.org/\">\n"
                             "<depId>%@</depId>\n"
                             "</DataVersion>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",departmentId];
    NSString *soapAction = kMYDGetDataVersionSoapActionId;
    [network PostRequestWithSoapMessage:soapMessage soapAction:soapAction success:^(NSString *responseString, id responseData) {
        //处理返回的数据
        [packageManager unpackDataVersionBag:responseString];
        
        
        
        
        
        successBlock(responseString);
        
    } failure:^(NSError *error) {
        failureBlock(error);
    } task:NetworkGetDataVersion];
}
/*
 POST /services/webservice.asmx HTTP/1.1
 Host: pad.zmmyd.com
 Content-Type: text/xml; charset=utf-8
 Content-Length: length
 SOAPAction: "http://tempuri.org/GetBaseData"
 
 <?xml version="1.0" encoding="utf-8"?>
 <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
 <soap:Body>
 <GetBaseData xmlns="http://tempuri.org/">
 <depId>guid</depId>
 </GetBaseData>
 </soap:Body>
 </soap:Envelope>
 */
- (void)getBaseDataWithDepartmentId:(NSString *)departmentId success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetBaseData xmlns=\"http://tempuri.org/\">\n"
                             "<depId>%@</depId>\n"
                             "</GetBaseData>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",departmentId];
    NSString *soapAction = kMYDGetBaseDataSoapActionId;
    [network PostRequestWithSoapMessage:soapMessage soapAction:soapAction success:^(NSString *responseString, id responseData) {
        //处理返回的数据
        [packageManager unpackBaseDataBag:responseString];
        
        
        
        
        
        successBlock(responseString);
        
    } failure:^(NSError *error) {
        failureBlock(error);
    } task:NetworkGetBaseData];
}
/*
 POST /services/webservice.asmx HTTP/1.1
 Host: pad.zmmyd.com
 Content-Type: text/xml; charset=utf-8
 Content-Length: length
 SOAPAction: "http://tempuri.org/GetPicture"
 
 <?xml version="1.0" encoding="utf-8"?>
 <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
 <soap:Body>
 <GetPicture xmlns="http://tempuri.org/">
 <depId>guid</depId>
 <typeCode>string</typeCode>
 <fileName>string</fileName>
 </GetPicture>
 </soap:Body>
 </soap:Envelope>
 */
- (void)getPictureWithDepartmentId:(NSString *)departmentId typeCode:(NSString *)typeCode fileName:(NSString *)fileName success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetPicture xmlns=\"http://tempuri.org/\">\n"
                             "<depId>%@</depId>\n"
                             "<typeCode>%@</typeCode>\n"
                             "<fileName>%@</fileName>\n"
                             "</GetPicture>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",departmentId,typeCode,fileName];
    NSString *soapAction = kMYDGetPictureSoapActionId;
    [network PostRequestWithSoapMessage:soapMessage soapAction:soapAction success:^(NSString *responseString, id responseData) {
        //处理返回的数据
        [packageManager unpackPictureBag:responseString fileName:fileName];
        
        successBlock(responseString);
        
    } failure:^(NSError *error) {
        failureBlock(error);
    } task:NetworkGetPictures];
}
@end


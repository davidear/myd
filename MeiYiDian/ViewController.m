//
//  ViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/6.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "DDXML.h"
#import "MYDMediator.h"
#import "FMDB.h"
#import "MYDDBManager.h"

@interface ViewController ()<NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self buttonAction:nil];
//    [self login];
//    [self getBaseData];
//    [[MYDDBManager getInstant] readLoginUser];
//    [self getPicture];
}
- (void)getEnterpriseInfo
{
    
}
- (void)getPicture
{
    [[MYDMediator getInstant] getPictureWithDepartmentId:@"6c758ef2-a041-4a52-bef5-857fcef5b5b9" typeCode:@"03" fileName:@"5fe831e9-e61b-4632-b03e-1c85a7d951d5.png" success:^(NSString *responseString) {
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)getBaseData
{
    [[MYDMediator getInstant] getBaseDataWithDepartmentId:@"6c758ef2-a041-4a52-bef5-857fcef5b5b9" success:^(NSString *responseString) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getDataVersion
{
    
//    [MYDMediator getInstant] getDataVersionWithDepartmentId:<#(NSString *)#> success:<#^(NSString *responseString)successBlock#> failure:<#^(NSError *error)failureBlock#>
}

- (void)login
{
    [[MYDMediator getInstant] loginWithUserName:@"myd001" password:@"myd001" success:^(NSString *responseString) {
        
    } failure:^(NSError *error) {
        
    }];
    
//    [[MYDMediator getInstant] getBaseDataWithDepartmentId:@"6c758ef2-a041-4a52-bef5-857fcef5b5b9" success:^(NSString *responseString) {
//        NSLog(@"%@",responseString);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
}



- (void)buttonAction:(id)sender {
    NSString *username = @"myd001";
    NSString *password = @"myd001";
    
    
//    POST /services/webservice.asmx HTTP/1.1
//Host: pad.zmmyd.com
//    Content-Type: text/xml; charset=utf-8
//    Content-Length: length
//SOAPAction: "http://tempuri.org/GetBaseData"
//    
//    <?xml version="1.0" encoding="utf-8"?>
//    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//    <soap:Body>
//    <GetBaseData xmlns="http://tempuri.org/">
//    <depId>guid</depId>
//    </GetBaseData>
//    </soap:Body>
//    </soap:Envelope>
    
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetBaseData xmlns=\"http://tempuri.org/\">\n"
                             "<depId>6c758ef2-a041-4a52-bef5-857fcef5b5b9</depId>\n"
                             "</GetBaseData>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ];
//    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//                             "<soap:Body>\n"
//                             "<Login xmlns=\"http://tempuri.org/\">\n"
//                             "<userName>%@</userName>\n"
//                             "<pwd>%@</pwd>\n"
//                             "</Login>\n"
//                             "</soap:Body>\n"
//                             "</soap:Envelope>\n",username,password
//];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
                             
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://pad.zmmyd.com/services/webservice.asmx"]];
//    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    [theRequest addValue: @"http://www.Nanonull.com/TimeService/getOffesetUTCTime" forHTTPHeaderField:@"SOAPAction"];
//    
//    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//    
//    [theRequest setHTTPMethod:@"POST"];
//    
//    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

    
    
//    POST /services/webservice.asmx HTTP/1.1
//Host: pad.zmmyd.com
//    Content-Type: text/xml; charset=utf-8
//    Content-Length: length
//SOAPAction: "http://tempuri.org/Login"
//    
//    <?xml version="1.0" encoding="utf-8"?>
//    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//    <soap:Body>
//    <Login xmlns="http://tempuri.org/">
//    <userName>string</userName>
//    <pwd>string</pwd>
//    </Login>
//    </soap:Body>
//    </soap:Envelope>
    
//response
    /*
    <?xml version="1.0" encoding="utf-8"?>
     <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
     <soap:Body>
     <LoginResponse xmlns="http://tempuri.org/">
     <LoginResult><Succeed>true</Succeed><DataVersion>118</DataVersion><DepartmentId>6c758ef2-a041-4a52-bef5-857fcef5b5b9</DepartmentId></LoginResult>
     </LoginResponse>
     </soap:Body>
     </soap:Envelope>
     */
    
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
//    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/Login"];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/GetBaseData"];
    
    [request addRequestHeader:@"Content-Length" value:msgLength];
    
    [request setRequestMethod:@"Post"];
    
    [request setPostBody:[NSMutableData dataWithData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setCompletionBlock:^{
        NSLog(@"taken request complete\n");
        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        NSMutableString *mutableString = [NSMutableString stringWithString:responseString];
        [mutableString deleteCharactersInRange:[mutableString rangeOfString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"]];
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<soap:Body>"]];
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"<GetBaseDataResponse xmlns=\"http://tempuri.org/\">"]];

        
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"</GetBaseDataResponse></soap:Body></soap:Envelope>"]];
        /*
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:YES];
        [parser parse];
        */
        NSError *error = nil;
        DDXMLDocument *XMLDocument = [[DDXMLDocument alloc] initWithXMLString:mutableString options:0 error:&error];
        
        NSArray *children = [XMLDocument nodesForXPath:@"//GetBaseDataResult/Succeed" error:nil];
        for (int i =0; i < children.count; i++) {
            DDXMLNode *child = [children objectAtIndex:i];
            NSLog(@"succeed is %@",child);
        }
        
        
    }];
    
    [request setFailedBlock:^{
        NSLog(@"taken request failed\n");
        NSError *error = [request error];
    }];
    
    [request startAsynchronous];
}
/*
#pragma mark - NSXMLParserDelegate
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict

{
    
    NSLog(@"4 parser didStarElemen: namespaceURI: attributes:");
    
    if( [elementName isEqualToString:@"Succeed"])
        
    {
        
        NSLog(@"");
        
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string

{
    NSLog(@"%@",string);
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName

{
    NSLog(@"");

    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
    NSLog(@"-------------------start--------------");
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    NSLog(@"-------------------end--------------");
    
}
 */
@end

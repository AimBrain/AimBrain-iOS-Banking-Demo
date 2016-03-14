#import "AMBNDemoServer.h"
#import "AMBNInterfaceUUIDGenerator.h"
#import <sys/utsname.h>

@implementation AMBNDemoServer
{
    NSOperationQueue *queue;
    NSURL * registrationURL;
}

+ (instancetype) sharedInstance{
    static AMBNDemoServer *sharedServer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServer = [[self alloc] init];
    });
    return sharedServer;
}

- (instancetype) init{
    self = [super init];
    queue = [[NSOperationQueue alloc] init];
    
    NSURL * baseURL = [NSURL URLWithString:@"https://demo.aimbrain.com:443/api/v2/"];
    NSString * registerPath = @"register";
    registrationURL = [NSURL URLWithString:registerPath relativeToURL:baseURL];
    
    return self;
}

- (void) registerEmail: (NSString *) email completion: (void (^)(NSURL * loginURL, NSError * error))completion {
    UIDevice *currentDevice = [UIDevice currentDevice];
    [queue addOperationWithBlock:^{
        NSDictionary *json = @{
                               @"email" : email,
                               @"deviceName": currentDevice.name,
                               @"system": currentDevice.systemVersion,
                               @"device": [self machineName],
                               @"deviceIdentifier": [currentDevice.identifierForVendor UUIDString],
                               @"installuuid": [AMBNInterfaceUUIDGenerator getInterfaceUUID],
                               @"phoneAccounts": @[email]
                               };
        NSURLRequest * req = [self createJSONPostRequestWithJSON:json url:registrationURL];
        
        NSLog(@"Sending register request with body: \n %@",[[NSString alloc] initWithData:[req HTTPBody]  encoding:NSUTF8StringEncoding]);
        
        [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(connectionError){
                    completion( nil, connectionError);
                    return;
                }else{
                    
                    
                    NSError * jsonParseError;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];
                    if(jsonParseError || ![jsonObject isKindOfClass:[NSDictionary class]]){
                        completion( nil, [NSError errorWithDomain:AMBNExampleAppErrorDomain code:AMBNErrorUnprocessableResponse userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"ErrorUnprocessableResponse", "")}]);
                        return;
                    }
                    
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if(httpResponse.statusCode == 200){
                        NSString * loginURLString = [(NSDictionary *)jsonObject objectForKey:@"loginurl"];
                        NSURL * loginURL = nil;
                        if(loginURLString){
                            loginURL = [NSURL URLWithString:loginURLString];
                        }
                        
                        if(loginURL){
                            completion(loginURL, nil);
                            return;
                        }else{
                            completion(nil, [NSError errorWithDomain:AMBNExampleAppErrorDomain code:AMBNErrorIncompleteResponse userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"ErrorIncompleteResponse", "")}]);
                            return;
                        }
                    }else{
                        NSString * error = [(NSDictionary *)jsonObject objectForKey:@"error"];
                        NSDictionary * userInfo = nil;
                        if (error) {
                            userInfo = @{NSLocalizedDescriptionKey:error};
                        }else{
                            userInfo = @{NSLocalizedDescriptionKey:[NSString  stringWithFormat:@"Unknown server error (%li)", (long)httpResponse.statusCode]};
                        }
                        
                        completion(nil, [NSError errorWithDomain:AMBNExampleAppErrorDomain code:AMBNErrorIncompleteResponse userInfo:userInfo]);
                        
                        return;
                    }
                }
            });
        }];
    }];
}



- (void) login: (NSURL *) loginURL completion: (void (^)(NSString * userId, NSString * pin, NSError * error))completion {
    //    UIDevice *currentDevice = [UIDevice currentDevice];
    [queue addOperationWithBlock:^{
        NSURLRequest * req = [self createEmptyPOSTRequestWithUrl:loginURL];
        
        [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(connectionError){
                    completion(nil, nil, connectionError);
                    return;
                }else{
                    
                    
                    NSError * jsonParseError;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];
                    if(jsonParseError || ![jsonObject isKindOfClass:[NSDictionary class]]){
                        completion(nil, nil, [NSError errorWithDomain:AMBNExampleAppErrorDomain code:AMBNErrorUnprocessableResponse userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"ErrorUnprocessableResponse", "")}]);
                        return;
                    }
                    
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if(httpResponse.statusCode == 200){
                        NSString * userId = [(NSDictionary *)jsonObject objectForKey:@"userId"];
                        NSString * pin = [(NSDictionary *)jsonObject objectForKey:@"pin"];
                        
                        if(userId && pin){
                            completion(userId, pin, nil);
                            return;
                        }else{
                            completion(nil, nil, [NSError errorWithDomain:AMBNExampleAppErrorDomain code:AMBNErrorIncompleteResponse userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"ErrorIncompleteResponse", "")}]);
                            return;
                        }
                    }else{
                        NSString * error = [(NSDictionary *)jsonObject objectForKey:@"error"];
                        NSDictionary * userInfo = nil;
                        if (error) {
                            userInfo = @{NSLocalizedDescriptionKey:error};
                        }else{
                            userInfo = @{NSLocalizedDescriptionKey:[NSString  stringWithFormat:@"Unknown server error (%li)", (long)httpResponse.statusCode]};
                        }
                        
                        completion(nil, nil, [NSError errorWithDomain:AMBNExampleAppErrorDomain code:AMBNErrorIncompleteResponse userInfo:userInfo]);
                        
                        return;
                    }
                }
            });
        }];
    }];
}
- (NSMutableURLRequest *) createEmptyPOSTRequestWithUrl: (NSURL *) url{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10;
    request.HTTPMethod = @"POST";
    return request;
    
    
    return nil;
}

- (NSMutableURLRequest *) createJSONPostRequestWithJSON: (nonnull id) data url: (NSURL *) url{
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    if(error == nil){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 10;
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request.HTTPBody = jsonData;
        return request;
        
    }
    return nil;
}

- (NSString *) machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
@end

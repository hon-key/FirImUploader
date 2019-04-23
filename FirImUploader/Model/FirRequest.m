//  Copyright (c) 2019 HJ-Cai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "FirRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation FirRequest

+ (instancetype)standardRequest {
    static FirRequest *request;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[FirRequest alloc] init];
    });
    return request;
}


- (void)fetchAppsWithComplete:(void (^)(FirApps * _Nullable))complete {
    NSString *url = [NSString stringWithFormat:@"http://api.fir.im/apps?api_token=%@",self.api_token];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        FirApps *apps = [FirApps yy_modelWithDictionary:responseObject];
        complete(apps);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"%@",error);
        complete(nil);

    }];
}

- (void)fetchUploadInfoWithApp:(FirApp *)app complete:(void (^)(void))complete {
    NSString *url = @"http://api.fir.im/apps";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *dict = @{@"type":@"ios",
                           @"bundle_id":app.bundle_id ?:@"",
                           @"api_token":self.api_token};
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        app.uploadInfo = [FirUploadInfo yy_modelWithDictionary:responseObject];
        complete();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        complete();
        
    }];
}

- (void)uploadIpa:(NSString *)path forApp:(FirApp *)app progress:(void (^)(CGFloat))progress complete:(void (^)(FirUploadResult * _Nonnull))complete {
    if (!app.uploadInfo) {
        complete([FirUploadResult new]);
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"key"] = app.uploadInfo.binary.key;
    param[@"token"] = app.uploadInfo.binary.token;
    param[@"x:name"] = app.name ?: @"app";
    param[@"x:version"] = @"1.0.0";
    param[@"x:build"] = @"1";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:app.uploadInfo.binary.upload_url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" error:&error];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%.2lf",(double)uploadProgress.completedUnitCount / (double)uploadProgress.totalUnitCount);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) progress((double)uploadProgress.completedUnitCount / (double)uploadProgress.totalUnitCount);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        FirUploadResult *result = [FirUploadResult yy_modelWithDictionary:responseObject];
        complete(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        complete([FirUploadResult new]);
        
    }];
    
    
}

@end

@implementation FirApps
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"items":FirApp.class};
}
@end

@implementation FirApp
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"p_id":@"id",
             @"p_short":@"short"
             };
}

@end

@implementation FirUploadInfo
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"icon":FirCert.class,@"binary":FirCert.class};
}
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"p_id":@"id",
             @"p_short":@"short",
             @"icon":@"cert.icon",
             @"binary":@"cert.binary"
             };
}
@end

@implementation FirCert

@end

@implementation FirUploadResult

@end

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
#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@class FirApp,FirApps,MasterRelease,FirCert,FirUploadInfo,FirUploadResult;

@interface FirRequest : NSObject

@property (nonatomic,copy) NSString *api_token; // 长度为 32, 用户在 fir 的 api_token

+ (instancetype)standardRequest;

- (void)fetchAppsWithComplete:(void(^)(FirApps * __nullable apps))complete;
- (void)fetchUploadInfoWithApp:(FirApp *)app complete:(void(^)(void))complete;
- (void)uploadIpa:(NSString *)path forApp:(FirApp *)app progress:(void(^)(CGFloat progress))progress complete:(void(^)(FirUploadResult *result))complete;
@end

@interface FirApps : NSObject <YYModel>
@property (nonatomic,strong) NSArray<FirApp *> *items;
@property (nonatomic,assign) long apps_count;
@property (nonatomic,assign) long page_size;
@end

@interface FirApp : NSObject <YYModel>
@property (nonatomic,copy) NSString *bundle_id;
@property (nonatomic,assign) NSInteger created_at;
@property (nonatomic,copy) NSString *custom_market_url;
@property (nonatomic,assign) NSInteger expired_at;
@property (nonatomic,assign) NSInteger genre_id;
@property (nonatomic,assign) BOOL has_combo;
@property (nonatomic,copy) NSString *icon_url;
@property (nonatomic,copy) NSString *p_id;
@property (nonatomic,assign) BOOL is_opened;
@property (nonatomic,strong) MasterRelease *master_release;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *org_id;
@property (nonatomic,copy) NSString *p_short;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) NSInteger updated_at;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *web_template;

@property (nonatomic,strong,nullable) FirUploadInfo *uploadInfo;
@end

@interface MasterRelease : NSObject
@property (nonatomic,assign) BOOL build;
@property (nonatomic,assign) NSInteger created_at;
@property (nonatomic,copy) NSString *distribution_name;
@property (nonatomic,copy) NSString *minimum_os_version;
@property (nonatomic,copy) NSString *release_type;
@property (nonatomic,copy) NSString *supported_platform;
@property (nonatomic,copy) NSString *ui_device_family;
@property (nonatomic,copy) NSString *ui_required_device_capabilities;
@property (nonatomic,copy) NSString *version;
@end

@interface FirUploadInfo : NSObject <YYModel>
@property (nonatomic,copy) NSString *app_user_id;
@property (nonatomic,copy) NSString *form_method;
@property (nonatomic,copy) NSString *p_id;
@property (nonatomic,copy) NSString *p_short;
@property (nonatomic,copy) NSString *storage;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,strong) FirCert *icon;
@property (nonatomic,strong) FirCert *binary;
@end

@interface FirCert : NSObject
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *upload_url;
@end

@interface FirUploadResult : NSObject
@property (nonatomic,assign) BOOL is_completed;
@property (nonatomic,copy) NSString *download_url;
@property (nonatomic,copy) NSString *release_id;
@end

NS_ASSUME_NONNULL_END

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

#import "InfoStorage.h"
#import <YYModel/YYModel.h>

static NSString * const InfoStorageKey = @"com.InfoStorage.key";

@implementation InfoStorage
+ (void)store:(Info *)info forBundleId:(nonnull NSString *)bundleId{
    if (info && bundleId) {
        NSMutableDictionary *dictM = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:InfoStorageKey] mutableCopy];
        if (!dictM) {
            dictM = [NSMutableDictionary new];
        }
        NSDictionary *data = [info yy_modelToJSONObject];
        dictM[bundleId] = data;
        [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:InfoStorageKey];
    }
    
}

+ (Info *)infoWithBundleId:(NSString *)bundleId {
    if (bundleId) {
        NSDictionary *infos = [[NSUserDefaults standardUserDefaults] dictionaryForKey:InfoStorageKey];
        NSDictionary *data = infos[bundleId];
        return [Info yy_modelWithDictionary:data];
    }
    return nil;
}

@end


@implementation Info

@end

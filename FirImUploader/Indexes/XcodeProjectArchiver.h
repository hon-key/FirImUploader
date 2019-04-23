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

NS_ASSUME_NONNULL_BEGIN

@protocol XcodeProjectArchiverDelegate;

@interface XcodeProjectArchiver : NSObject

@property (nonatomic,weak) id<XcodeProjectArchiverDelegate> delegate;

@property (nonatomic,copy) NSString *name; // 工程名
@property (nonatomic,copy) NSString *scheme; // 工程 scheme 名
@property (nonatomic,copy) NSString *path; // 工程根路径
@property (nonatomic,copy) NSString *plistName; // 生产 ipa 所需要的 plist，可以事先手动打一次包，然后取出相应 plist 用于此
@property (nonatomic,copy) NSString *ipaExportPath; // 生成的 ipa 的存放目录
- (void)generateIpa;

@end

@protocol XcodeProjectArchiverDelegate <NSObject>
- (void)xcodeArchiver:(XcodeProjectArchiver *)archiver didOutputLog:(NSString *)log;
- (void)xcodeArchiver:(XcodeProjectArchiver *)archiver didOutputError:(NSString *)error;
- (void)xcodeArchiver:(XcodeProjectArchiver *)archiver didGenerateIpa:(NSString *)path;
@end

NS_ASSUME_NONNULL_END

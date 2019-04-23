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

#import "XcodeProjectArchiver.h"

dispatch_queue_t get_archiver_log_queue () {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.archiver.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

@interface XcodeProjectArchiver ()
@property (nonatomic,strong) NSTask *archiveTask;
@end

@implementation XcodeProjectArchiver

- (void)generateIpa {
    NSString *pathForIpaSh = [[NSBundle mainBundle] pathForResource:@"ipa" ofType:@".sh"];
    NSAssert(pathForIpaSh != nil, @"脚本不能没有！");
    
    NSString *paramError = nil;
    if (self.archiveTask.isRunning) {
        paramError = @"正在生产脚本,请结束后在重新生产";
    }
    if (!self.name || [self.name isEqualToString:@""]) {
        paramError = @"工程名有问题！";
    }
    if (!self.scheme || [self.scheme isEqualToString:@""]) {
        paramError = @"scheme 有问题！";
    }
    if (!self.path || [self.path isEqualToString:@""]) {
        paramError = @"工程根目录有问题！";
    }
    if (!self.plistName || [self.plistName isEqualToString:@""]) {
        paramError = @"plist 文件名有问题！";
    }
    if (paramError) {
        [self.delegate xcodeArchiver:self didOutputError:paramError];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    if (!self.ipaExportPath) {
        self.ipaExportPath = [self.path stringByAppendingPathComponent:[NSString stringWithFormat:@"ipa/%@/%@",self.name,self.scheme]];
    }
    
    NSArray *args = @[pathForIpaSh,
                      self.name,
                      self.scheme,
                      @"release",
                      self.path,
                      self.ipaExportPath,
                      self.plistName,
                      dateString];
    
    self.archiveTask = [[NSTask alloc] init];
    self.archiveTask.launchPath = @"/bin/sh";
    self.archiveTask.arguments = args;
    
    self.archiveTask.standardInput = [NSPipe pipe];
    self.archiveTask.standardOutput = [NSPipe pipe];
    self.archiveTask.standardError = [NSPipe pipe];
    __weak typeof (self) weakSelf = self;
    if ([self.delegate respondsToSelector:@selector(xcodeArchiver:didOutputLog:)]) {
        [self.archiveTask.standardOutput fileHandleForReading].readabilityHandler = ^(NSFileHandle * _Nonnull fileHandle) {
            __strong typeof(self) strongSelf = weakSelf;
            NSData *data = [fileHandle availableData];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(get_archiver_log_queue(), ^{
                [strongSelf.delegate xcodeArchiver:strongSelf didOutputLog:string];
            });
        };
    }
    if ([self.delegate respondsToSelector:@selector(xcodeArchiver:didOutputError:)]) {
        [self.archiveTask.standardError fileHandleForReading].readabilityHandler = ^(NSFileHandle * _Nonnull fileHandle) {
            __strong typeof(self) strongSelf = weakSelf;
            NSData *data = [fileHandle availableData];
            NSString *error = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.delegate xcodeArchiver:strongSelf didOutputError:error];
            });
        };
    }
    if ([self.delegate respondsToSelector:@selector(xcodeArchiver:didGenerateIpa:)]) {
        self.archiveTask.terminationHandler = ^(NSTask * _Nonnull archiveTask) {
            __strong typeof(self) strongSelf = weakSelf;
            NSLog(@"archive complete");
            [archiveTask.standardOutput fileHandleForReading].readabilityHandler = nil;
            [archiveTask.standardError fileHandleForReading].readabilityHandler = nil;
            NSString *ipaPath = [strongSelf.ipaExportPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ %@",strongSelf.name,dateString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.delegate xcodeArchiver:strongSelf didGenerateIpa:ipaPath];
            });
        };
    }
    [self.archiveTask launch];
}

@end

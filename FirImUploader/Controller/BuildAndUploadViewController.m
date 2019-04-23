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

#import "BuildAndUploadViewController.h"
#import "XcodeProjectArchiver.h"
#import "LabelAndTextFieldView.h"
#import <Masonry/Masonry.h>
#import "Masonry+Extentions.h"
#import "ScrollTextView.h"
#import "FirRequest.h"
#import <CoreImage/CoreImage.h>
#import "InfoStorage.h"

@interface BuildAndUploadViewController () <XcodeProjectArchiverDelegate>
@property (nonatomic,strong) LabelAndTextFieldView *projectName;
@property (nonatomic,strong) LabelAndTextFieldView *projectScheme;
@property (nonatomic,strong) LabelAndTextFieldView *projectPath;
@property (nonatomic,strong) LabelAndTextFieldView *projectPlistName;
@property (nonatomic,strong) LabelAndTextFieldView *ipaExportPath;
@property (nonatomic,strong) NSButton *generateButton,*saveButton;
@property (nonatomic,strong) ScrollTextView *logsView;
@property (nonatomic,strong) NSImageView *qrCodeImageView;

@property (nonatomic,strong) XcodeProjectArchiver *archiver;
@end

@implementation BuildAndUploadViewController
- (void)resize {
    self.view.window.contentMaxSize = self.view.window.contentMinSize = CGSizeMake(500, 500);
    [self.view.window setFrame:CGRectMake([NSScreen mainScreen].frame.size.width / 2 - 250, [NSScreen mainScreen].frame.size.height / 2 - 250, 500, 500) display:YES];
    self.view.frame = self.view.window.contentView.bounds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectName = [self labelAndTextFieldViewWithTitle:@"工程名" width:100];
    self.projectScheme = [self labelAndTextFieldViewWithTitle:@"Scheme" width:100];
    self.projectPath = [self labelAndTextFieldViewWithTitle:@"工程目录" width:300];
    self.projectPlistName = [self labelAndTextFieldViewWithTitle:@"Plist名" width:100];
    self.ipaExportPath = [self labelAndTextFieldViewWithTitle:@"输出目录" width:300];
    
    [self.projectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.view).left(15).top(15);
    }];
    [self.projectScheme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.projectName).leftToRight(10).centerY(0);
    }];
    [self.projectPlistName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.projectScheme).leftToRight(10).centerY(0);
    }];
    [self.projectPath mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.projectName).left(0).topToBottom(20);
    }];
    [self.ipaExportPath mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.projectPath).left(0).topToBottom(20);
    }];
    [self.generateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.ipaExportPath).topToBottom(20).left(0);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.generateButton).centerY(0);
        make.to(self.view).right(15);
    }];
    [self.logsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.view).left(15).right(15);
        make.height.mas_equalTo(150);
        make.to(self.generateButton).topToBottom(20);
    }];
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.logsView).topToBottom(10);
        make.to(self.view).centerX(0).bottom(10);
        make.width.equalTo(self.qrCodeImageView.mas_height);
    }];
    
    Info *info = [InfoStorage infoWithBundleId:self.app.bundle_id];
    if (info) {
        self.projectName.inputTextField.stringValue = info.name;
        self.projectScheme.inputTextField.stringValue = info.scheme;
        self.projectPath.inputTextField.stringValue = info.path;
        self.projectPlistName.inputTextField.stringValue = info.plistName;
        self.ipaExportPath.inputTextField.stringValue = info.ipaExportPath;
    }
    
}
- (void)viewWillAppear {
    [super viewWillAppear];
    self.view.window.title = self.app.name ?: @"未知";
}

- (void)create {
    self.qrCodeImageView.image = nil;
    [self.logsView.textView.textStorage replaceCharactersInRange:NSMakeRange(0, self.logsView.textView.textStorage.length) withString:@""];
    self.archiver.name = self.projectName.inputTextField.stringValue;
    self.archiver.scheme = self.projectScheme.inputTextField.stringValue;
    self.archiver.path = self.projectPath.inputTextField.stringValue;
    self.archiver.ipaExportPath = self.ipaExportPath.inputTextField.stringValue;
    self.archiver.plistName = self.projectPlistName.inputTextField.stringValue;
    [self.archiver generateIpa];
}

- (void)saveInfo {
    Info *info = [InfoStorage infoWithBundleId:self.app.bundle_id];
    if (!info) {
        info = [Info new];
    }
    info.name = self.projectName.inputTextField.stringValue;
    info.scheme = self.projectScheme.inputTextField.stringValue;
    info.path = self.projectPath.inputTextField.stringValue;
    info.plistName = self.projectPlistName.inputTextField.stringValue;
    info.ipaExportPath = self.ipaExportPath.inputTextField.stringValue;
    [InfoStorage store:info forBundleId:self.app.bundle_id];
}

#pragma mark - Archiver delegate
- (void)xcodeArchiver:(XcodeProjectArchiver *)archiver didOutputLog:(NSString *)log {
    if (log) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:log attributes:@{NSForegroundColorAttributeName:[NSColor whiteColor]}];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.logsView.textView.textStorage appendAttributedString:string];
            [self.logsView.contentView scrollToPoint:CGPointMake(0, self.logsView.documentView.frame.size.height - 150)];
        });
    }
}

- (void)xcodeArchiver:(XcodeProjectArchiver *)archiver didGenerateIpa:(NSString *)path {
    if (path) {
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ipa",self.projectScheme.inputTextField.stringValue]];
        [[FirRequest standardRequest] fetchUploadInfoWithApp:self.app complete:^{
            [[FirRequest standardRequest] uploadIpa:path forApp:self.app progress:^(CGFloat progress) {
                [self appendLog:[NSString stringWithFormat:@"\n正在上传ipa:%ld%%",(NSInteger)(progress * 100)]];
            } complete:^(FirUploadResult * _Nonnull result) {
                if (result.is_completed) {
                    NSString *url = [NSString stringWithFormat:@"https://fir.im/%@",self.app.p_short];
                    self.qrCodeImageView.image = [self transferToQRCodeImage:url];
                }
            }];
        }];
    }
    
}

- (void)xcodeArchiver:(XcodeProjectArchiver *)archiver didOutputError:(NSString *)error {
    if (error) {
        if (![self.logsView.textView.string isEqualToString:@""]) {
            error = [NSString stringWithFormat:@"\n%@",error];
        }
        [self appendLog:error];
    }
}

- (void)appendLog:(NSString *)log {
    [self.logsView.textView.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:log attributes:@{NSForegroundColorAttributeName:[NSColor whiteColor]}]];
    [self.logsView.contentView scrollToPoint:CGPointMake(0, self.logsView.documentView.frame.size.height - 150)];
}

- (NSImage *)transferToQRCodeImage:(NSString *)string {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    CIImage *image = [filter outputImage];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGSize size = CGSizeMake(300, 300);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent),size.height/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceCMYK();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [[NSImage alloc] initWithCGImage:scaledImage size:CGSizeMake(300, 300)];
}

#pragma mark -
- (LabelAndTextFieldView *)labelAndTextFieldViewWithTitle:(NSString *)title width:(NSInteger)width {
    LabelAndTextFieldView *comp = [[LabelAndTextFieldView alloc] initWithTextFieldWidth:width];
    comp.titleLabel.stringValue = title;
    [self.view addSubview:comp];
    return comp;
}

- (NSButton *)generateButton {
    if (!_generateButton) {
        _generateButton = [NSButton buttonWithTitle:@"生成" target:self action:@selector(create)];
        [self.view addSubview:_generateButton];
    }
    return _generateButton;
}

- (ScrollTextView *)logsView {
    if (!_logsView) {
        _logsView = [[ScrollTextView alloc] init];
        [self.view addSubview:_logsView];
    }
    return _logsView;
}

- (XcodeProjectArchiver *)archiver {
    if (!_archiver) {
        _archiver = [[XcodeProjectArchiver alloc] init];
        _archiver.delegate = self;
    }
    return _archiver;
}
- (NSImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[NSImageView alloc] init];
        [self.view addSubview:_qrCodeImageView];
    }
    return _qrCodeImageView;
}

- (NSButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [NSButton buttonWithTitle:@"保存以上信息" target:self action:@selector(saveInfo)];
        [self.view addSubview:_saveButton];
    }
    return _saveButton;
}

@end

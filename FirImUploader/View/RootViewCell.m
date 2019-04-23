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

#import "RootViewCell.h"

@implementation RootViewCell
- (instancetype)init {
    if (self = [super init]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.to(self).left(40).centerY(0);
        }];
        [self.bundleIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.to(self.titleLabel).leftToRight(20).centerY(0);
        }];
    }
    return self;
}

- (NSTextField *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[NSTextField alloc] init];
        _titleLabel.editable = NO;
        _titleLabel.bordered = NO;
        _titleLabel.font = [NSFont boldSystemFontOfSize:20];
        _titleLabel.backgroundColor = [NSColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (NSTextField *)bundleIdLabel {
    if (!_bundleIdLabel) {
        _bundleIdLabel = [[NSTextField alloc] init];
        _bundleIdLabel.editable = NO;
        _bundleIdLabel.bordered = NO;
        _bundleIdLabel.backgroundColor = [NSColor clearColor];
        [self addSubview:_bundleIdLabel];
    }
    return _bundleIdLabel;
}

@end


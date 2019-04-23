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

#import "LabelAndTextFieldView.h"
#import <Masonry/Masonry.h>
#import "Masonry+Extentions.h"

@implementation LabelAndTextFieldView

- (instancetype)init {
    if (self = [super init]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.to(self).left(0).top(0).bottom(0);
        }];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.to(self.titleLabel).leftToRight(5).centerY(0);
            make.to(self).right(0);
            make.width.mas_equalTo(100);
        }];
    }
    return self;
}

- (instancetype)initWithTextFieldWidth:(NSInteger)width {
    if (self = [super init]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.to(self).left(0).top(0).bottom(0);
        }];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.to(self.titleLabel).leftToRight(5).centerY(0);
            make.to(self).right(0);
            make.width.mas_equalTo(width);
        }];
    }
    return self;
}

- (NSTextField *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[NSTextField alloc] init];
        _titleLabel.editable = NO;
        _titleLabel.bordered = NO;
        _titleLabel.backgroundColor = [NSColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (NSTextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[NSTextField alloc] init];
        [self addSubview:_inputTextField];
    }
    return _inputTextField;
}

@end

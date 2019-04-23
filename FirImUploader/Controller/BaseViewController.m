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

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)loadView {
    self.view = [BaseView new];
}
- (BaseView *)baseView {
    return (BaseView *)self.view;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)presentViewControllerAsModalWindow:(NSViewController *)viewController {
    [super presentViewControllerAsModalWindow:viewController];
    if ([viewController isKindOfClass:[BaseViewController class]]) {
        [((BaseViewController *)viewController) resize];
    }
}

- (void)resize {
    self.view.window.contentMaxSize = self.view.window.contentMinSize = CGSizeMake(800, 800);
    [self.view.window setFrame:CGRectMake([NSScreen mainScreen].frame.size.width / 2 - 400, [NSScreen mainScreen].frame.size.height / 2 - 400, 800, 800) display:YES];
    self.view.frame = self.view.window.contentView.bounds;
}

@end

@implementation BaseView
- (instancetype)init {
    if (self = [super init]) {
        self.wantsLayer = YES;
    }
    return self;
}
@end

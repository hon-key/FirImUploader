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

#import "RootViewController.h"
#import "FirRequest.h"
#import "XcodeProjectArchiver.h"
#import "LabelAndTextFieldView.h"
#import "RootViewCell.h"
#import "ScrollTableView.h"
#import <AFNetworking/AFNetworking.h>
#import "BuildAndUploadViewController.h"



@interface RootViewController () <NSTableViewDelegate,NSTableViewDataSource>
@property (nonatomic,strong) NSButton *confirmButton,*createButton;
@property (nonatomic,strong) LabelAndTextFieldView *apiTokenField;

@property (nonatomic,strong) ScrollTableView *srollTableView;

@property (nonatomic,strong) FirApps *apps;
@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.apiTokenField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.view).left(40).top(40);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.apiTokenField).centerY(0).leftToRight(20);
    }];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.confirmButton).centerY(0);
        make.to(self.view).right(40);
    }];
    [self.srollTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.to(self.view).left(40).right(40).bottom(40);
        make.to(self.confirmButton).topToBottom(40);
    }];

}

- (void)create {
    BuildAndUploadViewController *con = [[BuildAndUploadViewController alloc] initWithNibName:nil bundle:nil];
    con.app = self.apps.items[self.srollTableView.tableView.selectedRow];
    [self presentViewControllerAsModalWindow:con];
}

- (void)searchAPPs {
    [FirRequest standardRequest].api_token = self.apiTokenField.inputTextField.stringValue;
    [[FirRequest standardRequest] fetchAppsWithComplete:^(FirApps * _Nullable apps) {
        self.apps = apps;
        [self.srollTableView.tableView reloadData];
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.apps.items.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 50;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    RootViewCell *cell = [RootViewCell new];
    cell.titleLabel.stringValue = self.apps.items[row].name;
    cell.bundleIdLabel.stringValue = self.apps.items[row].bundle_id;
    return cell;
}

- (LabelAndTextFieldView *)apiTokenField {
    if (!_apiTokenField) {
        _apiTokenField = [[LabelAndTextFieldView alloc] initWithTextFieldWidth:300];
        _apiTokenField.titleLabel.stringValue = @"Token";
        [self.view addSubview:_apiTokenField];
    }
    return _apiTokenField;
}
- (NSButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [NSButton buttonWithTitle:@"搜索APP" target:self action:@selector(searchAPPs)];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (NSButton *)createButton {
    if (!_createButton) {
        _createButton = [NSButton buttonWithTitle:@"创建" target:self action:@selector(create)];
        [self.view addSubview:_createButton];
    }
    return _createButton;
}

- (ScrollTableView *)srollTableView {
    if (!_srollTableView) {
        _srollTableView = [[ScrollTableView alloc] init];
        _srollTableView.tableView.dataSource = self;
        _srollTableView.tableView.delegate = self;
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"column"];
        column.title = @"Apps";
        [_srollTableView.tableView addTableColumn:column];
        [self.view addSubview:_srollTableView];
    }
    return _srollTableView;
}

@end

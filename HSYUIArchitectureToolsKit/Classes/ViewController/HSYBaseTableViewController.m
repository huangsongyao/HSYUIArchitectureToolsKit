//
//  HSYBaseTableViewController.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/17.
//

#import "HSYBaseTableViewController.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>

@interface HSYBaseTableViewController () {
    @private UITableView *_tableView;
}

@end

@implementation HSYBaseTableViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lineHidden = YES;
    // Do any additional setup after loading the view.
}

#pragma mark - Setter

- (void)hsy_setTableLineHiddenStatus:(BOOL)lineHidden
{
    _lineHidden = lineHidden;
    self.tableView.separatorStyle = (self.lineHidden ? UITableViewCellSeparatorStyleNone : UITableViewCellSeparatorStyleSingleLine);
}

#pragma mark - Lazy

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.hsy_toListCGRect style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.hsy_deselectRowBlock) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.hsy_deselectRowBlock(indexPath, tableView, cell); 
    }
}



@end

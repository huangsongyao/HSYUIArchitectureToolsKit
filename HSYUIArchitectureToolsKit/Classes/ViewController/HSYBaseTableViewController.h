//
//  HSYBaseTableViewController.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/17.
//

#import "HSYBaseRefreshViewController+Operation.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseTableViewController : HSYBaseRefreshViewController <UITableViewDelegate, UITableViewDataSource>

//默认为NO，设置为YES后，会隐藏list默认是分割线
@property (nonatomic, assign) BOOL lineHidden;
//list的风格
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
//list对象，只读
@property (nonatomic, strong, readonly) UITableView *tableView; 

@end

NS_ASSUME_NONNULL_END

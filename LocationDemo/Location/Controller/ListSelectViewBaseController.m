//
//  LocationListSelectViewController.m
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/17.
//  Copyright (c) 2015年 LRR. All rights reserved.
//

#import "ListSelectViewBaseController.h"

#import "ListSelectBaseCell.h"

@interface ListSelectViewBaseController ()
{
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ListSelectViewBaseController

static  NSString *cellId = @"AREACELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rootNode.childNodes.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ListSelectBaseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];

    Node *node = [self.rootNode nodeAtIndex:indexPath.row];
    cell.node = node;
    return cell;
}




#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Node *node = [self.rootNode nodeAtIndex:indexPath.row];
    if ([node hasChildNode]) {
        ListSelectViewBaseController *locVC = [[ListSelectViewBaseController alloc]init];
        locVC.rootNode = node;
        locVC.tableViewCellClass = self.tableViewCellClass;
        [self.navigationController pushViewController:locVC animated:YES];
    }else {
        
        [self pop:[node returnString]];
    }
}


#pragma mark - pop
- (void)pop:(NSString*)nodeName{
    if (self.navigationController) {

        // 找到push的第一个ListSelectViewBaseController(它持有回传block)
        __weak ListSelectViewBaseController* lastLSvc = self;
        for (NSInteger i = self.navigationController.viewControllers.count-1; i>=0; i--) {
            UIViewController *viewCtl = self.navigationController.viewControllers[i];
            if (![viewCtl isKindOfClass:[self class]]) {
                if (lastLSvc.callbackBlock) {
                    lastLSvc.callbackBlock(nodeName);
                }
                [self.navigationController popToViewController:viewCtl animated:YES];
                break;
            }else{
                lastLSvc =(ListSelectViewBaseController*)viewCtl;
            }
        }
    }
}



#pragma mark --  getter&setter
- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = ColorWithRGBR(244, 244, 244, 1);
    }
    return _tableView;
}

- (void)setRootNode:(Node *)rootNode{
    _rootNode = rootNode;
    [self.tableView reloadData];
}

- (void)setTableViewCellClass:(NSString *)tableViewCellClass{
    _tableViewCellClass = tableViewCellClass;
    Class cellClass = NSClassFromString(self.tableViewCellClass);
    if (![cellClass isSubclassOfClass:[ListSelectBaseCell class]]) {
        NSAssert(NO, @"cell不是ListSelectBaseCell子类!!");
    }
    [self.tableView registerNib:[UINib nibWithNibName:self.tableViewCellClass bundle:nil] forCellReuseIdentifier:cellId];
}

@end

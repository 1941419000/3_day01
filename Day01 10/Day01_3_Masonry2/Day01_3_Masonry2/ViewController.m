//
//  ViewController.m
//  Day01_3_Masonry2
//
//  Created by tarena on 16/6/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"

#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ViewController ()
@property (nonatomic) UIView *greenView;
@property (nonatomic) UIButton *btn;
@end
@implementation ViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //删除之前的约束,添加新的约束
    [self.greenView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //make.top.bottom.left.right.equalTo(0);
        //视图在另一个视图中的4边边距, 内边距
        //make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.edges.equalTo(0);
    }];
}


- (UIButton *)btn {
    if(_btn == nil) {
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_btn];
        _btn.backgroundColor = [UIColor brownColor];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.size.equalTo(CGSizeMake(100, 50));
        }];
        [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
//(id)sender -> sender
- (void)btnClicked:sender{
    CGFloat tmpH = self.greenView.frame.size.height + 20;
    //更新约束
    [UIView animateWithDuration:2 animations:^{
        [self.greenView mas_updateConstraints:^(MASConstraintMaker *make) {
            //make只能作为开头
            make.height.equalTo(tmpH);
        }];
        //修改约束做动画, 必须强制界面刷新
        [self.view layoutIfNeeded];
    }];

}


- (UIView *)greenView {
    if(_greenView == nil) {
        _greenView = [[UIView alloc] init];
        _greenView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_greenView];
        [_greenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(30);
            make.height.equalTo(50);
            make.centerX.equalTo(0);
            make.width.equalTo(self.btn.mas_height).multipliedBy(3).priorityMedium();
            //priority:优先级.
            //绿色视图的宽度<=120
            make.width.lessThanOrEqualTo(20).priorityHigh();
        }];
    }
    return _greenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self greenView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

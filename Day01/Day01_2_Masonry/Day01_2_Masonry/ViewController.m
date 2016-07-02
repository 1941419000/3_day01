//
//  ViewController.m
//  Day01_2_Masonry
//
//  Created by tarena on 16/6/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"
//在引入mas之前,定义下方宏, 可以把mas_equalTo简化为equalTo
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface ViewController ()

//左上角添加一个红色的视图, 距离左,上 20像素. 宽度高度=80
@property (nonatomic) UIView *redView;
//右上角添加一个绿色视图, 距离右,上 20像素. 宽高80
@property (nonatomic) UIView *greenView;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self redView];
    [self greenView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LazyLoad
- (UIView *)redView {
	if(_redView == nil) {
		_redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
#warning 为视图添加约束之前,视图必须有父视图!!!!!!
        [self.view addSubview:_redView];
        //方法中的block传参,一定要用回车打开,让系统自动完成.
        [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
            //红色视图的左边缘距离父视图的左边缘向右移动20
            //在block中, make代替调用方法的视图使用
            //equalTo()的参数,使用mas前缀获取
            //向右,向下 为正,  相反为负
            make.left.mas_equalTo(self.view.mas_left).mas_equalTo(20);
            //红色视图的上边缘距离父视图的上边缘向下移动20
            make.top.mas_equalTo(self.view.mas_top).mas_equalTo(20);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
	}
	return _redView;
}

- (UIView *)greenView {
	if(_greenView == nil) {
		_greenView = [[UIView alloc] init];
        _greenView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_greenView];
        [_greenView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.width.equalTo(80);
            //make.height.equalTo(80);
            //make.size.equalTo(CGSizeMake(80, 80));
            //如果数值相同的约束可以合并
            make.width.height.equalTo(80);
            
            //1.如果A.x属性和B.x属性进行关联. 那么B可以不强调是x属性, 默认就是和A相同的那个
            //make.top.equalTo(self.view.mas_top).equalTo(20);
            make.top.equalTo(self.view).equalTo(20);
            //2.如果不写是跟谁产生的关系, 默认是与父视图
            //make.right.equalTo(self.view.mas_right).equalTo(-20);
            make.right.equalTo(-20);
        }];
	}
	return _greenView;
}

@end








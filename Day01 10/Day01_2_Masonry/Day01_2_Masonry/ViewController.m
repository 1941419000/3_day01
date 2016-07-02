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
//左下角添加一个黄色视图, 距离左,下 20, 宽高80
@property (nonatomic) UIView *yellowView;
//右下角添加一个蓝色视图, 距离右,下 20, 宽高80
@property (nonatomic) UIView *blueView;
//屏幕中心点添加一个紫色, 宽度比黄色大80像素,高度是绿色视图的2倍
@property (nonatomic) UIView *purpleView;
//棕色视图,在紫色视图上方20,左边缘对齐,宽度少40, 高度1/2
@property (nonatomic) UIView *brownView;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self redView];
    [self greenView];
    [self blueView];
    [self yellowView];
    [self purpleView];
    [self brownView];
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

- (UIView *)blueView {
	if(_blueView == nil) {
		_blueView = [[UIView alloc] init];
        _blueView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:_blueView];
        [_blueView mas_makeConstraints:^(MASConstraintMaker *make) {
           //向上,向左 -20
            make.bottom.right.equalTo(-20);
            //make.size.equalTo(CGSizeMake(80, 80));
            make.size.equalTo(80);
        }];
	}
	return _blueView;
}

- (UIView *)yellowView {
	if(_yellowView == nil) {
		_yellowView = [[UIView alloc] init];
        _yellowView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_yellowView];
        //黄色视图,在左下方20. 宽度和高度和红色视图一样
        [_yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.bottom.equalTo(-20);
            //redView懒加载
            //self.redView: 保证指针一定不为空
            //_redView:存在可能性为nil
            make.size.equalTo(self.redView);
        }];
	}
	return _yellowView;
}

- (UIView *)purpleView {
	if(_purpleView == nil) {
		_purpleView = [[UIView alloc] init];
        _purpleView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:_purpleView];
        [_purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.centerX.centerY.equalTo(0);
            //make.center.equalTo(CGPointMake(0, 0));
            make.center.equalTo(0);
            make.width.equalTo(self.yellowView).equalTo(80);
            //multipliedBy: 乘以,  divideBy(0.5)
            make.height.equalTo(self.greenView).multipliedBy(2);
        }];
	}
	return _purpleView;
}

- (UIView *)brownView {
	if(_brownView == nil) {
		_brownView = [[UIView alloc] init];
        _brownView.backgroundColor = [UIColor brownColor];
        [self.view addSubview:_brownView];
        [_brownView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.equalTo(self.purpleView).equalTo(0);
            make.left.equalTo(self.purpleView);
            make.bottom.equalTo(self.purpleView.mas_top).equalTo(-20);
            make.width.equalTo(self.purpleView).equalTo(-40);
            make.height.equalTo(self.purpleView).dividedBy(2);
        }];
	}
	return _brownView;
}

@end








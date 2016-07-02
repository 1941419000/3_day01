//
//  ViewController.m
//  Day01_4_Masonry3
//
//  Created by tarena on 16/6/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"

#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ViewController ()

//计算属性, 在使用get方法调用时, 传出一个算出来的值.
@property (nonatomic, readonly) UIColor *randomColor;
@end
@implementation ViewController
- (UIColor *)randomColor{
    CGFloat r = arc4random()%256 /255.0;
    CGFloat g = arc4random()%256 /255.0;
    CGFloat b = arc4random()%256 /255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *lastView = nil;
    for (int i = 0; i < 10; i++) {
        UIView *v = [UIView new];
        [self.view addSubview:v];
        v.backgroundColor = self.randomColor;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(v.mas_width);
            if (i == 0) {//第一个
                make.left.equalTo(0);
            }else{ //非第一个
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(lastView);
                if (i == 9) { //最后一个
                    make.right.equalTo(0);
                }
            }
        }];
        lastView = v;
    }
    
    
    
    /*
    [self randomColor];
    //计算属性,主要是为了把方法的调用转化为点语法.
    UIColor *c1 = self.randomColor;
    UIColor *c2 = self.randomColor;*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  Day01_1_PlugIn
//
//  Created by tarena on 16/6/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource>
@property (nonatomic) UIImageView *imageView;
@end

@implementation ViewController

+ (instancetype)sharedInstance
{
    static ViewController* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ViewController new];
    });

    return instance;
}
//Edit ->DCLazyInstance->cmd+shift+-(光标必须在要生成的属性行)
//DCLazyInstance -> Setting -> 两个框填cmd 和 + 然后按回车键应用修改

- (instancetype)initWithName:(NSString *)name {
    return nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButtonType btnType;
    
    NSString *str = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)imageView {
    if(_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        //图片的内容模式
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_imageView];
        _imageView.frame = CGRectMake(10, 10, 100, 100);
        _imageView.image = [UIImage imageNamed:@"作业"];
        
        
    }
    return _imageView;
}

@end







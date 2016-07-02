//
//  ViewController.h
//  Day01_4_Masonry3
//
//  Created by tarena on 16/6/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
/**默认带*的是用strong修饰的*/
@property (nonatomic) NSString *name;
/**默认不带*的用assign*/
@property (nonatomic) BOOL has;


@end


//
//  ViewController.h
//  Day01_1_PlugIn
//
//  Created by tarena on 16/6/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

+ (instancetype)sharedInstance;

/**
 *  <#Description#>
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithName:(NSString *)name;

@end









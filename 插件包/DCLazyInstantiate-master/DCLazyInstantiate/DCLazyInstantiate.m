//
//  DCLazyInstantiate.m
//  DCLazyInstantiate
//
//  Created by Youwei Teng on 7/15/15.
//  Copyright (c) 2015 dcard. All rights reserved.
//
//  edited by voxGeminus on 3.12.16

#import "DCLazyInstantiate.h"
#import "DCLazyInstantiateConfig.h"
#import "DCSettingsWindowController.h"

@interface DCLazyInstantiate ()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) DCSettingsWindowController *settingWindow;

@end

@implementation DCLazyInstantiate

DEF_SINGLETON(DCLazyInstantiate);

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
          sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [DCLazyInstantiateConfig setupMenu];
}

- (void)generateLazyInstantiate:(id)sender {
    DVTSourceTextView *sourceTextView = [DCXcodeUtils currentSourceTextView];
	
    //Get the cursor line range
    NSString *viewContent = [sourceTextView string];
    NSRange lineRange = [viewContent lineRangeForRange:[sourceTextView selectedRange]];
    
    // Get the selected text using the range from above.
    NSString *selectedString = [sourceTextView.textStorage.string substringWithRange:lineRange];
    //NSLog(@"DCLazyInstantiate : generateLazyInstantiate, selectedString is:\n%@", selectedString);
    
    // Determine single or multi lines selected
    NSArray *stringArray = [selectedString componentsSeparatedByString:@"\n"];
    //NSLog(@"DCLazyInstantiate : generateLazyInstantiate, stringArray    is:\n%@", stringArray);
    
    
    // Iterate through string array & lazyInstanciate each contained string
    for (NSString *string in stringArray) {
        
        // Check for and skip empty strings generated by "lineRangeForRange"
        if (![string isEqualToString:@""]) {
            NSString *lazyInstantiation = [self lazyInstantiationWithSelectedString:string];
            
            if (lazyInstantiation != nil && lazyInstantiation.length > 0) {
                
                // Find last @end in sourceTextView to determine insertion point.
                // This ensures that placement is guaranteed in cases where
                //     additional lines / space occurs past "@end"
                NSRange endRange = [viewContent rangeOfString:@"@end" options:NSBackwardsSearch];
                
                [[DCXcodeUtils currentTextStorage] beginEditing];
                [[DCXcodeUtils currentTextStorage] replaceCharactersInRange:NSMakeRange((endRange.location), 0)
                                                                 withString:lazyInstantiation
                                                            withUndoManager:[[DCXcodeUtils currentSourceCodeDocument] undoManager]];
                [[DCXcodeUtils currentTextStorage] endEditing];
            }
        }
    }
}

- (NSString *)lazyInstantiationWithSelectedString:(NSString *)selectedString {
    if (selectedString) {
        NSLog(@"DCLazyInstantiate : lazyInstantiationWithSelectedString, selectedString is:\n%@", selectedString);
        
        NSString *result = @"";
        @try {
            NSString *searchedString = selectedString;
            NSRange searchedRange;
            searchedRange = NSMakeRange(0, [searchedString length]);
            NSString *pattern  = @"\\)\\s?(.*?)\\s?\\*([^\\*]+);";
            NSError *error = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
            NSArray *matches = [regex matchesInString:searchedString options:0 range:searchedRange];
            NSLog(@"DCLazyInstantiate : lazyInstantiationWithSelectedString, matches is:\n%@", matches);
            
            if (matches.count != 0) {
                for (NSTextCheckingResult *match in matches) {
                    NSLog(@"DCLazyInstantiate : lazyInstantiationWithSelectedString, match is:\n%@", match);
                    
                    NSString *class = [searchedString substringWithRange:[match rangeAtIndex:1]];
                    NSString *varName = [searchedString substringWithRange:[match rangeAtIndex:2]];
                    
                    //TODO: custom code style
                    // Trim any extras spaces from string
                    //     in case of custom user formatting
                    class = [class stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
                    varName = [varName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
                    
                    // Check for "readonly" attribute
                    if ([searchedString containsString:@"readonly"]) {
                        result = [NSString stringWithFormat:@"- (%@ *)%@ {\n\treturn [[%@ alloc] init];\n}\n\n",
                                  class, varName, class];
                    } else {
                        result = [NSString stringWithFormat:@"- (%@ *)%@ {\n\tif(_%@ == nil) {\n\t\t_%@ = [[%@ alloc] init];\n\t}\n\treturn _%@;\n}\n\n",
                                  class, varName, varName, varName, class, varName];
                    }
                }
            }
            // Primitives and other classes missing the "*" pointer
            else {
                NSString *patternB = @"\\)\\s?(.*?)\\s\\*?([^\\*]+);"; // will include primitives like BOOL, int, NSInteger, etc...
                NSError *errorB = nil;
                NSRegularExpression *regexB = [NSRegularExpression regularExpressionWithPattern:patternB options:0 error:&errorB];
                NSArray *matchesB = [regexB matchesInString:searchedString options:0 range:searchedRange];
                NSLog(@"DCLazyInstantiate : lazyInstantiationWithSelectedString, matchesB is:\n%@", matchesB);
                
                for (NSTextCheckingResult *match in matchesB) {
                    NSLog(@"DCLazyInstantiate : lazyInstantiationWithSelectedString, matchB is:\n%@", match);
                    
                    NSString *class = [searchedString substringWithRange:[match rangeAtIndex:1]];
                    NSString *varName = [searchedString substringWithRange:[match rangeAtIndex:2]];
                    
                    //TODO: custom code style
                    // Trim any extras spaces from string
                    //     in case of custom user formatting
                    class = [class stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
                    varName = [varName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
                    
                    // Check for "readonly" attribute
                    if ([searchedString containsString:@"readonly"]) {
                        result = [NSString stringWithFormat:@"- (%@)%@ {\n\treturn 0;\n}\n\n",
                                  class, varName];
                    } else {
                        result = [NSString stringWithFormat:@"- (%@)%@ {\n\tif(!_%@) {\n\t\t_%@ = 0;\n\t}\n\treturn _%@;\n}\n\n",
                                  class, varName, varName, varName, varName];
                    }
                }
            }
            
            return result;
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception.reason);
            return nil;
        }
    }
}

- (void)showSetting:(id)sender {
    if (nil == self.settingWindow) {
        self.settingWindow = [[DCSettingsWindowController alloc] initWithWindowNibName:NSStringFromClass([DCSettingsWindowController class])];
    }
    [self.settingWindow showWindow:self.settingWindow];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

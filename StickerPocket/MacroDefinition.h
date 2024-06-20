//
//  MacroDefinition.h
//  pianke
//
//  Created by 侯锐 on 15/8/21.
//  Copyright (c) 2015年 pianke. All rights reserved.
//

#ifndef pianke_MacroDefinition_h
#define pianke_MacroDefinition_h

//Screen Width && Height
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)

#define CURRENT_DEVICE_IS_IPAD                 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define kImageWithName(a)               [UIImage imageNamed:a]
#define HRStrongSelf                    __strong typeof(weakSelf) strongSelf = weakSelf
#define HRWeakSelf                      __weak typeof(self) weakSelf = self
#define GROUP_URL                       @"group.com.rui.sticker"
#define USER_DEFAULT_SORTTYPE           @"user_default_sorttype"
#define GROUP_DIRECTORY [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.rui.sticker"].path
#define STICKER_TABLE_NAME @"com.rui.sticker"
#ifdef DEBUG
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DebugLog(s, ...)
#endif

//Color
#define kRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define kRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define THEME_COLOR_PURPLE kRGBCOLOR(89,114,240)

#endif

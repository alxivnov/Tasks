//
//  Constants.h
//  Done!
//
//  Created by Alexander Ivanov on 07.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#define STR_TASK @"com.alexivanov.done.task"

#define GUI_STORYBOARD @"Main"

#define GUI_CELL_ID @"subtitle"

#define GUI_REMOVE @"remove"
#define GUI_REPEAT @"repeat"
#define GUI_FOLDER @"folder"
#define GUI_LOGGER @"logger"
#define GUI_SEND @"send"
#define GUI_ADD @"add"
#define GUI_CLEAR @"clear"
#define GUI_IMPORT @"import"
#define GUI_POSTPONE @"postpone"
#define GUI_SCHEDULE @"schedule"
#define GUI_ACCESS @"access"

#define GUI_ALPHA 0.667

#define GUI_AUTO_SCROLL_HEIGHT 48.0

#define GUI_BURST_SCALE 1.5

#define GUI_SELECT @"select"
#define GUI_CANCEL @"cancel"

#define GUI_SETTINGS @"settings"
#define GUI_UNWIND @"unwind"
#define GUI_FOCUS @"focus"

#define GUI_THEME @"theme"
#define GUI_CALENDAR @"calendar"
#define GUI_OVERDUE @"overdue"
#define GUI_PROCESS @"process"
#define GUI_REVIEW @"review"

#define GUI_POSTPONE @"postpone"

#define GUI_REMINDER @"reminder"

#define GUI_PURCHASE_FREQUENCY 3

#define FTP_URL @"ftp://ftp.done.1gb.ru"
#define FTP_USERNAME @"done140316"
#define FTP_PASSWORD @"W3H-rWp-NyZ-YGy"

#define APP_ID_DONE 734258590
#define APP_ID_LUNA 964733439
#define APP_ID_RINGO 979630381

#define APP_GROUP @"group.alexivanov.done"
#define APP_WIDGET @"com.alexivanov.done.widget"

#define URL_SCHEME @"airtasks"
#define URL_PARAMETER_UUID @"uuid"
#define URL_SHARE @"http://airtasks.net/share.php"

#define KEY_TODAY @"today"
#define KEY_TOMORROW @"tomorrow"

#define SEG_DID_NOT_PAY @"5cc100"
#define SEG_PAYED @"79a50d"

@import Foundation;

@interface Constants : NSObject

+ (void)updateDateTime;
+ (NSTimeInterval)dateTime;

+ (NSString *)appBundleIdentifier;
+ (NSString *)inAppPurchaseFolder;
+ (NSString *)inAppPurchaseRepeat;
+ (NSString *)inAppPurchaseLogger;

@end
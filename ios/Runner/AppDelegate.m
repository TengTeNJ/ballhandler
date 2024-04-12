#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <Firebase.h>
#import <FirebaseMessaging.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    [self configRemoteNotification];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


/// 配置远程通知
- (void)configRemoteNotification{
    // 手动注册APNS通知
       if (@available(iOS 10.0, *)) {
           UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
           center.delegate = self;
           [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
               if (!error) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [[UIApplication sharedApplication] registerForRemoteNotifications];
                   });
               }
           }];
       } else {
           UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
           UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
          // [UIApplication registerUserNotificationSettings:settings];
       }
       
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeProd];
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM Token: %@", fcmToken);
}

@end

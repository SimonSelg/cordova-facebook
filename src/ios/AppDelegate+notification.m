#import "AppDelegate+notification.h"

@implementation AppDelegate (notification)

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation

{
    if (!url) {
        return NO;
    }
    NSLog(@"opening url");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    url, @"url", sourceApplication, @"sourceApplication", @"NO", @"success", nil];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CordovaPluginOpenURLNotification" object:self userInfo:dict]];

    NSString* success = [dict objectForKey:@"success"];

    if([success isEqualToString:@"NO"]) {
        // calls into javascript global function 'handleOpenURL'
        NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
        [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];

        // all plugins will get the notification, and their handlers will be called
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
        return YES;
    }
    return ![success isEqualToString:@"NO"];
}

@end
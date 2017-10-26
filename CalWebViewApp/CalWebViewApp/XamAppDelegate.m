#import "XamAppDelegate.h"
#import "XamUIWebViewController.h"
#import "XamWKWebViewController.h"
#import "XamSafariWebViewController.h"
#import "MBFingerTipWindow.h"

#if LOAD_CALABASH_DYLIB
#import <dlfcn.h>
#endif

@interface XamAppDelegate ()

@property(nonatomic, strong) XamSafariWebViewController *safariController;

@end

@implementation XamAppDelegate

- (UIWindow *)window {
  if (!_window) {
    MBFingerTipWindow *ftWindow = [[MBFingerTipWindow alloc]
                                   initWithFrame:[[UIScreen mainScreen] bounds]];
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    ftWindow.alwaysShowTouches = [arguments containsObject:@"FINGERTIPS"];
    _window = ftWindow;
  }
  return _window;
}


#if LOAD_CALABASH_DYLIB
- (void) loadCalabashDylib {
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *dylibPath;
  dylibPath = [bundle pathForResource:@"libCalabashDynFAT" ofType:@"dylib"];

  NSLog(@"Attempting to load Calabash dylib: '%@'", dylibPath);
  void *dylib = NULL;
  dylib = dlopen([dylibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);

  if (dylib == NULL) {
    char *error = dlerror();
    NSString *message = @"Could not load the Calabash dylib.";
    NSLog(@"%@: %s", message, error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calabash"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  }
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  XamUIWebViewController *firstController = [XamUIWebViewController new];
  XamWKWebViewController *secondViewController = [XamWKWebViewController new];
  UIViewController *thirdViewController = [UIViewController new];
  UIImage *image = [UIImage imageNamed:@"SafariTab"];
  thirdViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Safari"
                                                                 image:image
                                                                   tag:2];


  UITabBarController *tabController = [UITabBarController new];
  tabController.tabBar.translucent = NO;
  tabController.delegate = self;

  tabController.viewControllers = @[firstController, secondViewController, thirdViewController];
  tabController.selectedIndex = 0;
  self.window.rootViewController = tabController;
  [self.window makeKeyAndVisible];

#if LOAD_CALABASH_DYLIB
  [self loadCalabashDylib];
#endif

  return YES;
}

- (BOOL)  tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(nonnull UIViewController *)viewController {
  return YES;
}

- (void) tabBarController:(UITabBarController *)tabBarController
  didSelectViewController:(UIViewController *)viewController {
  // Hack to display SafariViewController inside a TabViewController
  if ([viewController class] != [XamUIWebViewController class] &&
      [viewController class] != [XamWKWebViewController class]) {

    if (!self.safariController) {
      self.safariController = [XamSafariWebViewController new];
    }

    NSMutableArray *viewArray = [tabBarController.viewControllers mutableCopy];
    [viewArray replaceObjectAtIndex:2 withObject:self.safariController];
    tabBarController.viewControllers = viewArray;
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state.
   This can occur for certain types of temporary interruptions (such as an
   incoming phone call or SMS message) or when the user quits the application
   and it begins the transition to the background state. Use this method to
   pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
   Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate
   timers, and store enough application state information to restore your
   application to its current state in case it is terminated later. If your
   application supports background execution, this method is called instead of
   applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of the transition from the background to the inactive state;
   here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application
   was inactive. If the application was previously in the background, optionally
   refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate. Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

@end

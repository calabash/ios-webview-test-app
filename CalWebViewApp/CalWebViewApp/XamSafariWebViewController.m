#import "XamSafariWebViewController.h"

@implementation XamSafariWebViewController

#pragma mark - Memory Management

- (instancetype) init {
  if (self) {
    NSString *tabTitle = @"Safari";

    UIImage *image = [UIImage imageNamed:@"SafariTab"];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle
                                                    image:image
                                                      tag:2];
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *page = @"https://calabash-ci.xyz/CalWebViewApp/page.html";
    NSURL *url = [NSURL URLWithString:page];
    SFSafariViewController *controller;
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        SFSafariViewControllerConfiguration *config = [SFSafariViewControllerConfiguration new];
        controller = [[SFSafariViewController alloc]
                      initWithURL:url
                      configuration:config];
    } else {
        controller = [[SFSafariViewController alloc]
                      initWithURL:url entersReaderIfAvailable:NO];
    }
#else
    controller = [[SFSafariViewController alloc]
                  initWithURL:url entersReaderIfAvailable:NO];
#endif
    
    [controller.view setAccessibilityIdentifier:@"landing page"];
    controller.delegate = self;
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow makeKeyWindow];
    UIViewController *root = [keyWindow rootViewController];
    [root presentViewController:controller
                       animated:NO
                     completion:^{
                         NSLog(@"Presenting SafariViewController");
                     }];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {

}

@end

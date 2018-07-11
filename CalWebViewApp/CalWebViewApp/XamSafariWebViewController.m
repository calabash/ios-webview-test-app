
#import "XamSafariWebViewController.h"
#import "XamURLHelper.h"

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

#pragma mark - View Life Cycle

- (void) loadView {
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIView *view = [[UIView alloc] initWithFrame:frame];

    view.tag = 3030;
    view.accessibilityIdentifier = @"root";

    view.backgroundColor = [UIColor whiteColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [XamURLHelper URLForTestPage];
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

#pragma mark - Delegate

- (void)safariViewController:(SFSafariViewController *)controller
      didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    NSLog(@"Safari WebView page loaded: %@", @(didLoadSuccessfully));

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"kCalHandleSafariWebViewControllerLoaded"
     object:nil
     userInfo:@{@"first_load" : didLoadSuccessfully ? @"YES" : @"NO"}];
}

@end

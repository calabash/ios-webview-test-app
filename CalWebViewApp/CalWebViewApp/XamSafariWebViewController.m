#import "XamSafariWebViewController.h"

@implementation XamSafariWebViewController

#pragma mark - Memory Management

- (instancetype) init {
    NSString *page = @"https://calabash-ci.macminicolo.net/CalWebViewApp/page.html";
    NSURL *url = [NSURL URLWithString:page];
    self = [super initWithURL:url];
    if (self){
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SafariController"
                                                        image:NULL
                                                          tag:0];
        self.delegate = self;
    }
    return self;
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

- (void) safariViewControllerDidFinish:(SFSafariViewController *)controller {
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarController.selectedViewController = _savedController;
}

@end

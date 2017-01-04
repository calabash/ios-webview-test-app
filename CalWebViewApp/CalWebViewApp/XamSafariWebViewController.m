#import "XamSafariWebViewController.h"

@implementation XamSafariWebViewController

#pragma mark - Memory Management

- (instancetype) init {
  NSString *page = @"https://calabash-ci.macminicolo.net/CalWebViewApp/page.html";
  NSURL *url = [NSURL URLWithString:page];
  self = [super initWithURL:url];
  if (self) {

    NSString *tabTitle = @"Safari";

    UIImage *image = [UIImage imageNamed:@"SafariTab"];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle
                                                    image:image
                                                      tag:2];

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

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {

}

@end

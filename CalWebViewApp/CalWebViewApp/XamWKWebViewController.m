#import "XamWKWebViewController.h"

@implementation XamWKWebViewController

#pragma mark - Memory Management

- (instancetype) init {
  self = [super init];
  if (self){
    self.tabBarItem = [[UITabBarItem alloc]
                       initWithTabBarSystemItem:UITabBarSystemItemFavorites
                       tag:1];
  }
  return self;
}

#pragma mark View Lifecycle

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) loadView {
  CGRect frame = [[UIScreen mainScreen] applicationFrame];
  UIView *view = [[UIView alloc] initWithFrame:frame];

  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = view;
}

- (void)viewDidLoad {
  [super viewDidLoad];
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

@end

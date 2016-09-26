#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

@interface XamSafariWebViewController : SFSafariViewController <SFSafariViewControllerDelegate>

@property (strong, nonatomic) UIViewController* savedController;

@end

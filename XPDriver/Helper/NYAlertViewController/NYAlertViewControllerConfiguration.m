#import "NYAlertViewControllerConfiguration.h"

@implementation NYAlertViewControllerConfiguration

- (instancetype)init {
    self = [super init];

    if (self) {
        _showsStatusBar = YES;
        _transitionStyle = NYAlertViewControllerTransitionStyleSlideFromTop;

        _backgroundTapDismissalGestureEnabled = NO;
        _swipeDismissalGestureEnabled = NO;
        _alwaysArrangesActionButtonsVertically = NO;

        _titleTextColor = [UIColor appGrayColor];
        _messageTextColor = [UIColor appGrayColor];

        _alertViewBackgroundColor = [UIColor whiteColor];
        _alertViewCornerRadius = 6.0f;

        _showsSeparators = YES;
        _separatorColor = [UIColor lightGrayColor];

        _contentViewInset = UIEdgeInsetsZero;

        _titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _messageFont = [UIFont normal];

        _buttonConfiguration = [NYAlertActionConfiguration new];
        _destructiveButtonConfiguration = [NYAlertActionConfiguration new];
        _destructiveButtonConfiguration.titleColor = [UIColor colorWithRed:1.0f green:0.23f blue:0.21f alpha:1.0f];

        _cancelButtonConfiguration = [NYAlertActionConfiguration new];
        _cancelButtonConfiguration.titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _cancelButtonConfiguration.titleColor = [UIColor appBlueColor];
    }

    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    // TODO: Implement this
    return self;
}

@end

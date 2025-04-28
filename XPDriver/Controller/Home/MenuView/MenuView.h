//
//  MenuView.h
//  XPDriver
//
//  Created by Syed zia on 25/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MenuViewDeleagte <NSObject>
- (void)showView:(NSString *)identifier url:(nullable NSURL*)url;
- (void)walletsClick;
- (void)CustomLocationClick;
- (void)clickDriverAvailability;
@end
@interface MenuView : UIView
@property (nonatomic,strong) id <MenuViewDeleagte> delegate;
@property (nonatomic,assign) BOOL isShown;
- (void)dataSetupWithDeleagte:(id<MenuViewDeleagte>)menuViewDeleagte;
@end

NS_ASSUME_NONNULL_END

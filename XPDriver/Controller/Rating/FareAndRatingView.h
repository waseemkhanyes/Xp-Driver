//
//  FairAndRatingView.h
//  fivestartdriver
//
//  Created by Syed zia ur Rehman on 26/07/2014.
//  Copyright (c) 2014 Syed zia ur Rehman. All rights reserved.
//
#import "AppDelegate.h"
@protocol FareAndRatingViewDelegate <NSObject>
- (void)deleteOrder:(Order *)order;
@end
@interface FareAndRatingView : UIViewController <StarRatingViewDelegate>
{
BOOL isShowen;
}
@property (assign,nonatomic) BOOL  isRideCompleted;
@property (assign,nonatomic) BOOL  isHideConfirmBtn;
@property (assign,nonatomic) BOOL  isCash;
@property (assign,nonatomic) BOOL  isMessage;
@property (assign,nonatomic) BOOL  isUser;
@property (retain,nonatomic) NSString *message;
@property (nonatomic,retain) NSString *ratingIs;
@property (strong, nonatomic) id <FareAndRatingViewDelegate>delegate;
@property (nonatomic,strong) Order *order;
@property (strong, nonatomic) IBOutlet UIView *ratingView;
@property (nonatomic,strong) TQStarRatingView *starRatingView;
@property (retain, nonatomic) IBOutlet UIPlaceHolderTextView *reviewTextView;
@property (retain, nonatomic) IBOutlet UIView  *review;
@property (strong, nonatomic) IBOutlet UIImageView *orderIconImageVIew;


@end

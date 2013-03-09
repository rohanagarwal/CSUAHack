//
//  EventCell.h
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (strong, nonatomic) UILabel* organizationLabel;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* locationLabel;
@property (strong, nonatomic) UILabel* startDate;
@property (strong, nonatomic) UILabel* endDate;

@end

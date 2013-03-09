//
//  PersonViewController.h
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>

@interface PersonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EKEventEditViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *connectedState;
@property (strong, nonatomic) IBOutlet UILabel *connectionInfo;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@end

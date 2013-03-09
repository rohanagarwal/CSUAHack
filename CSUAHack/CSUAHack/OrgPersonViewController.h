//
//  OrgPersonViewController.h
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import <UIKit/UIKit.h>
#import "OrganizationObj.h"
#import "ServerManager.h"

@interface OrgPersonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ServerRequestDelegate>
@property (strong, nonatomic) IBOutlet UILabel *connectedState;
@property (strong, nonatomic) IBOutlet UILabel *connectedDescription;

@property (strong, nonatomic) OrganizationObj* orgObj;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

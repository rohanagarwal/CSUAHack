//
//  OrgPersonViewController.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import "OrgPersonViewController.h"
#import "BumpClient.h"
#import "CSUAType.h"
#import "EventObj.h"
#import "EventCell.h"
#import <QuartzCore/QuartzCore.h>

@interface OrgPersonViewController ()

{
    BumpChannelID connectedChannel;
}

@property (strong, nonatomic) NSMutableArray* allEvents;
@property (strong, nonatomic) NSMutableArray* selectedIndexes;

@end

@implementation OrgPersonViewController
@synthesize allEvents = _allEvents, selectedIndexes = _selectedIndexes;
@synthesize orgObj = _orgObj, tableView = _tableView;
@synthesize connectedDescription = _connectedDescription;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // send button
    UIBarButtonItem* sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendEvents)];
    self.navigationItem.rightBarButtonItem = sendButton;
    
    [self configureBump];
    
    [self.connectedState.layer setShadowOpacity:1.0];
    [self.connectedState.layer setShadowRadius:1.0];
    [self.connectedState.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.connectedState.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [self.connectedDescription.layer setShadowOpacity:1.0];
    [self.connectedDescription.layer setShadowRadius:1.0];
    [self.connectedDescription.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.connectedDescription.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];

    self.allEvents = [[NSMutableArray alloc] init];
    self.selectedIndexes = [[NSMutableArray alloc] init];

    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setRowHeight:75];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    
    [self.tableView registerClass:[EventCell class] forCellReuseIdentifier:@"EventCell"];
}
-(void) sendEvents {
    NSMutableArray* sendEvents = [[NSMutableArray alloc] init];
    for (NSNumber* number in self.selectedIndexes) {
        [sendEvents addObject:[self.allEvents objectAtIndex:[number intValue]]];
    }
    NSData* myData = [NSKeyedArchiver archivedDataWithRootObject:sendEvents];
    [[BumpClient sharedClient] sendData:myData toChannel:connectedChannel];
 //   [[ServerManager sharedManager] postAnalytic:sendEvents];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.connectedDescription setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title= self.orgObj.orgName;
    [[ServerManager sharedManager] getEventsForOrganization:self.orgObj.orgID delegate:self];
}

- (void) configureBump {
    // userID is a string that you could use as the user's name, or an ID that is semantic within your environment
    [BumpClient configureWithAPIKey:BumpAPI andUserID:[[UIDevice currentDevice] name]];
    
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) {
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        connectedChannel = channel;
        self.connectedState.text = @"Connected";
        [self.connectedDescription setHidden:YES];
    }];
    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel],
              [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
    }];
    
    
    // optional callback
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
        } else {
            NSLog(@"Bump disconnected...");
        }
    }];
    
    // optional callback
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
        switch(event) {
            case BUMP_EVENT_BUMP:
                NSLog(@"Bump detected.");
                break;
            case BUMP_EVENT_NO_MATCH:
                NSLog(@"No match.");
                break;
        }
    }];
}

-(void) gotEventsForOrganization:(NSArray*)events {
    NSLog(@"events: %@", events);
    [self.allEvents removeAllObjects];
    [self.allEvents addObjectsFromArray:events];
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Events";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {// custom view for header. will be adjusted to default or specified header height
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(30, 0, 300, 40);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.text = @"   Events";
    headerLabel.textColor = [UIColor whiteColor];
    [headerLabel.layer setShadowOpacity:1.0];
    [headerLabel.layer setShadowRadius:1.0];
    [headerLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [headerLabel.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    // headerLabel.textAlignment = NSTextAlignmentCenter;
    UIView* view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor greenColor]];
    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allEvents count];
}

- (EventCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    EventObj* obj = (EventObj*)[self.allEvents objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.organizationLabel.text = obj.organizationName;
    cell.organizationLabel.font = [UIFont systemFontOfSize:13.0];
    cell.organizationLabel.textColor = [UIColor darkTextColor];
    cell.nameLabel.text = obj.eventName;
    cell.nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.nameLabel.textColor = [UIColor blackColor];
    cell.locationLabel.text = obj.location;
    cell.locationLabel.font = [UIFont italicSystemFontOfSize:12.0];
    cell.locationLabel.textColor = [UIColor blackColor];
    cell.startDate.text = [obj StringStartDate];
    cell.startDate.font = [UIFont systemFontOfSize:12.0];
    cell.startDate.textColor = [UIColor blackColor];
    cell.endDate.text = [obj StringEndDate];
    cell.endDate.font = [UIFont systemFontOfSize:12.0];
    cell.endDate.textColor = [UIColor blackColor];
    
    [cell.organizationLabel.layer setShadowOpacity:1.0];
    [cell.organizationLabel.layer setShadowRadius:1.0];
    [cell.organizationLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.organizationLabel.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [cell.nameLabel.layer setShadowOpacity:1.0];
    [cell.nameLabel.layer setShadowRadius:1.0];
    [cell.nameLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.nameLabel.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [cell.locationLabel.layer setShadowOpacity:1.0];
    [cell.locationLabel.layer setShadowRadius:1.0];
    [cell.locationLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.locationLabel.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [cell.startDate.layer setShadowOpacity:1.0];
    [cell.startDate.layer setShadowRadius:1.0];
    [cell.startDate.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.startDate.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [cell.endDate.layer setShadowOpacity:1.0];
    [cell.endDate.layer setShadowRadius:1.0];
    [cell.endDate.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.endDate.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell accessoryType] == UITableViewCellAccessoryNone) {
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.selectedIndexes addObject:[NSNumber numberWithInt:indexPath.row]];
    } else {
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
        [self.selectedIndexes removeObject:[NSNumber numberWithInt:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

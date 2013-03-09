//
//  SelectOrgViewController.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import "SelectOrgViewController.h"
#import "OrgPersonViewController.h"
#import "OrganizationObj.h"

@interface SelectOrgViewController ()

@property (strong, nonatomic) NSMutableArray* allOrganizations;

@end

@implementation SelectOrgViewController
@synthesize allOrganizations = _allOrganizations;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(toOrgMemberPage)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    UIView* background = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    [self.tableView setBackgroundView:background];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    self.allOrganizations = [[NSMutableArray alloc] init];
}
-(void) gotOrganizations:(NSArray*)allOrgs {
    [self.allOrganizations removeAllObjects];
    [self.allOrganizations addObjectsFromArray:allOrgs];
    NSLog(@"all: %@", self.allOrganizations);
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [[ServerManager sharedManager] getOrganizations:self];
}


-(void) toOrgMemberPage {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self performSegueWithIdentifier:@"toOrgPerson" sender:selectedIndexPath];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select an organization" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allOrganizations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = ((OrganizationObj*)[self.allOrganizations objectAtIndex:indexPath.row]).orgName;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Organizations";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {// custom view for header. will be adjusted to default or specified header height
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(30, 0, 300, 40);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.text = @"   Organizations";
    headerLabel.textColor = [UIColor whiteColor];
   // headerLabel.textAlignment = NSTextAlignmentCenter;
    UIView* view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor greenColor]];
    return headerLabel;
}


#pragma mark - segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath*)sender {
    OrgPersonViewController* vc = [segue destinationViewController];
    vc.orgObj = [self.allOrganizations objectAtIndex:sender.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

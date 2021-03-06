//
//  MTEdiagnosticoTableViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/27/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEdiagnosticoTableViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEdiagTableViewCell.h"

@interface MTEdiagnosticoTableViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *diagnosticosSearchBar;

@end

@implementation MTEdiagnosticoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.diagnosticos = [[MTEMedicalCenter sharedCenter] diagnosticos];
    self.filteredDiagnosticos = [NSMutableArray arrayWithCapacity:[self.diagnosticos count]];
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredDiagnosticos count];
    } else {
        return [self.diagnosticos count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"diagnostico";
    MTEdiagTableViewCell *cell = (MTEdiagTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MTEdiagTableViewCell"
                                                                 owner:self
                                                               options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (MTEdiagTableViewCell *) currentObject;
                break;
            }
        }
    }
    MTEdiagnostico *diag = [[MTEdiagnostico alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        diag = [self.filteredDiagnosticos objectAtIndex:indexPath.row];
    } else
    {
        diag = [self.diagnosticos objectAtIndex:indexPath.row];
    }
    UILabel *desc = (UILabel *)[cell viewWithTag:100];
    desc.text = diag.desc;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        self.cvc.diag = [self.filteredDiagnosticos objectAtIndex:indexPath.row];
    } else {
        self.cvc.diag = [self.diagnosticos objectAtIndex:indexPath.row];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredDiagnosticos removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(desc contains[c] %@) OR (codigo contains[c] %@)",searchText,searchText,searchText];
    self.filteredDiagnosticos = [NSMutableArray arrayWithArray:[self.diagnosticos filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end

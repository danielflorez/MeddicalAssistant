//
//  MTEmedicamentosTableViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/28/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEmedicamentosTableViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEmedicamentoTableViewCell.h"

@interface MTEmedicamentosTableViewController ()

@end

@implementation MTEmedicamentosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.medicamentos = [[MTEMedicalCenter sharedCenter] medicamentos];
    self.filteredMedicamentos = [NSMutableArray arrayWithCapacity:[self.medicamentos count]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.filteredMedicamentos count];
    } else
    {
        return [self.medicamentos count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"medicamento";
    MTEmedicamentoTableViewCell *cell = (MTEmedicamentoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MTEmedicamentoTableViewCell"
                                                                 owner:self
                                                               options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (MTEmedicamentoTableViewCell *) currentObject;
                break;
            }
        }
    }
    MTEmedicamento *med = [[MTEmedicamento alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        med = [self.filteredMedicamentos objectAtIndex:indexPath.row];
    } else
    {
        med = [self.medicamentos objectAtIndex:indexPath.row];
    }
    UILabel *desc = (UILabel *)[cell viewWithTag:200];
    desc.text = med.nombre;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTEformulacion *form = [[MTEformulacion alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        form.medicamento = [self.filteredMedicamentos objectAtIndex:indexPath.row];
    }
    else
    {
        form.medicamento = [self.medicamentos objectAtIndex:indexPath.row];
    }
    [self.fcvc.formulaciones addObject:form];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredMedicamentos removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(nombre contains[c] %@) OR (compActivo contains[c] %@)",searchText,searchText,searchText];
    self.filteredMedicamentos = [NSMutableArray arrayWithArray:[self.medicamentos filteredArrayUsingPredicate:predicate]];
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

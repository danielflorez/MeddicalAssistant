//
//  MTEClientesTableViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/24/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEClientesTableViewController.h"
#import "MTEPacienteTableViewCell.h"
#import "MTEpaciente.h"
#import "MTEMedicalCenter.h"
#import "MTECrearClienteViewController.h"

@interface MTEClientesTableViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *clientesSearchBar;

@end

@implementation MTEClientesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pacientes = [[MTEMedicalCenter sharedCenter] pacientes];
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addPaciente)];
    [[self navigationItem] setRightBarButtonItem:bbi];
    [self.navigationItem setTitle:@"Pacientes"];
    self.filteredPacientesArray = [NSMutableArray arrayWithCapacity:[self.pacientes count]];
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


- (void) addPaciente
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                         bundle:nil];
    MTECrearClienteViewController *ccvc = [storyboard instantiateViewControllerWithIdentifier:@"crearCliente"];
    ccvc.memberID = self.memberID;
    ccvc.crear = 1;
    [self.navigationController pushViewController:ccvc
                                         animated:YES];
}

- (void) reloadData
{
    self.pacientes = [[MTEMedicalCenter sharedCenter] pacientes];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredPacientesArray count];
    } else {
        return [self.pacientes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"paciente";
    MTEPacienteTableViewCell *cell = (MTEPacienteTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MTEPacienteTableViewCell"
                                                                 owner:self
                                                               options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (MTEPacienteTableViewCell *) currentObject;
                break;
            }
        }
    }
    MTEpaciente *pac = [[MTEpaciente alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        pac = [self.filteredPacientesArray objectAtIndex:indexPath.row];
    } else
    {
        pac = [self.pacientes objectAtIndex:indexPath.row];
    }
    UILabel *nombre = (UILabel *)[cell viewWithTag:100];
    UILabel *telefono = (UILabel *)[cell viewWithTag:200];
    UILabel *cedula = (UILabel *)[cell viewWithTag:300];
    nombre.text = [NSString stringWithFormat:@"%@ %@",pac.nombre,pac.apellido];
    telefono.text = pac.telefono;
    cedula.text = pac.cedula;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cita)
    {
        self.ccvc.pac =[self.pacientes objectAtIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                             bundle:nil];
        MTECrearClienteViewController *ccvc = [storyboard instantiateViewControllerWithIdentifier:@"crearCliente"];
        ccvc.memberID = self.memberID;
        ccvc.crear = 0;
        ccvc.selec = 0;
        ccvc.paci = [self.pacientes objectAtIndex:indexPath.row];
        ccvc.index = indexPath;
        ccvc.ctvc = self;
        [self.navigationController pushViewController:ccvc
                                             animated:YES];
    }
    
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredPacientesArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(nombre contains[c] %@) OR (apellido contains[c] %@) OR (cedula contains[c] %@)",searchText,searchText,searchText];
    self.filteredPacientesArray = [NSMutableArray arrayWithArray:[self.pacientes filteredArrayUsingPredicate:predicate]];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

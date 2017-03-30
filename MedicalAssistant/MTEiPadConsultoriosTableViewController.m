//
//  MTEiPadConsultoriosTableViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/16/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEiPadConsultoriosTableViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEiPadCrearConsultorioViewController.h"
#import "MTEiPadAgendaViewController.h"

@interface MTEiPadConsultoriosTableViewController ()

@end

@implementation MTEiPadConsultoriosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(28,0,0,0);
    self.consultorios = [[MTEMedicalCenter sharedCenter] consultorios];
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addConsultorio)];
    [[self navigationItem] setRightBarButtonItem:bbi];
    [self.navigationItem setTitle:@"Consultorios"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)addConsultorio
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadCrearConsultorioViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"ipadCrearConsultorio"];
    cvc.memberID = self.memberID;
    cvc.ctvc = self;
    cvc.crear = 1;
    [self.navigationController pushViewController:cvc
                                         animated:YES];
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
    return [self.consultorios count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"consultorio" forIndexPath:indexPath];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    UILabel *detail = (UILabel *)[cell viewWithTag:200];
    MTEconsultorio *consul =[self.consultorios objectAtIndex:indexPath.row];
    [lblName setText:[consul descr]];
    [detail setText:[NSString stringWithFormat:@"Dir:%@ Tel:%@",consul.direccion,consul.telefono]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.agenda) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        MTEiPadAgendaViewController *avc = [storyboard instantiateViewControllerWithIdentifier:@"agendaView"];
        avc.consul = [self.consultorios objectAtIndex:indexPath.row];
        avc.memberID = self.memberID;
        [self.navigationController pushViewController:avc
                                             animated:YES];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        MTEiPadCrearConsultorioViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"ipadCrearConsultorio"];
        cvc.memberID = self.memberID;
        cvc.ctvc = self;
        cvc.crear = 0;
        cvc.consultorio = [self.consultorios objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:cvc
                                             animated:YES];
    }
    
    
    
}

-(void)reloadData
{
    self.consultorios = [[MTEMedicalCenter sharedCenter] consultorios];
    [self.tableView reloadData];
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
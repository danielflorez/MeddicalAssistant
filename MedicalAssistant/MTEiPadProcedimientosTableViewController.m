//
//  MTEiPadProcedimientosTableViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/7/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEiPadProcedimientosTableViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEiPadCrearProcedimientoViewController.h"

@interface MTEiPadProcedimientosTableViewController ()

@end

@implementation MTEiPadProcedimientosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.procedimientos = [[MTEMedicalCenter sharedCenter] procedimientos];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(28,0,0,0);
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addProcedimiento)];
    [[self navigationItem] setRightBarButtonItem:bbi];
    [self.navigationItem setTitle:@"Procedimientos"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)addProcedimiento
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadCrearProcedimientoViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"iPadCrearProcedimiento"];
    cvc.memberID = self.memberID;
    cvc.ptvc = self;
    cvc.crear = 1;
    [self.navigationController pushViewController:cvc
                                         animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData
{
    self.procedimientos = [[NSMutableArray alloc] init];
    self.procedimientos = [[MTEMedicalCenter sharedCenter] procedimientos];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.procedimientos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iPadProcedimentoCell" forIndexPath:indexPath];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    MTEprocedimiento *proc =[self.procedimientos objectAtIndex:indexPath.row];
    [lblName setText:[proc nombre]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cita)
    {
        self.ccvc.proc =[self.procedimientos objectAtIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        MTEprocedimiento *proc = (MTEprocedimiento *)[self.procedimientos objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        MTEiPadCrearProcedimientoViewController *cpvc = [storyboard instantiateViewControllerWithIdentifier:@"iPadCrearProcedimiento"];
        cpvc.memberID = self.memberID;
        cpvc.proc = proc;
        cpvc.crear = 0;
        cpvc.index = indexPath;
        cpvc.ptvc = self;
        [self.navigationController pushViewController:cpvc animated:YES];
    }
}
@end

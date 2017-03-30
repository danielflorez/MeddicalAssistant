//
//  MTEiPadAgendaViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/5/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEiPadAgendaViewController.h"
#import "MTEiPadAgendaMonthViewController.h"
#import "MTEiPadDayAgendaTableViewController.h"


@interface MTEiPadAgendaViewController ()
@property (nonatomic, strong) MTEiPadAgendaMonthViewController *monthView;
@property (nonatomic, strong) MTEiPadDayAgendaTableViewController *dayView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation MTEiPadAgendaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    self.monthView = [storyboard instantiateViewControllerWithIdentifier:@"ipadMonth"];
    self.monthView.collectionView.frame = CGRectMake(0, 6,(self.view.frame.size.width/3)+69, self.view.frame.size.height);
    self.monthView.avc = self;
    self.monthView.memberID = self.memberID;
    self.monthView.consul = self.consul;
    [self.view addSubview:self.monthView.collectionView];
    [self.monthView cargarCitas];
    self.dayView  = [storyboard instantiateViewControllerWithIdentifier:@"ipadDayAgenda"];
    self.dayView.tableView.frame = CGRectMake((self.view.frame.size.width/3)+69, 69, (2*(self.view.frame.size.width/3))-69, self.view.frame.size.height);
    self.dayView.avc = self;
    self.dayView.day = self.monthView.currentDate;
    self.dayView.memberID = self.memberID;
    [self.view addSubview:self.dayView.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:self.consul.descr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedDateChanged:(MTEday *)day
{
    self.dayView.day = day;
    [self.dayView cargarHoras];
}

- (void)citasChanged
{
    self.dayView.citas = self.monthView.citas;
    [self.dayView cargarHoras];
}

-(void)addCita:(MTEcita *)cita
{
    [self.monthView.citas addObject:cita];
    [self citasChanged];
}

-(void)updateCita:(MTEcita *)cita
{
    for (int i = 0;i < [self.monthView.citas count]; i ++)
    {
        MTEcita *cit = [self.monthView.citas objectAtIndex:i];
        if ([cit.idCita isEqualToString:cita.idCita])
        {
            [self.monthView.citas replaceObjectAtIndex:i withObject:cita];
        }
    }
    [self citasChanged];
}

- (void)disableInteraction
{
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.dayView.tableView.userInteractionEnabled = NO;
    self.monthView.collectionView.userInteractionEnabled = NO;
}

- (void)enableInteraction
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.dayView.tableView.userInteractionEnabled = YES;
    self.monthView.collectionView.userInteractionEnabled = YES;
    [self.spinner stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

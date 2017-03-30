//
//  MTEiPadMainMenuViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 8/29/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEiPadMainMenuViewController.h"
#import "MTEiPadAgendaViewController.h"
#import "MTEiPadConsultoriosTableViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEiPadClientesTableViewController.h"
#import "MTEiPadEntidadesTableViewController.h"
#import "MTEiPadProcedimientosTableViewController.h"

@interface MTEiPadMainMenuViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (weak, nonatomic) IBOutlet UIButton *agendaButton;
@property (weak, nonatomic) IBOutlet UIButton *crearConsultorioButton;
@property (weak, nonatomic) IBOutlet UIButton *pacientesButton;
@property (weak, nonatomic) IBOutlet UIButton *entidadesButton;
@property (weak, nonatomic) IBOutlet UIButton *procedimientosButton;

@end

@implementation MTEiPadMainMenuViewController

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
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton = YES;
    [self getId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agendaClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadConsultoriosTableViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"iPadConsultorios"];
    cvc.agenda = true;
    cvc.memberID = self.memberID;
    [self.navigationController pushViewController:cvc
                                         animated:YES];
}

- (IBAction)crearConsultorioClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadConsultoriosTableViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"iPadConsultorios"];
    cvc.agenda = false;
    cvc.memberID = self.memberID;
    [self.navigationController pushViewController:cvc
                                         animated:YES];
}

- (IBAction)pacienteClick:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadClientesTableViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"iPadClientes"];
    cvc.memberID = self.memberID;
    [self.navigationController pushViewController:cvc
                                         animated:YES];
}

- (IBAction)entidadesClick:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadEntidadesTableViewController *etvc = [storyboard instantiateViewControllerWithIdentifier:@"iPadEntidades"];
    etvc.memberID = self.memberID;
    [self.navigationController pushViewController:etvc
                                         animated:YES];
}

- (IBAction)procedimientoClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadProcedimientosTableViewController *ptvc = [storyboard instantiateViewControllerWithIdentifier:@"ipadProcedimientos"];
    ptvc.memberID = self.memberID;
    [self.navigationController pushViewController:ptvc
                                         animated:YES];
}

- (void)getId
{
    self.agendaButton.enabled = NO;
    self.crearConsultorioButton.enabled = NO;
    self.pacientesButton.enabled = NO;
    self.entidadesButton.enabled = NO;
    self.procedimientosButton.enabled = NO;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&email=%@",_email];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/getID.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.dataRecieved setLength:0];//Set your data to 0 to clear your buffer
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.dataRecieved appendData:data];//Append the download data..
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Use your downloaded data here
    NSDictionary *invites = [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                            options:0
                                                              error:nil];
    for (NSDictionary *item in [invites objectForKey:@"Events"]) {
        self.memberID = item[@"ID"];
    }
    [MTEMedicalCenter sharedCenter].memberID = self.memberID;
    [[MTEMedicalCenter sharedCenter] loadData];
    self.agendaButton.enabled = YES;
    self.crearConsultorioButton.enabled = YES;
    self.pacientesButton.enabled = YES;
    self.entidadesButton.enabled = YES;
    self.procedimientosButton.enabled = YES;
    [self.spinner stopAnimating];
}

@end

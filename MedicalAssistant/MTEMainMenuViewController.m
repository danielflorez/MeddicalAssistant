//
//  MTEMainMenuViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 8/29/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEMainMenuViewController.h"
#import "MTEConsultoriosTableViewController.h"
#import "MTEClientesTableViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEentidadesTableViewController.h"
#import "MTEProcedimientosTableViewController.h"

@interface MTEMainMenuViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (weak, nonatomic) IBOutlet UIButton *agendaButton;
@property (weak, nonatomic) IBOutlet UIButton *crearConsultorioButton;
@property (weak, nonatomic) IBOutlet UIButton *pacienteButton;
@property (weak, nonatomic) IBOutlet UIButton *entidadesButton;
@property (weak, nonatomic) IBOutlet UIButton *procedimientosButton;

@end

@implementation MTEMainMenuViewController

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
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    [self getId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agendaClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEConsultoriosTableViewController *ctvc = [storyboard instantiateViewControllerWithIdentifier:@"consultoriosTable"];
    ctvc.agenda = true;
    ctvc.memberID = self.memberID;
    [self.navigationController pushViewController:ctvc
                                         animated:YES];
}

- (IBAction)consultoriosClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEConsultoriosTableViewController *ctvc = [storyboard instantiateViewControllerWithIdentifier:@"consultoriosTable"];
    ctvc.agenda = false;
    ctvc.memberID = self.memberID;
    [self.navigationController pushViewController:ctvc
                                         animated:YES];
}

- (IBAction)pacientesClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEClientesTableViewController *ctvc = [storyboard instantiateViewControllerWithIdentifier:@"pacientesTVC"];
    ctvc.cita = false;
    ctvc.memberID = self.memberID;
    [self.navigationController pushViewController:ctvc
                                         animated:YES];
}

- (IBAction)entidadesClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEentidadesTableViewController *etvc = [storyboard instantiateViewControllerWithIdentifier:@"entidadesTVC"];
    etvc.memberID = self.memberID;
    [self.navigationController pushViewController:etvc
     
                                         animated:YES];
}

- (IBAction)procedimientosClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEProcedimientosTableViewController *ptvc = [storyboard instantiateViewControllerWithIdentifier:@"procedimientosTVC"];
    ptvc.memberID = self.memberID;
    ptvc.cita = false;
    [self.navigationController pushViewController:ptvc
     
                                         animated:YES];
}

- (void)getId
{
    self.agendaButton.enabled = NO;
    self.crearConsultorioButton.enabled = NO;
    self.pacienteButton.enabled = NO;
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
    [[MTEMedicalCenter sharedCenter] loadDiagnosticos];
    [[MTEMedicalCenter sharedCenter] loadMedicamentos];
    self.agendaButton.enabled = YES;
    self.crearConsultorioButton.enabled = YES;
    self.pacienteButton.enabled = YES;
    self.entidadesButton.enabled = YES;
    self.procedimientosButton.enabled = YES;
    [self.spinner stopAnimating];
}

@end

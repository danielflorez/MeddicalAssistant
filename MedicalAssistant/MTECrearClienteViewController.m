//
//  MTECrearClienteViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/23/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTECrearClienteViewController.h"
#import "MTESelecEntidadTableViewController.h"
#import "MTEMedicalCenter.h"

@interface MTECrearClienteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nombreText;
@property (weak, nonatomic) IBOutlet UITextField *apellidoText;
@property (weak, nonatomic) IBOutlet UITextField *cedulaText;
@property (weak, nonatomic) IBOutlet UITextField *telefonoText;
@property (weak, nonatomic) IBOutlet UITextField *direccionText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIButton *selecEntidadButton;
@property (weak, nonatomic) IBOutlet UIButton *crearButton;
@property (weak, nonatomic) IBOutlet UITextField *dayText;
@property (weak, nonatomic) IBOutlet UITextField *monthText;
@property (weak, nonatomic) IBOutlet UITextField *yearText;
@property (nonatomic, strong) MTESelecEntidadTableViewController *sevc;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@end

@implementation MTECrearClienteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.entSeleccionada = 0;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:tapRecognizer];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 600)];
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.entSeleccionada == 0)
    {
        [self.selecEntidadButton setTitle:@"Seleccionar Entidad"
                                 forState:UIControlStateNormal];
    }else
    {
        NSString *title = [self.entSeleccionada nombre];
        [self.selecEntidadButton setTitle:title
                                 forState:UIControlStateNormal];
    }
    if (self.crear == 1)
    {
        [self.cedulaText setEnabled:YES];
        [self.crearButton setTitle:@"Crear"
                          forState:UIControlStateNormal];
    }
    else
    {
        [self.cedulaText setEnabled:NO];
        self.nombreText.text = self.paci.nombre;
        self.apellidoText.text = self.paci.apellido;
        self.cedulaText.text = self.paci.cedula;
        self.telefonoText.text = self.paci.telefono;
        self.direccionText.text = self.paci.direccion;
        self.emailText.text = self.paci.email;
        NSString *birthday = self.paci.fechaNacimiento;
        if (birthday) {
            NSString *year = [birthday componentsSeparatedByString:@"-"][0];
            NSString *month = [birthday componentsSeparatedByString:@"-"][1];
            NSString *day = [birthday componentsSeparatedByString:@"-"][2];
            self.yearText.text = year;
            self.monthText.text = month;
            self.dayText.text = day;
        }
        
        if (self.selec == 0) {
            MTEEntidad *en1;
            NSMutableArray *arr = [[MTEMedicalCenter sharedCenter]entidades];
            for (MTEEntidad *ent in arr) {
                if ([self.paci.idEntidad isEqualToString:ent.idEnt]) {
                    en1 = ent;
                    break;
                }
            }
            self.entSeleccionada = en1;
        }
        if (self.crear!=2){
        [self.selecEntidadButton setTitle:[self.entSeleccionada  nombre]
                                 forState:UIControlStateNormal];
        }
        [self.crearButton setTitle:@"Grabar"
                          forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selecEntidadClick:(id)sender
{
    if (!self.sevc)
    {
        self.sevc = [[MTESelecEntidadTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    self.sevc.ccvc = self;
    self.sevc.memberID = self.memberID;
    [self.navigationController pushViewController:self.sevc
                                         animated:YES];
}

- (IBAction)crearClick:(id)sender
{
    self.crearButton.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    BOOL valid = YES;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *nombre = self.nombreText.text;
    NSString *apellido = self.apellidoText.text;
    NSString *cedula = self.cedulaText.text;
    NSString *telefono = self.telefonoText.text;
    NSString *direccion = self.direccionText.text;
    NSString *email = self.emailText.text;
    if ([nombre isEqualToString:@""])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The name field can't be empty.";
        }
        else {
            title = @"Falto llenar el campo nombre.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.crearButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    if ([apellido isEqualToString:@""]) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The last name field can't be empty.";
        }
        else {
            title = @"Falto llenar el campo apellido.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.crearButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    if ([cedula isEqualToString:@""]) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The id field can't be empty.";
        }
        else {
            title = @"Falto llenar el campo cedula.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.crearButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    
    if (valid)
    {
        if (!self.paci) {
            self.paci = [[MTEpaciente alloc] init];
        }
        self.paci.nombre = self.nombreText.text;
        self.paci.apellido = self.apellidoText.text;
        self.paci.cedula = self.cedulaText.text;
        self.paci.telefono = self.telefonoText.text;
        self.paci.direccion = self.direccionText.text;
        self.paci.email = self.emailText.text;
        NSString *day = self.dayText.text;
        NSString *month = self.monthText.text;
        NSString *year = self.yearText.text;
        NSString *birthdate = [NSString stringWithFormat:@"%@%@%@",year,month,day];
        NSString *entId = [self.entSeleccionada idEnt];
        if (self.crear == 1) {
            NSString *post = [NSString stringWithFormat:@"&id=%@&email=%@&fechaNacimiento=%@&nombre=%@&apellido=%@&telefono=%@&direccion=%@&idMedico=%@&idEntidad=%@",cedula,email,birthdate,nombre,apellido,telefono,direccion,self.memberID,entId];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/crearPaciente.php"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
            [request setHTTPBody:postData];
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
        }
        else if (self.crear == 0 || self.crear ==2)
        {
            NSString *post = [NSString stringWithFormat:@"&id=%@&email=%@&fechaNacimiento=%@&nombre=%@&apellido=%@&telefono=%@&direccion=%@&idMedico=%@&idEntidad=%@",cedula,email,birthdate,nombre,apellido,telefono,direccion,self.memberID,entId];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/actualizarPaciente.php"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
            [request setHTTPBody:postData];
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
        }
        
    }
    
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
    NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
    if ([dat isEqualToString:@"OK"])
    {
        if (self.crear == 1)
        {
            [[[MTEMedicalCenter sharedCenter] pacientes] addObject:self.paci];
            [self.ctvc reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(self.crear == 0)
        {
            self.paci.idEntidad = self.entSeleccionada.idEnt;
            [[[MTEMedicalCenter sharedCenter] pacientes] replaceObjectAtIndex:self.index.row
                                                                      withObject:self.paci];
            [self.ctvc reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(self.crear == 2)
        {
            self.paci.idEntidad = self.entSeleccionada.idEnt;
            for (int i = 0; [[[MTEMedicalCenter sharedCenter]pacientes]count]; i ++)
            {
                MTEpaciente *pac = [[[MTEMedicalCenter sharedCenter] pacientes] objectAtIndex:i];
                if ([pac.cedula isEqualToString:self.paci.cedula])
                {
                    [[[MTEMedicalCenter sharedCenter] pacientes] replaceObjectAtIndex:self.index.row
                                                                           withObject:self.paci];
                    break;
                }
            }
        }
        
    }
    self.crearButton.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.spinner stopAnimating];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [[self view] endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

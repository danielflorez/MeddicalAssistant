//
//  MTEiPadCrearConsultorioViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/15/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEiPadCrearConsultorioViewController.h"
#import "MTEMedicalCenter.h"

@interface MTEiPadCrearConsultorioViewController ()
@property (weak, nonatomic) IBOutlet UITextField *descText;
@property (weak, nonatomic) IBOutlet UITextField *direccionText;
@property (weak, nonatomic) IBOutlet UITextField *telefonoText;
@property (weak, nonatomic) IBOutlet UIButton *crearButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEiPadCrearConsultorioViewController

- (void)viewDidLoad
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    if (self.crear == 0)
    {
        self.descText.text = self.consultorio.descr;
        self.direccionText.text = self.consultorio.direccion;
        self.telefonoText.text = self.consultorio.telefono;
        [self.crearButton setTitle:@"Grabar" forState:UIControlStateNormal];
    }
    else if (self.crear == 1)
    {
         [self.crearButton setTitle:@"Crear" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *descr = self.descText.text;
    NSString *direc = self.direccionText.text;
    NSString *tel = self.telefonoText.text;
    if ([descr isEqualToString:@""])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The description field can't be empty.";
        }
        else {
            title = @"Falto llenar el campo descripcion.";
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
    if ([direc isEqualToString:@""])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The address field can't be empty.";
        }
        else {
            title = @"Falto llenar el campo direccion.";
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
    if ([tel isEqualToString:@""])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The phone field can't be empty.";
        }
        else {
            title = @"Falto llenar el campo telefono.";
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
        if (!self.consultorio) {
            self.consultorio = [[MTEconsultorio alloc] init];
        }
        self.consultorio.descr = descr;
        self.consultorio.direccion = direc;
        self.consultorio.telefono = tel;
        if (self.crear == 1) {
            NSString *post = [NSString stringWithFormat:@"&id=%@&desc=%@&direccion=%@&telefono=%@",self.memberID,descr,direc,tel];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/crearConsultorio.php"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
            [request setHTTPBody:postData];
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
        } else if (self.crear == 0)
        {
            NSString *post = [NSString stringWithFormat:@"&id=%@&desc=%@&direccion=%@&telefono=%@&idLoc=%@",self.memberID,descr,direc,tel,self.consultorio.idLoc];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/actualizarConsultorio.php"]]];
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
        if (self.crear == 1) {
            [[MTEMedicalCenter sharedCenter] loadiPadConsultorios:self.ctvc];
            [self.ctvc reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        } else if(self.crear == 0)
        {
            [[[MTEMedicalCenter sharedCenter] consultorios] replaceObjectAtIndex:self.index.row
                                                                      withObject:self.consultorio];
            [self.ctvc reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    self.crearButton.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
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
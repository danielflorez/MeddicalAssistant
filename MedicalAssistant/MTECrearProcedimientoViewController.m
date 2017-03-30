//
//  MTECrearProcedimientoViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTECrearProcedimientoViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEPreciosXEntidadCollectionViewController.h"

@interface MTECrearProcedimientoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nombreText;
@property (weak, nonatomic) IBOutlet UIButton *preciosButton;
@property (weak, nonatomic) IBOutlet UIButton *crearButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTECrearProcedimientoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.crear == 0) {
        self.nombreText.text = self.proc.nombre;
        [self.crearButton setTitle:@"Grabar" forState:UIControlStateNormal];
    }else if (self.crear == 1)
    {
        [self.crearButton setTitle:@"Crear" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)preciosClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEPreciosXEntidadCollectionViewController *ccvc = [storyboard instantiateViewControllerWithIdentifier:@"preciosCollection"];
    ccvc.proc = self.proc;
    ccvc.memberID = self.memberID;
    [self.navigationController pushViewController:ccvc
                                         animated:YES];
}

- (IBAction)crearClick:(id)sender
{
    self.crearButton.enabled = NO;
    self.preciosButton.enabled = NO;
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
    if (valid)
    {
        if (!self.proc) {
            self.proc = [[MTEprocedimiento alloc] init];
        }
        if (!self.dataRecieved) {
            self.dataRecieved = [[NSMutableData alloc] init];
        }
        self.proc.nombre = self.nombreText.text;
        if (self.crear == 1) {
            NSString *post = [NSString stringWithFormat:@"&id=%@&desc=%@",self.memberID,nombre];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSString *add = [NSString stringWithFormat:@"%@crearProcedimiento.php",[[MTEMedicalCenter sharedCenter] servicesAddres]];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", add]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
            [request setHTTPBody:postData];
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
        }
        else if (self.crear == 0)
        {
            NSString *post = [NSString stringWithFormat:@"&id=%@&desc=%@",self.proc.idProc,nombre];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSString *upd = [NSString stringWithFormat:@"%@actualizarProcedimiento.php",[[MTEMedicalCenter sharedCenter] servicesAddres]];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", upd]]];
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
            [[[MTEMedicalCenter sharedCenter] procedimientos] addObject:self.proc];
            [self.ptvc reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(self.crear == 0)
        {
            [[[MTEMedicalCenter sharedCenter] procedimientos] replaceObjectAtIndex:self.index.row
                                                                   withObject:self.proc];
            [self.ptvc reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    self.crearButton.enabled = YES;
    self.preciosButton.enabled = YES;
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

//
//  MTEHistoriaClinicaViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 2/17/15.
//  Copyright (c) 2015 Mangosta Tecnologia. All rights reserved.
//

#import "MTEHistoriaClinicaViewController.h"
#import "MTEMedicalCenter.h"
#import "MTECrearClienteViewController.h"

@interface MTEHistoriaClinicaViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIButton *grabarButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEHistoriaClinicaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 640)];
    if (self.antece)
    {
        self.patoTextField.text = self.antece.pat;
        self.farmaTextField.text = self.antece.far;
        self.taTextField.text = self.antece.ta;
        self.qxTextField.text = self.antece.qx;
        self.goTextField.text = self.antece.go;
        self.otrosTextField.text = self.antece.otros;
    }
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [[self view] endEditing:YES];
}

- (IBAction)grabarClick:(id)sender
{
    self.grabarButton.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:NO];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:NO];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:NO];
    [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:NO];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    NSMutableArray *entJson = [[NSMutableArray alloc] init];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    
    NSString *pato = self.patoTextField.text;
    NSString *farma = self.farmaTextField.text;
    NSString *toxi = self.taTextField.text;
    NSString *quiru = self.qxTextField.text;
    NSString *gine = self.goTextField.text;
    NSString *otros = self.otrosTextField.text;
    
    NSDictionary *entDic = [NSDictionary dictionaryWithObject:pato forKey:@"5"];
    [entJson addObject:entDic];
    entDic = [NSDictionary dictionaryWithObject:farma forKey:@"6"];
    [entJson addObject:entDic];
    entDic = [NSDictionary dictionaryWithObject:toxi forKey:@"7"];
    [entJson addObject:entDic];
    entDic = [NSDictionary dictionaryWithObject:quiru forKey:@"8"];
    [entJson addObject:entDic];
    entDic = [NSDictionary dictionaryWithObject:gine forKey:@"9"];
    [entJson addObject:entDic];
    entDic = [NSDictionary dictionaryWithObject:otros forKey:@"11"];
    [entJson addObject:entDic];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:entJson
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2
                                                 encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    MTECrearClienteViewController *ccvc = [self.tabBarController.viewControllers objectAtIndex:0];
    MTEpaciente *pac = ccvc.paci;
    if (pac)
    {
        NSString *post = [NSString stringWithFormat:@"&idPaciente=%@&entJson=%@",pac.cedula,jsonString];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSString *save = [NSString stringWithFormat:@"%@actualizarAntecedentesPaciente.php",[[MTEMedicalCenter sharedCenter] servicesAddres]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", save]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
    }
    else
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"You can't save the medical history if there is no paciente in this appointment.";
        }
        else {
            title = @"No hay un paciente en esta cita no se puede grabar los antecedentes.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:YES];
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:YES];
        [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:YES];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:YES];
        self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
        self.grabarButton.enabled = YES;
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
    if (![dat isEqualToString:@"OK"])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"There was an error saving the data.";
        }
        else {
            title = @"No fue posible grabar los antecedentes por favor intente nuevamente.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:YES];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
    self.grabarButton.enabled = YES;
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

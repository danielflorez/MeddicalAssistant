//
//  MTELoginViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 8/1/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTELoginViewController.h"
#import "MTERegisterViewController.h"
#import "MTEMainMenuViewController.h"
#import "MTEForgotPasswordViewController.h"
#import "MTEMedicalCenter.h"
@import JavaScriptCore;

@interface MTELoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTELoginViewController

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
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 40)];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 40)];
    self.userTextField.leftView = paddingView;
    self.userTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = paddingView1;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userTextField.text =[[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    UIImage *bg = [UIImage imageNamed:@"bg2.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 700)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)forgotClick:(id)sender {
    MTEForgotPasswordViewController *fpvc = [[MTEForgotPasswordViewController alloc] init];
    [self.navigationController pushViewController:fpvc
                                         animated:YES];
    
}

- (IBAction)registerClick:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTERegisterViewController *regis = [storyboard instantiateViewControllerWithIdentifier:@"iphoneRegister"];
    regis.lvc = self;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:regis animated:YES];
}

- (IBAction)loginButtonClicked:(id)sender {
    self.registerButton.enabled = NO;
    self.loginButton.enabled = NO;
    if (![self.passwordTextField.text isEqualToString:@""]) {
        if ([self NSStringIsValidEmail:self.userTextField.text]) {
            [[NSUserDefaults standardUserDefaults] setValue:self.userTextField.text forKey:@"Username"];
            [[NSUserDefaults standardUserDefaults]synchronize ];
            [self login:self.userTextField.text withPassword:self.passwordTextField.text];
        }else {
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *title;
            if([language isEqualToString:@"en"])
            {
                title = @"The user has to be an email.";
            }
            else {
                title = @"El usuario tiene que ser un email.";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.registerButton.enabled = YES;
            self.loginButton.enabled = YES;
        }
    }else{
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"Please type your password.";
        }
        else {
            title = @"Por favor ingresa tu contraseña.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.registerButton.enabled = YES;
        self.loginButton.enabled = YES;
    }
}

- (void) login:(NSString *)email withPassword:(NSString *)pass
{
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSURL *url = [NSURL URLWithString:@"http://www.mangostatecnologia.com/secureLogin/js/sha512.js"];
    NSError *err;
    NSString *scriptData = [NSString stringWithContentsOfURL:url
                                                    encoding:NSUTF8StringEncoding
                                                       error:&err];
    if (scriptData == nil) {
        scriptData = @"";
    }
    JSContext *scriptContext = [[JSContext alloc] init];
    [scriptContext evaluateScript:scriptData];
    JSValue *func = scriptContext[@"hex_sha512"];
    JSValue *result = [func callWithArguments:@[pass]];
    NSString *newText = [result toString];
    NSString *post = [NSString stringWithFormat:@"&email=%@&p=%@",email,newText];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/secureLogin/includes/process_login3.php"]]];
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
    NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
    
    if ([dat isEqualToString:@"OK"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        MTEMainMenuViewController *mmvc = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
        mmvc.email = self.userTextField.text;
        mmvc.lvc = self;
        [self.spinner stopAnimating];
        [self.navigationController pushViewController:mmvc animated:YES];
    }else if ([dat isEqualToString:@"ACT"])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"You haven't activated you account please follow the instructions that were sent to you in an email.";
        }
        else {
            title = @"Falta activar la cuenta, por favor sigue las instrucciones del email de activacion que se envio.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.spinner stopAnimating];
    }
    else {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"User or password is mistaken.";
        }
        else {
            title = @"Clave o usuario errados.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.spinner stopAnimating];
    }
    self.loginButton.enabled = YES;
    self.registerButton.enabled = YES;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [[self view] endEditing:YES];
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

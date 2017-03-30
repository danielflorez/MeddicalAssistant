//
//  MTEipadLoginViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 8/29/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEipadLoginViewController.h"
#import "MTEiPadRegisterViewController.h"
#import "MTEiPadMainMenuViewController.h"
@import JavaScriptCore;

@interface MTEipadLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEipadLoginViewController

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
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 49, 65)];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 49, 65)];
    self.emailTextField.leftView = paddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = paddingView1;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.text =[[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClick:(id)sender {
    self.registerButton.enabled = NO;
    self.loginButton.enabled = NO;
    if (![self.passwordTextField.text isEqualToString:@""]) {
        if ([self NSStringIsValidEmail:self.emailTextField.text]) {
            [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:@"Username"];
            [[NSUserDefaults standardUserDefaults]synchronize ];
            [self login:self.emailTextField.text withPassword:self.passwordTextField.text];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        MTEiPadMainMenuViewController *mmvc = [storyboard instantiateViewControllerWithIdentifier:@"ipadMainMenu"];
        mmvc.email = self.emailTextField.text;
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

- (IBAction)registerClick:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadRegisterViewController *regis = [storyboard instantiateViewControllerWithIdentifier:@"ipadRegister"];
    regis.lvc = self;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:regis animated:YES];
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

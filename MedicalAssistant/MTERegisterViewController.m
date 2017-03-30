//
//  MTERegisterViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 8/1/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTERegisterViewController.h"
@import JavaScriptCore;

@interface MTERegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cedulaTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *memberTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *acceptTermsButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@end

@implementation MTERegisterViewController

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
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 40)];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 40)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 40)];
    self.emailTextField.leftView = paddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = paddingView1;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPasswordTextField.leftView = paddingView2;
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addGestureRecognizer:tapRecognizer];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 880)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acceptTermsClick:(id)sender {
}

- (IBAction)registerClick:(id)sender {
    BOOL valid = YES;
    self.registerButton.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if ([self.nameTextField.text isEqualToString:@""])
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
        self.registerButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    if ([self.cedulaTextField.text isEqualToString:@""]) {
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
        self.registerButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    if ([self.lastNameTextField.text isEqualToString:@""]) {
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
        self.registerButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    if (![self.confirmPasswordTextField.text isEqualToString:self.passwordTextField.text]) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title1;
        if([language isEqualToString:@"en"])
        {
            title1 = @"The password and confirm password field are different.";
        }
        else {
            title1 = @"La clave y la confirmacion no son iguales.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title1
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.registerButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    if (![self NSStringIsValidEmail:self.emailTextField.text])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title2;
        if([language isEqualToString:@"en"])
        {
            title2 = @"The email is not valid.";
        }
        else {
            title2 = @"El correo no es valido.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title2
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.registerButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
//    if (!self.checked) {
//        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
//        NSString *title2;
//        if([language isEqualToString:@"en"])
//        {
//            title2 = @"You have to accept the terms and conditions.";
//        }
//        else {
//            title2 = @"Tienes que aceptar los terminos y condiciones.";
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:title2
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        valid = NO;
//        [self.spinner stopAnimating];
//        self.registerButton.enabled = YES;
//        self.navigationItem.leftBarButtonItem.enabled = YES;
//    }
    if (valid) {
        NSString *name = self.nameTextField.text;
        NSString *email = self.emailTextField.text;
        NSString *password = self.passwordTextField.text;
        NSString *cedula = self.cedulaTextField.text;
        NSString *apellido = self.lastNameTextField.text;
        NSString *telefono = self.phoneTextField.text;
        NSString *direccion = self.addressTextField.text;
        
        NSURL *url = [NSURL URLWithString:@"http://mangostatecnologia.com/secureLogin/js/sha512.js"];
        NSError *err;
        NSString *scriptData = [NSString stringWithContentsOfURL:url
                                                        encoding:NSUTF8StringEncoding
                                                           error:&err];
        if (scriptData == nil) {
            NSLog(@"Error loading scripts; %@", err);
            scriptData = @"";
        }
        JSContext *scriptContext = [[JSContext alloc] init];
        [scriptContext evaluateScript:scriptData];
        JSValue *func = scriptContext[@"hex_sha512"];
        JSValue *result = [func callWithArguments:@[password]];
        NSString *newText = [result toString];
        
        NSString *post = [NSString stringWithFormat:@"&id=%@&email=%@&p=%@&nombre=%@&apellido=%@&telefono=%@&direccion=%@",cedula,email,newText,name,apellido,telefono,direccion];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/secureLogin/includes/register.inc2_copy.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
    }
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [[self view] endEditing:YES];
}


-(void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [self.dataRecieved setLength:0];//Set your data to 0 to clear your buffer
}

-(void)connection:(NSURLConnection *)connection
   didReceiveData:(NSData *)data
{
    
    [self.dataRecieved appendData:data];//Append the download data..
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Use your downloaded data here
    NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
    if([dat isEqualToString:@"OK"])
    {
        //self.lvc.emailTextField.text = self.emailTextField.text;
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"To finish the register proccess follow the instructions in the activation email that was sent to you.";
        }
        else {
            title = @"Para terminar el proceso de registro sigue las instrucciones del email de activacion.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
    }
    self.registerButton.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.spinner stopAnimating];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

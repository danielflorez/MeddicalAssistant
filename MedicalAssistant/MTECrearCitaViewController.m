//
//  MTECrearCitaViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/30/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTECrearCitaViewController.h"
#import "MTEClientesTableViewController.h"
#import "MTECrearClienteViewController.h"
#import "MTEProcedimientosTableViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEresultadoCitaViewController.h"
#import "MTEHistoriaClinicaViewController.h"
#import "MTEantecedente.h"

@interface MTECrearCitaViewController ()
@property (weak, nonatomic) IBOutlet UITextField *descripcionText;
@property (weak, nonatomic) IBOutlet UIButton *selePacienteButton;
@property (weak, nonatomic) IBOutlet UIButton *seleProcedimientoBoton;
@property (weak, nonatomic) IBOutlet UILabel *horaText;
@property (weak, nonatomic) IBOutlet UILabel *minutoText;
@property (weak, nonatomic) IBOutlet UILabel *horaInicioText;
@property (weak, nonatomic) IBOutlet UILabel *minutoInicioText;
@property (weak, nonatomic) IBOutlet UIButton *subirButton;
@property (weak, nonatomic) IBOutlet UIButton *bajarButton;
@property (weak, nonatomic) IBOutlet UIButton *grabarButton;
@property (weak, nonatomic) IBOutlet UIButton *subirInicioButton;
@property (weak, nonatomic) IBOutlet UIButton *bajarInicioButton;
@property (weak, nonatomic) IBOutlet UIButton *resulButton;
@property int hour;
@property int minutes;
@property int finishHour;
@property int finishMinute;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) MTEcita *citaFinal;
@property int procConexion;
@property (nonatomic, strong) UITabBarController *tvc;

@end

@implementation MTECrearCitaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *currentDay = [formatter stringFromDate:self.day];
    [formatter setDateFormat:@"HH"];
    self.hour = [[formatter stringFromDate:self.day] intValue];
    [formatter setDateFormat:@"mm"];
    self.minutes = [[formatter stringFromDate:self.day] intValue];
    if (self.hour<10) {
        self.horaInicioText.text = [NSString stringWithFormat:@"0%d",self.hour];
    }
    else
    {
        self.horaInicioText.text = [NSString stringWithFormat:@"%d",self.hour];
    }
    if (self.minutes == 0)
    {
        self.minutoInicioText.text = [NSString stringWithFormat:@"0%d",self.minutes];
    }
    else
    {
        self.minutoInicioText.text = [NSString stringWithFormat:@"%d",self.minutes];
    }
    if (!self.cita)
    {
        if (self.minutes == 30)
        {
            self.finishHour = self.hour+1;
            self.finishMinute = 0;
        }
        else
        {
            self.finishHour = self.hour;
            self.finishMinute = 30;
        }
        if (self.finishHour < 10) {
            self.horaText.text = [NSString stringWithFormat:@"0%d",self.finishHour];
        }else{
            self.horaText.text = [NSString stringWithFormat:@"%d",self.finishHour];
        }
        if (self.finishMinute == 0) {
            self.minutoText.text = [NSString stringWithFormat:@"0%d",self.finishMinute];
        }else{
            self.minutoText.text = [NSString stringWithFormat:@"%d",self.finishMinute];
        }
    }
    [self.navigationItem setTitle:currentDay];
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.tvc = [storyboard instantiateViewControllerWithIdentifier:@"citaTab"];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.cita)
    {
        self.pac = self.cita.paci;
        if (!self.proc)
        {
            self.proc = self.cita.proc;
        }
        self.descripcionText.text = self.cita.desc;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateCita = [dateFormat dateFromString:self.cita.fechaFin];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        int hour = [[formatter stringFromDate:dateCita] intValue];
        [formatter setDateFormat:@"mm"];
        int minutes = [[formatter stringFromDate:dateCita] intValue];
        self.finishHour = hour;
        self.finishMinute = minutes;
        
        NSDate *dateInicioCita = [dateFormat dateFromString:self.cita.fechaInicio];
        [formatter setDateFormat:@"HH"];
        int hourFin = [[formatter stringFromDate:dateInicioCita] intValue];
        [formatter setDateFormat:@"mm"];
        int minutesFin = [[formatter stringFromDate:dateInicioCita] intValue];
        self.hour = hourFin;
        self.minutes = minutesFin;
        
        if (self.hour<10) {
            self.horaInicioText.text = [NSString stringWithFormat:@"0%d",self.hour];
        }
        else
        {
            self.horaInicioText.text = [NSString stringWithFormat:@"%d",self.hour];
        }
        if (self.minutes == 0)
        {
            self.minutoInicioText.text = [NSString stringWithFormat:@"0%d",self.minutes];
        }
        else
        {
            self.minutoInicioText.text = [NSString stringWithFormat:@"%d",self.minutes];
        }
        
        if (hour < 10) {
            self.horaText.text = [NSString stringWithFormat:@"0%d",hour];
        }
        else
        {
            self.horaText.text = [NSString stringWithFormat:@"%d",hour];
        }
        if (minutes == 0)
        {
            self.minutoText.text = [NSString stringWithFormat:@"0%d",minutes];
        }
        else
        {
            self.minutoText.text = [NSString stringWithFormat:@"%d",minutes];
        }
    }
    if (self.pac)
    {
        [self.selePacienteButton setTitle:[NSString stringWithFormat:@"%@ %@",[self.pac nombre],self.pac.apellido]
                                 forState:UIControlStateNormal];
    }
    if (self.proc)
    {
        [self.seleProcedimientoBoton setTitle:self.proc.nombre
                                     forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selePacienteClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEClientesTableViewController *ctvc = [storyboard instantiateViewControllerWithIdentifier:@"pacientesTVC"];
    ctvc.cita = true;
    ctvc.ccvc = self;
    ctvc.memberID = self.memberID;
    [self.navigationController pushViewController:ctvc
                                         animated:YES];
}

- (IBAction)seleProcedimientoClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEProcedimientosTableViewController *ptvc = [storyboard instantiateViewControllerWithIdentifier:@"procedimientosTVC"];
    ptvc.memberID = self.memberID;
    ptvc.cita = true;
    ptvc.ccvc = self;
    [self.navigationController pushViewController:ptvc
                                         animated:YES];
}

- (IBAction)subirClick:(id)sender
{
    if (self.finishMinute == 30)
    {
        self.finishHour++;
        self.finishMinute = 0;
    }
    else
    {
        self.finishMinute = 30;
    }
    if (self.finishHour < 10)
    {
        self.horaText.text = [NSString stringWithFormat:@"0%d",self.finishHour];
    }
    else
    {
        self.horaText.text = [NSString stringWithFormat:@"%d",self.finishHour];
    }
    if (self.finishMinute == 0)
    {
        self.minutoText.text = [NSString stringWithFormat:@"0%d",self.finishMinute];
    }
    else
    {
        self.minutoText.text = [NSString stringWithFormat:@"%d",self.finishMinute];
    }
    
}

- (IBAction)bajarClick:(id)sender
{
    BOOL valid = true;

    if (self.hour == self.finishHour)
    {
            valid = false;
    }
    else if(self.hour == self.finishHour-1)
    {
        if (self.minutes == 30)
        {
            if (self.finishMinute == 0)
            {
                valid = false;
            }
        }
    }
    if (valid)
    {
        if (self.finishMinute == 0)
        {
            self.finishHour--;
            self.finishMinute = 30;
        }else
        {
            self.finishMinute = 0;
        }
        if (self.finishHour < 10) {
            self.horaText.text = [NSString stringWithFormat:@"0%d",self.finishHour];
        }else{
            self.horaText.text = [NSString stringWithFormat:@"%d",self.finishHour];
        }
        if (self.finishMinute == 0) {
            self.minutoText.text = [NSString stringWithFormat:@"0%d",self.finishMinute];
        }else{
            self.minutoText.text = [NSString stringWithFormat:@"%d",self.finishMinute];
        }
    }
}

- (IBAction)subirInicioClick:(id)sender
{
    if (self.minutes == 30)
    {
        self.hour++;
        self.minutes = 0;
    }else
    {
        self.minutes = 30;
    }
    if (self.hour < 10)
    {
        self.horaInicioText.text = [NSString stringWithFormat:@"0%d",self.hour];
    }else
    {
        self.horaInicioText.text = [NSString stringWithFormat:@"%d",self.hour];
    }
    if (self.minutes == 0)
    {
        self.minutoInicioText.text = [NSString stringWithFormat:@"0%d",self.minutes];
    }else
    {
        self.minutoInicioText.text = [NSString stringWithFormat:@"%d",self.minutes];
    }
}

- (IBAction)bajarInicioClick:(id)sender
{
    BOOL valid = true;
    
    if ((self.hour == 6)&& (self.minutes == 0))
    {
        valid = false;
    }
    if (valid)
    {
        if (self.minutes == 0)
        {
            self.hour--;
            self.minutes = 30;
        }else
        {
            self.minutes = 0;
        }
        if (self.hour < 10)
        {
            self.horaInicioText.text = [NSString stringWithFormat:@"0%d",self.hour];
        }else
        {
            self.horaInicioText.text = [NSString stringWithFormat:@"%d",self.hour];
        }
        if (self.minutes == 0)
        {
            self.minutoInicioText.text = [NSString stringWithFormat:@"0%d",self.minutes];
        }
        else
        {
            self.minutoInicioText.text = [NSString stringWithFormat:@"%d",self.minutes];
        }
    }
}

- (IBAction)resultadoClick:(id)sender
{
    self.procConexion = 2;
    self.grabarButton.enabled = NO;
    self.selePacienteButton.enabled = NO;
    self.seleProcedimientoBoton.enabled = NO;
    self.resulButton.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (self.pac)
    {
        NSString *post = [NSString stringWithFormat:@"&idPaciente=%@",self.pac.cedula];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/getantecedentes.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        self.tvc = [storyboard instantiateViewControllerWithIdentifier:@"citaTab"];
        MTECrearClienteViewController *ccvc = [self.tvc.viewControllers objectAtIndex:0];
        ccvc.crear = 2;
        ccvc.paci = self.pac;
        [self.navigationController pushViewController:self.tvc
                                             animated:YES];
        //[self cargarControl];
    }
}

- (void)cargarControl
{
    self.procConexion = 3;
    if (self.cita) {
        NSString *post = [NSString stringWithFormat:@"&idPaciente=%@&idCita=%@",self.pac.cedula,self.cita.idCita];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/getAntecedentesXCita.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        self.tvc = [storyboard instantiateViewControllerWithIdentifier:@"citaTab"];
        MTECrearClienteViewController *ccvc = [self.tvc.viewControllers objectAtIndex:0];
        ccvc.crear = 2;
        ccvc.paci = self.pac;
        [self.navigationController pushViewController:self.tvc
                                             animated:YES];
    }
}

- (IBAction)grabarClick:(id)sender
{
    self.procConexion = 1;
    self.grabarButton.enabled = NO;
    self.selePacienteButton.enabled = NO;
    self.seleProcedimientoBoton.enabled = NO;
    self.resulButton.enabled = NO;
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
    NSString *desc = self.descripcionText.text;
    NSString *pacID;
    NSString *idEntidad;
    NSString *idProc;
    NSString *motiv = self.descripcionText.text;
    NSString *idCita;
    self.citaFinal = [[MTEcita alloc] init];
    if (self.pac)
    {
        pacID = self.pac.cedula;
        if (self.pac.idEntidad)
        {
            NSMutableArray *enti = [[MTEMedicalCenter sharedCenter] entidades];
            for (MTEEntidad *en in enti)
            {
                if ([en.idEnt isEqualToString:self.pac.idEntidad])
                {
                    self.citaFinal.enti = en;
                }
            }
        }
    }
    if (self.proc)
    {
        idProc = self.proc.idProc;
    }
    if (self.pac.idEntidad)
    {
        idEntidad = self.pac.idEntidad;
    }
    if (self.cita)
    {
        idCita = self.cita.idCita;
    }else
    {
        idCita = @"ND";
    }
    self.citaFinal.idCita = idCita;
    self.citaFinal.paci = self.pac;
    self.citaFinal.consul = self.consul;
    self.citaFinal.proc = self.proc;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [[NSDate alloc] init];
    date = self.day;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    NSString *h = self.horaText.text;
    NSString *m = self.minutoText.text;
    [components setHour:[h intValue]];
    [components setMinute:[m intValue]];
    NSDate *newDate = [gregorian dateFromComponents: components];
    NSString *endDate = [dateFormat stringFromDate:newDate];
    
    [components setHour:[self.horaInicioText.text intValue]];
    [components setMinute:[self.minutoInicioText.text intValue]];
    NSDate *beginNewDate = [gregorian dateFromComponents:components];
    NSString *beginDate = [dateFormat stringFromDate:beginNewDate];
    self.citaFinal.fechaInicio = beginDate;
    self.citaFinal.fechaFin = endDate;
    self.citaFinal.desc = motiv;
    NSDate *begin1 = [[NSDate alloc] init];
    NSDate *end1= [[NSDate alloc] init];
    NSDate *temp1 = [[NSDate alloc] init];
    NSDate *temp2 = [[NSDate alloc] init];
    for (MTEcita *c in self.adtvc.citas)
    {
        if (![idCita isEqualToString:c.idCita])
        {
            begin1 = [dateFormat dateFromString:c.fechaInicio];
            end1 = [dateFormat dateFromString:c.fechaFin];
            temp1 = [beginNewDate laterDate:begin1];
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *title;
            if ([temp1 isEqualToDate:beginNewDate]||[beginNewDate isEqualToDate:begin1])
            {
                temp2 = [beginNewDate earlierDate:end1];
                if ([temp2 isEqualToDate:beginNewDate]&&![beginNewDate isEqualToDate:end1])
                {
                    
                    if([language isEqualToString:@"en"])
                    {
                        title = @"The time of the appointing is overlaping with another appointing.";
                    }
                    else {
                        title = @"La hora de la cita se cruza con otra cita.";
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:title
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    valid = NO;
                    [self.spinner stopAnimating];
                    self.grabarButton.enabled = YES;
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                    break;
                }
            }
            temp1 = [newDate laterDate:begin1];
            if ([temp1 isEqualToDate:newDate]&&![newDate isEqualToDate:begin1])
            {
                temp2 = [newDate earlierDate:end1];
                if ([temp2 isEqualToDate:newDate]||[newDate isEqualToDate:end1])
                {
                    if([language isEqualToString:@"en"])
                    {
                        title = @"The time of the appointing is overlaping with another appointing.";
                    }
                    else
                    {
                        title = @"La hora de la cita se cruza con otra cita.";
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:title
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    valid = NO;
                    [self.spinner stopAnimating];
                    self.grabarButton.enabled = YES;
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                    break;
                }
            }
            temp1 = [beginNewDate earlierDate:begin1];
            if ([temp1 isEqualToDate:beginNewDate]||[beginNewDate isEqualToDate:begin1])
            {
                temp2 = [newDate laterDate:end1];
                if ([temp2 isEqualToDate:newDate]||[newDate isEqualToDate:end1])
                {
                    if([language isEqualToString:@"en"])
                    {
                        title = @"The time of the appointing is overlaping with another appointing.";
                    }
                    else
                    {
                        title = @"La hora de la cita se cruza con otra cita.";
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:title
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    valid = NO;
                    [self.spinner stopAnimating];
                    self.grabarButton.enabled = YES;
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                    break;
                }
            }
        }
    }
    
    if (!([desc isEqualToString:@""]||self.pac))
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
        self.grabarButton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    if (valid)
    {
        NSString *post = [NSString stringWithFormat:@"&id=%@&idPaciente=%@&idEntidad=%@&idMedico=%@&idLocacion=%@&idProc=%@&dateInicio=%@&dateFinal=%@&motivo=%@",idCita,pacID,idEntidad,self.memberID,self.consul.idLoc,idProc,beginDate,endDate,motiv];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/crearCita.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
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
    
    if (self.procConexion == 1)
    {
        NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
        if ([dat isEqualToString:@"OK"])
        {
            if (self.cita)
            {
                [self.adtvc updateCita:self.citaFinal];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.adtvc addCita:self.citaFinal];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
    else if(self.procConexion == 2)
    {
        NSDictionary *data= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                            options:0
                                                              error:nil];
        MTEHistoriaClinicaViewController *hcvc = [self.tvc.viewControllers objectAtIndex:1];
        NSString *idAntece;
        NSString *valAntece;
        MTEantecedente *ant = [[MTEantecedente alloc] init];
        for (NSDictionary *antecedentes in [data objectForKey:@"Antecedentes"])
        {
            idAntece = antecedentes[@"idAntecendente"];
            valAntece = antecedentes[@"Valor"];
            if ([idAntece isEqualToString:@"5"])
            {
                ant.pat = valAntece;
            }
            else if([idAntece isEqualToString:@"6"])
            {
                ant.far = valAntece;
            }
            else if ([idAntece isEqualToString:@"7"])
            {
                ant.ta = valAntece;
            }
            else if ([idAntece isEqualToString:@"8"])
            {
                ant.qx = valAntece;
            }
            else if ([idAntece isEqualToString:@"9"])
            {
                ant.go = valAntece;
            }
            else if ([idAntece isEqualToString:@"11"])
            {
                ant.otros = valAntece;
            }
            
        }
        hcvc.antece = ant;
        MTECrearClienteViewController *ccvc = [self.tvc.viewControllers objectAtIndex:0];
        ccvc.crear = 2;
        ccvc.paci = self.pac;
        UITabBarItem *tabBarItem0 =[[self.tvc.viewControllers objectAtIndex:0] tabBarItem];
        UITabBarItem *tabBarItem1 =[[self.tvc.viewControllers objectAtIndex:1] tabBarItem];
        UITabBarItem *tabBarItem2 =[[self.tvc.viewControllers objectAtIndex:2] tabBarItem];
        UITabBarItem *tabBarItem3 =[[self.tvc.viewControllers objectAtIndex:3] tabBarItem];
        UITabBarItem *tabBarItem4 =[[self.tvc.viewControllers objectAtIndex:4] tabBarItem];
        tabBarItem0.selectedImage =[[UIImage imageNamed:@"pacTab1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem0.image = [[UIImage imageNamed:@"pacTab2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem1.selectedImage =[[UIImage imageNamed:@"historiatab1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem1.image = [[UIImage imageNamed:@"historiatab2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem2.selectedImage =[[UIImage imageNamed:@"exa1tab1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem2.image = [[UIImage imageNamed:@"exa1tab2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem3.selectedImage =[[UIImage imageNamed:@"exa2tab1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem3.image = [[UIImage imageNamed:@"exa2tab2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem4.selectedImage =[[UIImage imageNamed:@"controltab1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem4.image = [[UIImage imageNamed:@"controltab2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.navigationController pushViewController:self.tvc
                                             animated:YES];
    }
    else if (self.procConexion == 3)
    {
        
        
        [self.navigationController pushViewController:self.tvc
                                             animated:YES];
    }
    self.grabarButton.enabled = YES;
    self.selePacienteButton.enabled = YES;
    self.seleProcedimientoBoton.enabled = YES;
    self.resulButton.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.spinner stopAnimating];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [[self view] endEditing:YES];
}
@end

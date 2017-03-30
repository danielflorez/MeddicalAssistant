//
//  MTEMedicalCenter.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/16/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEMedicalCenter.h"
#import "MTEdiagnostico.h"
#import "MTEmedicamento.h"

@interface MTEMedicalCenter()
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property int numData;
@end

@implementation MTEMedicalCenter


+ (MTEMedicalCenter *)sharedCenter
{
    static MTEMedicalCenter *center = nil;
    if (!center) {
        center = [[MTEMedicalCenter alloc] init];
    }
    return center;
}

-(void)loadData
{
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.consultorios) {
        self.consultorios = [[NSMutableArray alloc] init];
    }
    self.numData = 0;
    self.servicesAddres = @"http://www.mangostatecnologia.com/medicos_test/services/ws_version/";
    NSString *post = [NSString stringWithFormat:@"&idDoctor=%@",self.memberID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/consultorios.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)loadPacientes
{
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.pacientes) {
        self.pacientes = [[NSMutableArray alloc] init];
    }
    self.numData = 1;
    NSString *post = [NSString stringWithFormat:@"&idDoctor=%@",self.memberID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/pacientes.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)loadConsultorios:(MTEConsultoriosTableViewController *) ctvc
{
    self.ctvc = ctvc;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }if (!self.consultorios) {
        self.consultorios = [[NSMutableArray alloc] init];
    }
    self.numData = 2;
    NSString *post = [NSString stringWithFormat:@"&idDoctor=%@",self.memberID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/consultorios.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)loadiPadConsultorios:(MTEiPadConsultoriosTableViewController *) ictvc
{
    self.ictvc = ictvc;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.consultorios) {
        self.consultorios = [[NSMutableArray alloc] init];
    }
    self.numData = 3;
    NSString *post = [NSString stringWithFormat:@"&idDoctor=%@",self.memberID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/consultorios.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)loadEntidades
{
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.entidades) {
        self.entidades = [[NSMutableArray alloc] init];
    }
    self.numData = 4;
    NSString *post = [NSString stringWithFormat:@"&idDoctor=%@",self.memberID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/entidad.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)loadProcedimientos
{
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.procedimientos) {
        self.procedimientos = [[NSMutableArray alloc] init];
    }
    self.numData = 5;
    NSString *post = [NSString stringWithFormat:@"&idDoctor=%@",self.memberID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/procedimientos.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)loadPreciosProcedimientos
{
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.preciosProcedimientos) {
        self.preciosProcedimientos = [[NSMutableArray alloc] init];
    }
    self.numData = 6;
    NSString *post = [NSString stringWithFormat:@"&idDoctor=%@",self.memberID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/preciosXEntidad.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)loadPreciosProcedimientosSolo
{
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.preciosProcedimientos) {
        self.preciosProcedimientos = [[NSMutableArray alloc] init];
    }
    self.numData = 7;
    NSString *post = [NSString stringWithFormat:@"&idDoctor=%@",self.memberID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/preciosXEntidad.php"]]];
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
    
    NSDictionary *data= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                        options:0
                                                          error:nil];
    if (self.numData == 0)
    {
        self.consultorios = [[NSMutableArray alloc]init];
        for (NSDictionary *consultorio in [data objectForKey:@"Consultorios"]) {
            MTEconsultorio *con = [[MTEconsultorio alloc] init];
            con.idLoc = consultorio[@"idLoc"];
            con.descr = consultorio[@"nombre"];
            con.direccion = consultorio[@"direccion"];
            con.telefono = consultorio[@"telefono"];
            [self.consultorios addObject:con];
        }
        [self loadPacientes];
    }
    else if(self.numData ==1)
    {
        self.pacientes = [[NSMutableArray alloc] init];
        for (NSDictionary *paciente in [data objectForKey:@"Pacientes"])
        {
            MTEpaciente *pac = [[MTEpaciente alloc] init];
            pac.nombre = paciente[@"nombre"];
            pac.apellido = paciente[@"apellidos"];
            pac.fechaNacimiento = paciente[@"nacimiento"];
            pac.idEntidad = paciente[@"entidad"];
            pac.cedula = paciente[@"cedula"];
            pac.email = paciente[@"email"];
            pac.direccion = paciente[@"direccion"];
            pac.telefono = paciente[@"telefono"];
            [self.pacientes addObject:pac];
        }
        [self loadEntidades];
    }else if (self.numData == 2)
    {
        self.consultorios = [[NSMutableArray alloc]init];
        for (NSDictionary *consultorio in [data objectForKey:@"Consultorios"]) {
            MTEconsultorio *con = [[MTEconsultorio alloc] init];
            con.idLoc = consultorio[@"idLoc"];
            con.descr = consultorio[@"nombre"];
            con.direccion = consultorio[@"direccion"];
            con.telefono = consultorio[@"telefono"];
            [self.consultorios addObject:con];
            [self.ctvc reloadData];
        }
    }
    else if (self.numData == 3)
    {
        self.consultorios = [[NSMutableArray alloc]init];
        for (NSDictionary *consultorio in [data objectForKey:@"Consultorios"]) {
            MTEconsultorio *con = [[MTEconsultorio alloc] init];
            con.idLoc = consultorio[@"idLoc"];
            con.descr = consultorio[@"nombre"];
            con.direccion = consultorio[@"direccion"];
            con.telefono = consultorio[@"telefono"];
            [self.consultorios addObject:con];
            [self.ictvc reloadData];
        }
    }
    else if (self.numData == 4)
    {
        self.entidades = [[NSMutableArray alloc]init];
        for (NSDictionary *entidad in [data objectForKey:@"Entidades"])
        {
            MTEEntidad *ent = [[MTEEntidad alloc] init];
            ent.idEnt = entidad[@"id"];
            ent.codigo = entidad[@"codigo"];
            ent.nombre = entidad[@"nombre"];
            ent.idMedico = entidad[@"idMedico"];
            if (![ent.idMedico isEqual:[NSNull null]])
            {
                ent.check = TRUE;
            }
            [self.entidades addObject:ent];
        }
        [self loadProcedimientos];
    }
    else if (self.numData == 5)
    {
        self.procedimientos = [[NSMutableArray alloc]init];
        for (NSDictionary *procedimiento in [data objectForKey:@"Procedimientos"])
        {
            MTEprocedimiento *pro = [[MTEprocedimiento alloc] init];
            pro.idProc = procedimiento[@"id"];
            pro.nombre = procedimiento[@"nombre"];
            [self.procedimientos addObject:pro];
        }
        [self loadPreciosProcedimientos];
    }
    else if (self.numData == 6)
    {
        self.preciosProcedimientos = [[NSMutableArray alloc]init];
        for (NSDictionary *precio in [data objectForKey:@"Procedimientos"])
        {
            MTEprecioProcedimiento *pre = [[MTEprecioProcedimiento alloc] init];
            pre.idProc = precio[@"id"];
            pre.idEnt = precio[@"idEnt"];
            pre.precio = precio[@"precio"];
            [self.preciosProcedimientos addObject:pre];
        }
    }
    else if (self.numData == 7)
    {
        self.preciosProcedimientos = [[NSMutableArray alloc]init];
        for (NSDictionary *precio in [data objectForKey:@"Procedimientos"])
        {
            MTEprecioProcedimiento *pre = [[MTEprecioProcedimiento alloc] init];
            pre.idProc = precio[@"id"];
            pre.idEnt = precio[@"idEnt"];
            pre.precio = precio[@"precio"];
            [self.preciosProcedimientos addObject:pre];
        }
    }
}

- (void)loadDiagnosticos
{
    if (!self.diagnosticos)
    {
        self.diagnosticos = [[NSMutableArray alloc] init];
    }
    NSString *dataPath;
    dataPath = [[NSBundle mainBundle] pathForResource:@"diagnosticos" ofType:@"txt"];
    NSData *d = [NSData dataWithContentsOfFile:dataPath];
    NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:d
                                                         options:0
                                                           error:nil];
    for (NSDictionary *diagnostico in [dict objectForKey:@"Diagnosticos"])
    {
        MTEdiagnostico *d = [[MTEdiagnostico alloc] init];
        d.codigo = diagnostico[@"cod"];
        d.desc = diagnostico[@"desc"];
        [self.diagnosticos addObject:d];
    }
}


- (void)loadMedicamentos
{
    if (!self.medicamentos)
    {
        self.medicamentos = [[NSMutableArray alloc] init];
    }
    NSString *dataPath;
    dataPath = [[NSBundle mainBundle] pathForResource:@"medicamentos" ofType:@"txt"];
    NSData *d = [NSData dataWithContentsOfFile:dataPath];
    NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:d
                                                        options:0
                                                          error:nil];
    for (NSDictionary *medic in [dict objectForKey:@"Medicamentos"])
    {
        MTEmedicamento *m = [[MTEmedicamento alloc] init];
        m.codigo = medic[@"Codigo"];
        m.nombre = medic[@"Nombre"];
        m.compActivo = medic[@"DescAtc"];
        [self.medicamentos addObject:m];
    }
}

-(void)addPaciente:(MTEpaciente *)paciente
{
    [self.pacientes addObject:paciente];
}

-(void)addConsultorio:(MTEconsultorio *)consultorio
{
    [self.consultorios addObject:consultorio];
}
@end

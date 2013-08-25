//
//  ViewController.m
//  Jagt Almanak
//
//  Created by Mark Mortensen on 14/04/13.
//  Copyright (c) 2013 4FunAndProfit. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    //Location manager
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *postNr;
    
   
    
}

@end

@implementation ViewController

@synthesize countdownLabel, dateLabel, sunsetLabel, sunriseLabel, countDownTo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

  
    
    //Costum UISwitch getting initiated
    setAlarmSunrise = [[SunriseOnOff alloc] initWithFrame:CGRectMake(119, [[UIScreen mainScreen] bounds].size.height - 41, 93, 35)];
    //[setAlarmSunrise setOn:YES];
    [setAlarmSunrise addTarget:self action:@selector(changeSwitchSunrise:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:setAlarmSunrise];
    
    setAlarmSunset = [[SunsetOnOff alloc] initWithFrame:CGRectMake(219, [[UIScreen mainScreen] bounds].size.height - 41, 93, 35)];
    //[setAlarmSunset setOn:YES];
    [setAlarmSunset addTarget:self action:@selector(changeSwitchSunset:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:setAlarmSunset];

    
    /* MENU */
    
    UIImage *menuTUT = [UIImage imageNamed:@"menuTUT.png"];
    UIImage *menuSMS = [UIImage imageNamed:@"menuSMS.png"];
    UIImage *menuINFO = [UIImage imageNamed:@"menuINFO.png"];
    AwesomeMenuItem *information = [[AwesomeMenuItem alloc] initWithImage:menuINFO
                                                         highlightedImage:menuINFO
                                                             ContentImage:menuINFO
                                                  highlightedContentImage:nil];
    AwesomeMenuItem *sms = [[AwesomeMenuItem alloc] initWithImage:menuSMS
                                                           highlightedImage:menuSMS
                                                               ContentImage:menuSMS
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *tutorial = [[AwesomeMenuItem alloc] initWithImage:menuTUT
                                                           highlightedImage:menuTUT
                                                               ContentImage:menuTUT
                                                    highlightedContentImage:nil];
    
    // the start item, similar to "add" button of Path
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"menubg.png"]
                                                       highlightedImage:[UIImage imageNamed:@"menubg.png"]
                                                           ContentImage:[UIImage imageNamed:@"menuItem1.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"menuItem1.png"]];
        
    
    NSArray *menuOptions = [NSArray arrayWithObjects:information, sms, tutorial, nil];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.frame startItem:startItem optionMenus:menuOptions];
    
    menu.menuWholeAngle = M_PI / 180 * -90;
    menu.rotateAngle =   M_PI / 180 * 90;
    menu.startPoint = CGPointMake(26.0f, [[UIScreen mainScreen] bounds].size.height - 26);
    
    
    startItem.layer.shadowColor = [UIColor blackColor].CGColor;
    startItem.layer.shadowOpacity = 0.8;
    startItem.layer.shadowRadius = 3;
    startItem.layer.shadowOffset = CGSizeMake(-3.9f, 9.0f);
    menu.delegate = self;
    [self.view addSubview:menu];
    
        
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"Alle notifikationer: %@", scheduledNotifications);
    if (scheduledNotifications == nil){
        [setAlarmSunrise setOn:NO animated:YES];
    }
    else {
        
    }
    
    
   
    
   //Til at bestemme om UISwitch skal være on/off
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[aNotif.userInfo valueForKey:@"Morgen"] isEqualToString:@"iDagUdenAdvarsel"] ||
           [[aNotif.userInfo valueForKey:@"Morgen"] isEqualToString:@"iDagMedAdvarsel"] ||
           [[aNotif.userInfo valueForKey:@"Morgen"] isEqualToString:@"iMorgenUdenAdvarsel"] ||
           [[aNotif.userInfo valueForKey:@"Morgen"] isEqualToString:@"iMorgenMedAdvarsel"])
        {
            [setAlarmSunrise setOn:YES animated:YES];
            break;
        }
        else
        {
            [setAlarmSunrise setOn:NO animated:YES];
        }
    }
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[aNotif.userInfo valueForKey:@"Aften"] isEqualToString:@"iAftenUdenAdvarsel"] ||
           [[aNotif.userInfo valueForKey:@"Aften"] isEqualToString:@"iAftenMedAdvarsel"] ||
           [[aNotif.userInfo valueForKey:@"Aften"] isEqualToString:@"imorgenAftenUdenAdvarsel"] ||
           [[aNotif.userInfo valueForKey:@"Aften"] isEqualToString:@"imorgenAftenMedAdvarsel"])
    {
        [setAlarmSunset setOn:YES animated:YES];
        break;
    }
    else
    {
        [setAlarmSunset setOn:NO animated:YES];
    }
}






}

//Viser introduktionmenuen 1 gang
-(void)viewDidAppear:(BOOL)animated
{
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"Avalue"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"Avalue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    //STEP 1 Construct Panels
        MYIntroductionPanel *velkommen = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"velkommen"] title:@"Velkommen til Jagt Almanakken!" description:@"Denne app er beregnet til at gøre dit liv som jæger lidt nemmere! Hvis du ser denne besked, er det formentligt første gang, du bruger app'en, og vi vil derfor anbefale, at du læser denne tutorial helt færdig. Swipe til siden for at se hvad denne app kan! Denne besked vil selvfølgelig kun blive vist første gang, du besøger app'en. (Hvis app'en ved første opstart viser en besynderlig sol opgang, klik blot på SMS ikonet og tryk annuller, så skulle den være kallibreret.)"];
    
    //You may also add in a title for each panel
        MYIntroductionPanel *informationsMenu = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"infoMenu"] title:@"Info Menu" description:@"Øverst kan man se, hvor lang tid der er til solopgang/solnedgang. Nedenunder kan man se, hvad tid solen står op/går ned."];
        MYIntroductionPanel *infoMenuButtons = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"infobutton"] title:@"Info Menu Knapper" description:@"Knapper bruger du til at navigerer igennem dagene: '<' går en dag tilbage, 'X' går tilbage til idag, '>' går en dag fremad"];
        MYIntroductionPanel *alarmer = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"alarmer" ] title:@"Alarmer" description:@"Pil op (↑) sætter alarmen for den næste solopgang, imens pil ned (↓) sætter alarmen for den næste solnedgang"];
        
        
        MYIntroductionPanel *menu = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"menu"] title:@"Menu" description:@"Klikker man på '+' i venstre hjørne, åbner man menu. Herfra har man 3 muligheder: 'Tutorial' (øverst), 'SMS schweisshund' (midterste) eller 'Information' (nederste). De næste sider forklarer mere om de enkelte muligheder"];
        
        MYIntroductionPanel *menuTUT = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"menuTUT1"] title:@"Tutorial Menu" description:@"Denne knap vil vise denne tutorial endnu engang. Hvis der er noget, du skulle glemme, er dette stedet, du skal lede."];
        MYIntroductionPanel *menuSMS = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"menuSMS1"] title:@"SMS Menu" description:@"Denne knap vil åbne et lag henover appen, hvorfra du kan sende en SMS til en schweisshund. Alt er gjort klart automatisk, endda det postnr du er i baseret på dine koordinater"];
        MYIntroductionPanel *menuINFO = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"menuINFO1"] title:@"Info Menu" description:@"Denne menu vil vise dig dine koordinater, samt hvor meget dagen er tiltaget. Klik blot udenfor boksen for at komme tilbage."];
    
        MYIntroductionPanel *settings = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"settings"] title:@"Indstillinger" description:@"Inde i 'Indstillinger' skal du bladre ned, til du kommer til 'Jagt Almanak'. Klikker du på den, får du mulighed for at sætte indstillinger for, hvor mange min., inden solen går ned/står op, du gerne vil advares. Advarer selvfølgelig også om selve solopgang/solnedgang"];
        
        MYIntroductionPanel *husk = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"husk"] title:@"Husk!" description:@"For at app'en fungerer skal der være slået lokalitionstjenester til. Alarmen lyder ikke, hvis 'sleep mode' er sat til. Husk desuden at lade tiden være sat 'Indstil automatisk' 'Indstillinger' -> 'Generelt'->'Dato og tid' -> 'indstil automatisk' = on (hvis du skulle rode lidt rundt med tiden på din mobil, og nedtælleren opfører sig mærkeligt, så bare luk applikationen fuldstændigt og åbn den igen.)"];
          
    //STEP 2 Create IntroductionView
    
    /*A standard version*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
    
    
    /*A version with no header (ala "Path")*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2]];
    
    /*A more customized version*/
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"JAGT ALMANAK" panels:@[velkommen, informationsMenu, infoMenuButtons, alarmer, menu, menuTUT, menuSMS, menuINFO, settings, husk] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"tutbgnotext"]];
    
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view];
    }
    
    //Set some graphics for different stuff
    
    
    
    
        
    
    //Get device location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    
    
    //Add ons for SMS
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    geocoder = [[CLGeocoder alloc] init];
    
    [locationManager startUpdatingLocation];
    //Laver et dato object til senere brug.
    NSDate *date = [NSDate date];
    
    //Format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE 'd.' d MMMM, YYYY"];
    
    //Sæt den til dansk
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"]];
    
    //Create date string
    NSString *dateString = [dateFormat stringFromDate:date];
    
    //Sæt dato label
    dateLabel.text = dateString;
    
    //Laver et geolocation object defineret på koordinater og tidszone som skal bruges til at beregne vores solopgang/solnedgang
    GeoLocation *position = [[GeoLocation alloc] initWithName:@"position" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone defaultTimeZone]];
    
    AstronomicalCalendar *astronomicalCalender = [[AstronomicalCalendar alloc] initWithLocation:position];
    
    //Så laver vi et date object, til vores solopgang, der tager vores astronomicalCalender som parameter
    NSDate *sunriseDate = [astronomicalCalender sunrise];
    NSDateFormatter *sunriseTime = [[NSDateFormatter alloc] init];
    [sunriseTime setDateFormat:@"HH:mm:ss"];
    
    NSString *sunriseString = [sunriseTime stringFromDate:sunriseDate];
    
    sunriseLabel.text = sunriseString;
    
    //Et date object til vores solnedgang, samme parameter som sidst
    NSDate *sunsetDate = [astronomicalCalender sunset];
    NSDateFormatter *sunsetTime = [[NSDateFormatter alloc] init];
    [sunsetTime setDateFormat:@"HH:mm:ss"];
    
    NSString *sunsetString = [sunriseTime stringFromDate:sunsetDate];
    
    sunsetLabel.text = sunsetString;
    
    //Metode til at sætte UISwitch, der skal lige kigges på den her, da den har nogle andre indstillinger i den her version
    /*
     //Der skal kigges på den her imorgen.
     NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
     NSInteger myInt = [prefs integerForKey:@"isAlarmOnKey"];
     if (myInt == 1 || myInt == 2) {
     NSLog(@"Du har notifikationer");
     [setAlarm setOn:YES animated:YES];
     
     }
     else{
     NSLog(@"Du har ingen notifikationer");
     [setAlarm setOn:NO animated:YES];
     }
     */
    
    
    //Countdown metode
    
    cal = [NSCalendar currentCalendar];
    //NSLog(@"%@", cal);
    components = [[NSDateComponents alloc]init];
    //NSLog(@"%@", components);
    
    //Metode der finde rud af hvor lang tid der er til solnedgang (i sekunder)
    NSTimeInterval checkTimeSunset = [[astronomicalCalender sunset] timeIntervalSinceDate:[NSDate date]];
    
    // -//- solopgang (i sekunder)
    NSTimeInterval checkTimeSunrise = [[astronomicalCalender sunrise] timeIntervalSinceDate:[NSDate date]];
    
    
    
    
    
    
    
    //Vi skal have lavet en metode som gør kan beregne fra nu og så frem til midnat.
    NSDateComponents *secondMinuteHour = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate:date];
    [secondMinuteHour setHour:0];
    [secondMinuteHour setMinute:0];
    [secondMinuteHour setSecond:0];
    NSDate *midnight = [[NSCalendar currentCalendar] dateFromComponents:secondMinuteHour];
    NSDateComponents *diff = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:midnight toDate:date options:0];
    
    NSInteger numberOfsecondsPastMidnight = [diff second];
    
    //Så har vi fundet ud af hvor længe siden det sidst var midnat, derefter tager vi så det antal og trækker fra 24 timer (86400 sek)
    int secondsToMidnight = 86400 - numberOfsecondsPastMidnight;
    
    
    //Metode til at gå 1 dag frem i tiden
    GeoLocation *position2 = [[GeoLocation alloc] initWithName:@"position2" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
    AstronomicalCalendar *tomorrow = [[AstronomicalCalendar alloc] initWithLocation:position2];
    tomorrow.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*1];
    NSDate *sunriseTomorrow = [tomorrow sunrise];
    
    
    //Vi er nødt til at ligge 24 timer til vores sunrise
    NSTimeInterval checkTimeSunriseTomorrow = [sunriseTomorrow timeIntervalSinceDate:[NSDate date]];
    int checkTimeSunriseTomorrow1 = checkTimeSunriseTomorrow;
    int oneDayInSeconds = 86400 - secondsToMidnight;
    int tomorrowSunrise = checkTimeSunriseTomorrow + oneDayInSeconds;
    int hours = tomorrowSunrise / 3600;
    int minutes = (tomorrowSunrise % 3600) % 60;
    int seconds = (tomorrowSunrise % 3600) % 60;
    
    
    
    
    //Converter til en string så den kan bruges til countdown
    NSString *sunriseTomorrowString = [NSString stringWithFormat:@"%i:%i:%i", hours, minutes, seconds];
    
    //Her tager vi checkTimeSunriseTomorrow og laver om til en string som vi kan bruge til countdown
    
    if (checkTimeSunset >= 0 && checkTimeSunrise <= 0){
        //Her tæller vi så ned til solnedgang
        countDownTo.text = @"..Til solnedgang";
        NSArray *timeSplit = [sunsetString componentsSeparatedByString:@":"];
        NSUInteger hours = [[timeSplit objectAtIndex:0] intValue];
        NSUInteger minutes = [[timeSplit objectAtIndex:1] intValue];
        NSUInteger seconds = [[timeSplit objectAtIndex:2] intValue];
        NSDate *now = [NSDate date];
        NSDateComponents *dateComponents = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
        [dateComponents setHour:hours];
        [dateComponents setMinute:minutes];
        [dateComponents setSecond:seconds];
        
        if (!countdownTargetDay){
            countdownTargetDay = [cal dateFromComponents:dateComponents];
        }
        else {
            countdownTargetDay = nil;
            countdownTargetDay = [cal dateFromComponents:dateComponents];
        }
        
        if ([countdownTargetDay timeIntervalSinceNow] > 0){
            countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        }
        else{
            countdownTargetDay = nil;
            int nul = 0, nul1 = 0, nul2 = 0;
            NSString *output = [NSString stringWithFormat:@"%i:%i:%i", nul, nul1, nul2];
            countdownLabel.text = output;
            //Sæt UISwitch ON
            /*
             if (myInt != 2) {
             [prefs setInteger:0 forKey:@"isAlarmOnKey"];
             [setAlarm setOn:NO animated:YES];
             }
             */
            
        }
        
        
    }
    
    else if (checkTimeSunset <= 0){
        //Her tæller vi så op til solopgang, fra "now" til midnat
        countDownTo.text = @"..Til solopgang";
        NSLog(@"%@", sunriseTomorrowString);
        NSArray *timeSplit = [sunriseTomorrowString componentsSeparatedByString:@":"];
        NSUInteger hours = [[timeSplit objectAtIndex:0] intValue];
        NSUInteger minutes = [[timeSplit objectAtIndex:1] intValue];
        NSUInteger seconds = [[timeSplit objectAtIndex:2] intValue];
        NSDate *now = [NSDate date];
        NSDateComponents *dateComponents = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
        [dateComponents setHour:hours];
        [dateComponents setMinute:minutes];
        [dateComponents setSecond:seconds];
        
        if (!countdownTargetDay){
            countdownTargetDay = [cal dateFromComponents:dateComponents];
        }
        else {
            countdownTargetDay = nil;
            countdownTargetDay = [cal dateFromComponents:dateComponents];
        }
        
        if ([countdownTargetDay timeIntervalSinceNow] > 0){
            countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        }
        else{
            countdownTargetDay = nil;
            int nul = 0, nul1 = 0, nul2 = 0;
            NSString *output = [NSString stringWithFormat:@"%02i:%02i:%02i", nul, nul1, nul2];
            countdownLabel.text = output;
            //Sæt UISwitch ON
            /*
             if (myInt != 2) {
             [prefs setInteger:0 forKey:@"isAlarmOnKey"];
             [setAlarm setOn:NO animated:YES];
             }
             */
            
        }
    }
    
    else if (checkTimeSunset >= 0 && checkTimeSunrise >= 0){
        //Her tæller vi så ned fra efter midnat til solopgang
        countDownTo.text = @"..Til solopgang";
        NSArray *timeSplit = [sunriseString componentsSeparatedByString:@":"];
        NSUInteger hours = [[timeSplit objectAtIndex:0] intValue];
        NSUInteger minutes = [[timeSplit objectAtIndex:1] intValue];
        NSUInteger seconds = [[timeSplit objectAtIndex:2] intValue];
        NSDate *now = [NSDate date];
        NSDateComponents *dateComponents = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
        [dateComponents setHour:hours];
        [dateComponents setMinute:minutes];
        [dateComponents setSecond:seconds];
        
        if (!countdownTargetDay){
            countdownTargetDay = [cal dateFromComponents:dateComponents];
        }
        else {
            countdownTargetDay = nil;
            countdownTargetDay = [cal dateFromComponents:dateComponents];
        }
        
        if ([countdownTargetDay timeIntervalSinceNow] > 0){
            countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        }
        else{
            countdownTargetDay = nil;
            int nul = 0, nul1 = 0, nul2 = 0;
            NSString *output = [NSString stringWithFormat:@"%02i:%02i:%02i", nul, nul1, nul2];
            countdownLabel.text = output;
            //Sæt UISwitch ON
            /*
             if (myInt != 2) {
             [prefs setInteger:0 forKey:@"isAlarmOnKey"];
             [setAlarm setOn:NO animated:YES];
             }
             */
            
        }
        
        
    }
    
    //Her udskriver vi: Noget gik galt, så jeg kan se når jeg failer
    else {
        countDownTo.text = @"Noget gik galt!";
    }
    
    

  
    
}


-(void)tick
{
    if ([countdownTargetDay timeIntervalSinceNow] <= 0){
        int nul = 00, nul1 = 00, nul2 = 00;
        NSString *output = [NSString stringWithFormat:@"%02i:%02i:%02i", nul, nul1, nul2];
        countdownLabel.text = output;
        return;
    }
    components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date] toDate:countdownTargetDay options:0];
    
    NSInteger hour = [components hour];
    NSInteger minutes = [components minute];
    NSInteger seconds = [components second];
    
    
    NSString *output = [NSString stringWithFormat:@"%02i:%02i:%02i", hour, minutes, seconds];
    countdownLabel.text = output;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    if (idx == 0)
    {
        //Create the boundraies for the custom view
        CGRect popupViewFrame = CGRectMake(0, 0, 272, 332);
        
        //Create a subview of UIView called ImageView, initiates with an image and is set to the frame from past line
        UIImageView *myImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupbg.png"]];
        myImage.frame = popupViewFrame;
        
        //Creates the line seperating Longitude and lattitude
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(136, 45, 1, 135)];
        lineView.backgroundColor = [UIColor whiteColor];
        [myImage addSubview:lineView];
        
        
        //Creates the labels necessary and add them to the View
        UILabel *longitude = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 135, 30)];
        [longitude setTextColor:[UIColor whiteColor]];
        [longitude setBackgroundColor:[UIColor clearColor]];
        longitude.textAlignment = UITextAlignmentCenter;
        longitude.text = @"Længdegrad";
        [myImage addSubview:longitude];
        
        UILabel *lattitude = [[UILabel alloc] initWithFrame:CGRectMake(137, 40, 135, 30)];
        [lattitude setTextColor:[UIColor whiteColor]];
        [lattitude setBackgroundColor:[UIColor clearColor]];
        lattitude.textAlignment = UITextAlignmentCenter;
        lattitude.text = @"Breddegrad";
        [myImage addSubview:lattitude];
        
        UILabel *setLongitude = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 135, 30)];
        [setLongitude setTextColor:[UIColor whiteColor]];
        [setLongitude setBackgroundColor:[UIColor clearColor]];
        setLongitude.textAlignment = UITextAlignmentCenter;
        setLongitude.text = [self longitudeString];
        [myImage addSubview:setLongitude];
        
        UILabel *setLattitude = [[UILabel alloc] initWithFrame:CGRectMake(137, 70, 135, 30)];
        [setLattitude setTextColor:[UIColor whiteColor]];
        [setLattitude setBackgroundColor:[UIColor clearColor]];
        setLattitude.textAlignment = UITextAlignmentCenter;
        setLattitude.text = [self latitudeString];
        [myImage addSubview:setLattitude];
        
        //Creates 2 labels and set them based on time of year
        UILabel *dagensTiltag = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 272, 30)];
        [dagensTiltag setTextColor:[UIColor whiteColor]];
        [dagensTiltag setBackgroundColor:[UIColor clearColor]];
        dagensTiltag.textAlignment = UITextAlignmentCenter;
        
        UILabel *dagensLaengde = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, 272, 30)];
        [dagensLaengde setTextColor:[UIColor whiteColor]];
        [dagensLaengde setBackgroundColor:[UIColor clearColor]];
        dagensLaengde.textAlignment = UITextAlignmentCenter;
        //Set location og tidszone
        GeoLocation * hjem =[[GeoLocation alloc] initWithName:@"Test" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone defaultTimeZone]];
        
        AstronomicalCalendar *astronomicalCalendar = [[AstronomicalCalendar alloc] initWithLocation:hjem];
        
        
        /*Metode til sætte dagens længde */
        
        //Get sunset today
        NSDate *sunset = [astronomicalCalendar sunset];        
        
        astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*(-1)];
        
        NSDate *sunset2 = [astronomicalCalendar sunset];
        
        
        //Substract the 2 dates
        NSTimeInterval TiltagIAlt = [sunset timeIntervalSinceDate:sunset2];
        double dagensTiltag1 = TiltagIAlt - 86400;
        int forkort = dagensTiltag1;
        int minutes = forkort/60;
        int seconds = forkort - minutes * 60;
        
        int antalDage = 0;
        
        
       astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*0];
        
        if (forkort >= 0){
            dagensTiltag.text = @"Dagen er tiltaget med";
            //dagensLaengde.text = [NSString stringWithFormat:@"%02i:%02i min",minutes, seconds];
            
            //Metode til at finde ud af hvornår solhverv er:
            while (forkort > 0){
                antalDage++;
                //Lav den første dag
                NSDate *sunset11 = [astronomicalCalendar sunset];
                //NSLog(@" Sunset 11: %@", sunset11);
                
                //Ryk 1 dag tilbage
                
                astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*(-antalDage)];
                
                //Lav anden dag
                NSDate *sunset22 = [astronomicalCalendar sunset];
                //NSLog(@" Sunset 22: %@", sunset22);
                
                //Træk dem fra hinanden for at finde ud af om forkort > 0
                NSTimeInterval TiltagIAlt = [sunset11 timeIntervalSinceDate:sunset22];
                dagensTiltag1 = TiltagIAlt - 86400;
                forkort = dagensTiltag1;
                //NSLog(@"Forkort: %i", forkort);
                
                sunset11 = sunset22;
               // NSLog(@"Ny sunset11: %@", sunset11);
                
            }
            
            //Så regner vi ud hvor mange sekunder det er
            int antal = antalDage - 9;
            astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*0];
            
            NSDate *sunsetToday = [astronomicalCalendar sunset];
            NSDate *sunriseToday = [astronomicalCalendar sunrise];
            
            NSTimeInterval betweenSunriseNSunsetToday = [sunsetToday timeIntervalSinceDate:sunriseToday];
            
            astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*(-antal)];
            
            //NSLog(@"Antal sekunder fra solhverv til nu: %i", antalSekunder);
            
            NSDate *sunsetSolstice = [astronomicalCalendar sunset];
            
            NSDate *sunriseSolstice = [astronomicalCalendar sunrise];
            
            NSTimeInterval betweenSunriseNSunsetSolstice = [sunsetSolstice timeIntervalSinceDate:sunriseSolstice];
            
            
            
            //Så trækker vi så de to tidsintervaller fra hinanden
            int dagensTiltag = betweenSunriseNSunsetToday - betweenSunriseNSunsetSolstice;
            int timer = dagensTiltag/3600;
            int minutter = (dagensTiltag % 3600) / 60;
            int sekunder = dagensTiltag % 60;
                        
            dagensLaengde.text = [NSString stringWithFormat:@"%02i:%02i:%02i ",timer, minutter, sekunder];
        }
        
        else{
            dagensTiltag.text = @"Dagen er faldet med";
           
            while (forkort < 0){
                antalDage++;
                //Lav den første dag
                NSDate *sunset11 = [astronomicalCalendar sunset];
                //NSLog(@" Sunset 11: %@", sunset11);
                
                //Ryk 1 dag tilbage
                
                astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*(-antalDage)];
                
                //Lav anden dag
                NSDate *sunset22 = [astronomicalCalendar sunset];
                //NSLog(@" Sunset 22: %@", sunset22);
                
                //Træk dem fra hinanden for at finde ud af om forkort > 0
                NSTimeInterval TiltagIAlt = [sunset11 timeIntervalSinceDate:sunset22];
                dagensTiltag1 = TiltagIAlt - 86400;
                forkort = dagensTiltag1;
                //NSLog(@"Forkort: %i", forkort);
                
                sunset11 = sunset22;
                // NSLog(@"Ny sunset11: %@", sunset11);
                
            }
            
            int antal = antalDage + 3;

            astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*0];
            
            NSDate *sunsetToday = [astronomicalCalendar sunset];
            NSDate *sunriseToday = [astronomicalCalendar sunrise];
            
            NSTimeInterval betweenSunriseNSunsetToday = [sunsetToday timeIntervalSinceDate:sunriseToday];
            
            astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*(-antal)];
            
            //NSLog(@"Antal sekunder fra solhverv til nu: %i", antalSekunder);
            
            NSDate *sunsetSolstice = [astronomicalCalendar sunset];
            
            NSDate *sunriseSolstice = [astronomicalCalendar sunrise];
            
            
            NSTimeInterval betweenSunriseNSunsetSolstice = [sunsetSolstice timeIntervalSinceDate:sunriseSolstice];
            
            
            
            //Så trækker vi så de to tidsintervaller fra hinanden
            int dagensTiltag = betweenSunriseNSunsetSolstice - betweenSunriseNSunsetToday;
            int dagensTiltagPositiv = dagensTiltag;
            int timer = dagensTiltagPositiv/3600;
            int minutter = (dagensTiltagPositiv % 3600) / 60;
            int sekunder = dagensTiltagPositiv % 60;
            
            dagensLaengde.text = [NSString stringWithFormat:@"%02i:%02i:%02i ",timer, minutter, sekunder];
            
            /*
            
            //Metode til at konventerer negativt talt til positivt tal.
            int negativTiltag = -forkort - forkort;
            int negativTiltag1 = negativTiltag + forkort;
            int minutes1 = negativTiltag1/60;
            int seconds1 = negativTiltag1 - minutes1 * 60;
            
            
            
            dagensLaengde.text = [NSString stringWithFormat:@"%02i:%02i min",minutes1, seconds1];
            
            */
        }
        

        
        [myImage addSubview:dagensTiltag];
        [myImage addSubview:dagensLaengde];
        //Add the custom view to the viewcontroller
        [self.view addSubview:myImage];
        //Show the custom view nicely
        [ASDepthModalViewController presentView:myImage];
    }
    else if (idx == 1)
    {
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        
        if (messageClass != nil) {
            // Check whether the current device is configured for sending SMS messages
            if ([messageClass canSendText]) {
                [self displaySMSComposerSheet];
            }
            else {
                NSLog(@"Device not compitable with SMS");
                
            }
        }
        else {
            NSLog(@"Device could not send SMS");
        }
    }
    else if (idx == 2){
        MYIntroductionPanel *informationsMenu = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"infoMenu"] title:@"Info Menu" description:@"Øverst kan man se, hvor lang tid der er til solopgang/solnedgang. Nedenunder kan man se, hvad tid solen står op/går ned."];
        MYIntroductionPanel *infoMenuButtons = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"infobutton"] title:@"Info Menu Knapper" description:@"Knapper bruger du til at navigerer igennem dagene: '<' går en dag tilbage, 'X' går tilbage til idag, '>' går en dag fremad"];
        MYIntroductionPanel *alarmer = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"alarmer" ] title:@"Alarmer" description:@"Pil op (↑) sætter alarmen for den næste solopgang, imens pil ned (↓) sætter alarmen for den næste solnedgang"];
        
        
        MYIntroductionPanel *menu = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"menu"] title:@"Menu" description:@"Klikker man på '+' i venstre hjørne, åbner man menu. Herfra har man 3 muligheder: 'Tutorial' (øverst), 'SMS schweisshund' (midterste) eller 'Information' (nederste). De næste sider forklarer mere om de enkelte muligheder"];
        
        MYIntroductionPanel *menuTUT = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"menuTUT1"] title:@"Tutorial Menu" description:@"Denne knap vil vise denne tutorial endnu engang. Hvis der er noget, du skulle glemme, er dette stedet, du skal lede."];
        MYIntroductionPanel *menuSMS = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"menuSMS1"] title:@"SMS Menu" description:@"Denne knap vil åbne et lag henover appen, hvorfra du kan sende en SMS til en schweisshund. Alt er gjort klart automatisk, endda det postnr du er i baseret på dine koordinater"];
        MYIntroductionPanel *menuINFO = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"menuINFO1"] title:@"Info Menu" description:@"Denne menu vil vise dig dine koordinater, samt hvor meget dagen er tiltaget"];
        
        MYIntroductionPanel *settings = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"settings"] title:@"Indstillinger" description:@"Inde i 'Indstillinger' skal du bladre ned, til du kommer til 'Jagt Almanak'. Klikker du på den, får du mulighed for at sætte indstillinger for, hvor mange min., inden solen går ned/står op, du gerne vil advares. Advarer selvfølgelig også om selve solopgang/solnedgang"];
        
        MYIntroductionPanel *husk = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"husk"] title:@"Husk!" description:@"For at app'en fungerer skal der være slået lokalitionstjenester til. Alarmen lyder ikke, hvis 'sleep mode' er sat til. Husk desuden at lade tiden være sat 'Indstil automatisk' 'Indstillinger' -> 'Generelt'->'Dato og tid' -> 'indstil automatisk' = on (hvis du skulle rode lidt rundt med tiden på din mobil, og nedtælleren opfører sig mærkeligt, så bare luk applikationen fuldstændigt og åbn den igen.)"];
        
        /*A standard version*/
        //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
        
        
        /*A version with no header (ala "Path")*/
        //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2]];
        
        /*A more customized version*/
        MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"JAGT ALMANAK" panels:@[ informationsMenu, infoMenuButtons, alarmer, menu, menuTUT, menuSMS, menuINFO, settings, husk] languageDirection:MYLanguageDirectionLeftToRight];
        [introductionView setBackgroundImage:[UIImage imageNamed:@"tutbgnotext"]];
        
        
        //Set delegate to self for callbacks (optional)
        introductionView.delegate = self;
        
        //STEP 3: Show introduction view
        [introductionView showInView:self.view];

    }
    
}


//Koordinat metoder
- (NSString *)latitudeString {
    NSString *currentLatitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    return currentLatitude;
}

- (NSString *)longitudeString {
    NSString *currentLongitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    return currentLongitude;
}



#pragma mark - UISwitch knapper til at sætte alarm
-(void)changeSwitchSunset:(id)sender{
    if (setAlarmSunset.on) {
        NSTimeInterval checkTime = [[self sunset] timeIntervalSinceDate:[NSDate date]];
         NSLog(@"Tid til solnedgang %f", checkTime);
        if (checkTime > 0) {
            [self scheduleNotificationSunset];
        }
        else {
            [self scheduleNotificationSunsetTomorrow];
        }
    }
    else{
        UILocalNotification *notificationToCancel=nil;
        for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]){
            if([[aNotif.userInfo valueForKey:@"Aften"] isEqualToString:@"iAftenUdenAdvarsel"] ||
               [[aNotif.userInfo valueForKey:@"Aften"] isEqualToString:@"iAftenMedAdvarsel"] ||
               [[aNotif.userInfo valueForKey:@"Aften"] isEqualToString:@"imorgenAftenUdenAdvarsel"] ||
               [[aNotif.userInfo valueForKey:@"Aften"] isEqualToString:@"imorgenAftenMedAdvarsel"])
            {
                notificationToCancel=aNotif;
                [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
            }
        }
                
    }
}

- (void)changeSwitchSunrise:(id)sender{
    if (setAlarmSunrise.on) {
        NSTimeInterval checkTime = [[self sunrise] timeIntervalSinceDate:[NSDate date]];
        NSLog(@"Tid til solopgang %f", checkTime);
        if (checkTime > 0) {
            [self scheduleNotificationSunrise];
            NSLog(@"Sætter alarmen til solopgang idag");
        }
        else {
            [self scheduleNotificationSunriseTomorrow];
            NSLog(@"Sætter alarmen til solopgang imorgen");
        }
    }
    else{
        UILocalNotification *notificationToCancel=nil;
        for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if([[aNotif.userInfo valueForKey:@"Morgen"] isEqualToString:@"iDagUdenAdvarsel"] ||
               [[aNotif.userInfo valueForKey:@"Morgen"] isEqualToString:@"iDagMedAdvarsel"] ||
               [[aNotif.userInfo valueForKey:@"Morgen"] isEqualToString:@"iMorgenUdenAdvarsel"] ||
               [[aNotif.userInfo valueForKey:@"Morgen"] isEqualToString:@"iMorgenMedAdvarsel"])
            {
                notificationToCancel=aNotif;
                [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
                break;
            }
            
        }
    }

}

#pragma mark - Styr datoen knapper
-(IBAction)minusDay:(id)sender{
    day--;
    
    //Set location og tidszone
    GeoLocation * hjem =[[GeoLocation alloc] initWithName:@"Test" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
    
    AstronomicalCalendar *astronomicalCalendar = [[AstronomicalCalendar alloc] initWithLocation:hjem];
    
    astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*day];
    
    //Set sunrise
    
    NSDate *sunrise = [astronomicalCalendar sunrise];
    
    NSDateFormatter *sunriceTime = [[NSDateFormatter alloc]init];
    [sunriceTime setDateFormat:@"HH:mm:ss"];
    
    NSString *sunrice = [sunriceTime stringFromDate:sunrise];
    
    sunriseLabel.text = sunrice;
    
    //Set sunset
    NSDate *sunset = [astronomicalCalendar sunset];
    
    NSDateFormatter *sunsetTime = [[NSDateFormatter alloc]init];
    [sunsetTime setDateFormat:@"HH:mm:ss"];
    
    NSString *sunsetString = [sunsetTime stringFromDate:sunset];
    
    sunsetLabel.text = sunsetString;
    
    //Update labelTimeLeft UILabel to show name of day current viewing sunset and sunrise
    NSDate *date = [NSDate date];
    NSDate *newDate1 = [date dateByAddingTimeInterval:60*60*24*day];
    
    // format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE 'd.' d MMMM, YYYY "];
    
    // Set the locale as needed in the formatter (this example uses Japanese)
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"]];
    
    // Create date string from formatter, using the current date
    NSString *dateString = [dateFormat stringFromDate:newDate1];
    
    
    // Display the date string in format we set above
    NSLog(@"Date: %@:", dateString);
    
    
    // update a label’s text
    dateLabel.text = dateString;
}

-(IBAction)plusDay:(id)sender{
    //Tilføjer en ekstra dag hvergang knappen bliver trykket.
    day++;
    
    //Set location og tidszone
    GeoLocation * hjem =[[GeoLocation alloc] initWithName:@"Test" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
    
    AstronomicalCalendar *astronomicalCalendar = [[AstronomicalCalendar alloc] initWithLocation:hjem];
    
    astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*day];
    
    //Set sunrise
    
    NSDate *sunrise = [astronomicalCalendar sunrise];
    
    NSDateFormatter *sunriceTime = [[NSDateFormatter alloc]init];
    [sunriceTime setDateFormat:@"HH:mm:ss"];
    
    NSString *sunrice = [sunriceTime stringFromDate:sunrise];
    
    sunriseLabel.text = sunrice;
    
    //Set sunset
    NSDate *sunset = [astronomicalCalendar sunset];
    
    NSDateFormatter *sunsetTime = [[NSDateFormatter alloc]init];
    [sunsetTime setDateFormat:@"HH:mm:ss"];
    
    NSString *sunsetString = [sunsetTime stringFromDate:sunset];
    
    sunsetLabel.text = sunsetString;
    
    
    //Update labelTimeLeft UILabel to show name of day current viewing sunset and sunrise
    NSDate *date = [NSDate date];
    NSDate *newDate1 = [date dateByAddingTimeInterval:60*60*24*day];
    // format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE 'd.' d MMMM, YYYY "];
    
    // Set the locale as needed in the formatter (this example uses Japanese)
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"]];
    
    // Create date string from formatter, using the current date
    NSString *dateString = [dateFormat stringFromDate:newDate1];
    
    
    // Display the date string in format we set above
    NSLog(@"Date: %@:", dateString);
    
    
    // update a label’s text
    dateLabel.text = dateString;
    
}

-(IBAction)day:(id)sender{
    //Set location og tidszone
    GeoLocation * hjem =[[GeoLocation alloc] initWithName:@"Test" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
    
    AstronomicalCalendar *astronomicalCalendar = [[AstronomicalCalendar alloc] initWithLocation:hjem];
    
    
    //Set sunrise
    NSDate *sunrise = [astronomicalCalendar sunrise];
    
    NSDateFormatter *sunriceTime = [[NSDateFormatter alloc]init];
    [sunriceTime setDateFormat:@"HH:mm:ss"];
    
    NSString *sunrice = [sunriceTime stringFromDate:sunrise];
    
    sunriseLabel.text = sunrice;
    
    
    //Set sunset
    NSDate *sunset = [astronomicalCalendar sunset];
    
    NSDateFormatter *sunsetTime = [[NSDateFormatter alloc]init];
    [sunsetTime setDateFormat:@"HH:mm:ss"];
    
    NSString *sunsetString = [sunsetTime stringFromDate:sunset];
    
    sunsetLabel.text = sunsetString;
    
    //Update labelTimeLeft UILabel to show name of day current viewing sunset and sunrise
    NSDate *date = [NSDate date];
    
    // format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE 'd.' d MMMM, YYYY"];
    
    // Set the locale as needed in the formatter (this example uses Japanese)
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Da_DK"]];
    
    // Create date string from formatter, using the current date
    NSString *dateString = [dateFormat stringFromDate:date];
    
    
    // update a label’s text
    dateLabel.text = dateString;
    
    day = 0;
    
    
}

#pragma mark - Schedule Notification
-(NSDate *)sunrise {
    GeoLocation * currentLokation =[[GeoLocation alloc] initWithName:@"Test" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
    
    AstronomicalCalendar *astronomicalCalendar = [[AstronomicalCalendar alloc] initWithLocation:currentLokation];
    
    NSDate *sunrise = [astronomicalCalendar sunrise];
    return sunrise;
    
}

-(NSDate *)sunset {
    GeoLocation * currentLokation =[[GeoLocation alloc] initWithName:@"Test" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
    
    AstronomicalCalendar *astronomicalCalendar = [[AstronomicalCalendar alloc] initWithLocation:currentLokation];
    
    NSDate *sunset = [astronomicalCalendar sunset];
    return sunset;
}


//Method to schedule notification same day at sunset
-(void)scheduleNotificationSunset{
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        minutesUntilAlarm = [defaults integerForKey:@"antalMin"];
        NSLog(@"Alarmen skal ringe antal minutter inden solnedgang: %i", minutesUntilAlarm);
        
        //Udskriver sunrise for idag.
        [self sunset];
        
        //Der er ikke et krav om at ville advares x antal min inden solnedgang
        if (minutesUntilAlarm == 0) {
            UILocalNotification *notificationUdenAdvarsel = [[cls alloc] init];
            notificationUdenAdvarsel.fireDate = [self sunset];
            notificationUdenAdvarsel.timeZone = [NSTimeZone defaultTimeZone];
            notificationUdenAdvarsel.alertBody = @"Solen er nu officiel gået ned";
            notificationUdenAdvarsel.alertAction = @"OK";
            notificationUdenAdvarsel.soundName = @"rooster.caf";
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"iAftenUdenAdvarsel" forKey:@"Aften"];
            notificationUdenAdvarsel.userInfo = infoDict;
            [[UIApplication sharedApplication]scheduleLocalNotification:notificationUdenAdvarsel];
            
        }
        //Her vil der blive advaret både på solnedgang og x-antal min inden
        else{
            //Creates NSDictionary
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"iAftenMedAdvarsel" forKey:@"Aften"];
            
            UILocalNotification *notification1 = [[cls alloc] init];
            notification1.fireDate = [self sunset];
            notification1.timeZone = [NSTimeZone defaultTimeZone];
            notification1.alertBody = @"Solen er nu officiel gået ned";
            notification1.alertAction = @"OK";
            notification1.soundName = @"rooster.caf";
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *traekFraDag = [[NSDateComponents alloc] init];
            [traekFraDag setMinute:-minutesUntilAlarm];
            
            UILocalNotification *notification2 = [[cls alloc] init];
            notification2.fireDate = [gregorian dateByAddingComponents:traekFraDag toDate:[self sunset] options:0];
            notification2.timeZone = [NSTimeZone defaultTimeZone];
            notification2.alertBody = @"Nu går solen snart ned";
            notification2.alertAction = @"ok";
            notification2.soundName = @"rooster.caf";
            
            notification1.userInfo = infoDict;
            notification2.userInfo = infoDict;

            [[UIApplication sharedApplication] scheduleLocalNotification:notification1];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification2];
             
            
        }
    }
    
}

//Method to schedule notificaiton same day at sunrise
-(void)scheduleNotificationSunrise{
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        minutesUntilAlarm = [defaults integerForKey:@"antalMin"];
        
        //Udskriver sunrise for idag.
        [self sunrise];
        
        
        
        //Der er ikke et krav om at ville advares x antal min inden solnedgang
        if (minutesUntilAlarm == 0) {
            UILocalNotification *notification = [[cls alloc] init];
            notification.fireDate = [self sunrise];
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.alertBody = @"Solen er nu officiel stået op";
            notification.alertAction = @"OK";
            notification.soundName = @"rooster.caf";
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"iDagUdenAdvarsel" forKey:@"Morgen"];
            notification.userInfo = infoDict;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
        }
        //Her vil der blive advaret både på solnedgang og x-antal min inden
        else{
            //Creates NSDictionary
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"iDagMedAdvarsel" forKey:@"Morgen"];
            
            UILocalNotification *notification1 = [[cls alloc] init];
            notification1.fireDate = [self sunrise];
            notification1.timeZone = [NSTimeZone defaultTimeZone];
            notification1.alertBody = @"Solen er nu officiel stået op";
            notification1.alertAction = @"OK";
            notification1.soundName = @"rooster.caf";
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *traekFraDag = [[NSDateComponents alloc] init];
            [traekFraDag setMinute:-minutesUntilAlarm];
            
            UILocalNotification *notification2 = [[cls alloc] init];
            notification2.fireDate = [gregorian dateByAddingComponents:traekFraDag toDate:[self sunrise] options:0];
            notification2.timeZone = [NSTimeZone defaultTimeZone];
            notification2.alertBody = @"Nu står solen snart op";
            notification2.alertAction = @"ok";
            notification2.soundName = @"rooster.caf";
            
            notification1.userInfo = infoDict;
            notification2.userInfo = infoDict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification1];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification2];
            
            
        }
    }
    
}

//Method to schedule notificaiton next day at sunset
-(void)scheduleNotificationSunsetTomorrow{
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        minutesUntilAlarm = [defaults integerForKey:@"antalMin"];
        
        GeoLocation * currentLokation =[[GeoLocation alloc] initWithName:@"Test" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
        
        AstronomicalCalendar *astronomicalCalendar = [[AstronomicalCalendar alloc] initWithLocation:currentLokation];
		astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*(+1)];
        if (minutesUntilAlarm == 0){
            UILocalNotification *notificationUdenAdvarsel = [[cls alloc] init];
            notificationUdenAdvarsel.fireDate = [astronomicalCalendar sunset];
            notificationUdenAdvarsel.timeZone = [NSTimeZone defaultTimeZone];
            notificationUdenAdvarsel.alertBody = @"Solen er nu officielt gået ned";
            notificationUdenAdvarsel.alertAction = @"OK";
            notificationUdenAdvarsel.soundName = @"rooster.caf";
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"imorgenAftenUdenAdvarsel" forKey:@"Aften"];
            notificationUdenAdvarsel.userInfo = infoDict;
            [[UIApplication sharedApplication] scheduleLocalNotification:notificationUdenAdvarsel];
        }
        else{
            //Creates NSDictionary
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"imorgenAftenMedAdvarsel" forKey:@"Aften"];
            
            UILocalNotification *notification1 = [[cls alloc] init];
            notification1.fireDate = [astronomicalCalendar sunset];
            notification1.timeZone = [NSTimeZone defaultTimeZone];
            notification1.alertBody = @"Solen er nu officiel gået ned";
            notification1.alertAction = @"OK";
            notification1.soundName = @"rooster.caf";
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *traekFraDag = [[NSDateComponents alloc] init];
            [traekFraDag setMinute:-minutesUntilAlarm];
            
            UILocalNotification *notification2 = [[cls alloc] init];
            notification2.fireDate = [gregorian dateByAddingComponents:traekFraDag toDate:[astronomicalCalendar sunset] options:0];
            notification2.timeZone = [NSTimeZone defaultTimeZone];
            notification2.alertBody = @"Nu går solen snart ned";
            notification2.alertAction = @"ok";
            notification2.soundName = @"rooster.caf";
            
            
            notification1.userInfo = infoDict;
            notification2.userInfo = infoDict;
            
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification1];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification2];
            
            
        }
        
        
    }
    
}

//Method to schedule notificaiton next day at sunrise
-(void)scheduleNotificationSunriseTomorrow{
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        minutesUntilAlarm = [defaults integerForKey:@"antalMin"];
        
        GeoLocation * currentLokation =[[GeoLocation alloc] initWithName:@"Test" andLatitude:locationManager.location.coordinate.latitude andLongitude:locationManager.location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
        
        AstronomicalCalendar *astronomicalCalendar = [[AstronomicalCalendar alloc] initWithLocation:currentLokation];
		astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*(+1)];
        if (minutesUntilAlarm == 0){
            UILocalNotification *notification = [[cls alloc] init];
            notification.fireDate = [astronomicalCalendar sunrise];
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.alertBody = @"Solen er nu officiel stået op";
            notification.alertAction = @"OK";
            notification.soundName = @"rooster.caf";
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"iMorgenUdenAdvarsel" forKey:@"Morgen"];
            notification.userInfo = infoDict;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else{
            //Creates dictionary
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"iMorgenMedAdvarsel" forKey:@"Morgen"];
            
            UILocalNotification *notification1 = [[cls alloc] init];
            notification1.fireDate = [astronomicalCalendar sunrise];
            notification1.timeZone = [NSTimeZone defaultTimeZone];
            notification1.alertBody = @"Solen er nu officiel stået op";
            notification1.alertAction = @"OK";
            notification1.soundName = @"rooster.caf";
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *traekFraDag = [[NSDateComponents alloc] init];
            [traekFraDag setMinute:-minutesUntilAlarm];
            
            UILocalNotification *notification2 = [[cls alloc] init];
            notification2.fireDate = [gregorian dateByAddingComponents:traekFraDag toDate:[astronomicalCalendar sunrise] options:0];
            notification2.timeZone = [NSTimeZone defaultTimeZone];
            notification2.alertBody = @"Nu står solen snart op";
            notification2.alertAction = @"ok";
            notification2.soundName = @"rooster.caf";
            
            notification1.userInfo = infoDict;
            notification2.userInfo = infoDict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification1];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification2];
            
            
        }
        
        
    }

}


# pragma mark - SMS methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            postNr = [NSString stringWithFormat:@"%@",
                      placemark.postalCode];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

-(void)displaySMSComposerSheet
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.recipients = [NSArray arrayWithObjects:@"1220", nil];
    picker.body = [NSString stringWithFormat:@"Hund %@",  postNr];
	picker.messageComposeDelegate = self;
	
	[self presentModalViewController:picker animated:YES];
}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
			break;
		case MessageComposeResultSent:
			NSLog(@"Result: SMS sent");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Result: SMS sending failed");
			break;
		default:
			NSLog(@"Result: SMS not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


@end

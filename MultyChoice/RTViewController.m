//
//  RTViewController.m
//  MultyChoice
//
//  Created by Andriy on 9/5/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "RTViewController.h"


@interface RTViewController ()
{
    

    unsigned int rtAmount;
    Starter *createDB;
    NSNumber *indexMain;
    //-(IBAction)refreshTableView:(id)sender;
}

@end


@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-wallpaper.png"]];
    _myTableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.converter = [ParcingYahoo new];
    self.howMuch.text = @"1";                                                                         //the initial amount of currency-to-convert
    
    self.refreshControl = [[UIRefreshControl alloc] init];                                            //Initialize the refresh control.
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshTableView)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.myTableView addSubview:self.refreshControl];
    
    createDB = [Starter new];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]){                       //if the app has been already launched
        
        NSLog(@"DB isn't empty!");
        
        RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *error;
        NSFetchRequest *req = [NSFetchRequest new];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrencyInfo"
                                                      inManagedObjectContext:context];
        [req setEntity:entityDesc];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(checked == %@)", @1];                  //set the predicate to get only those items which are selected with checkmarks
        [req setPredicate:pred];                                                                       //implementing the above mentioned request

        
        NSArray *fetched = [context executeFetchRequest:req error:&error];
        rtAmount = [fetched count];                                                                    //count the number of mached elements (selected)
   } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];                 // OTHERWISE - if the app is launched for the first time
        [[NSUserDefaults standardUserDefaults] synchronize];
        [createDB firstLoad];
       
        NSLog(@"DB is filled");
         }
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.myTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    SelectionListViewController *controller = [[navigationController viewControllers] firstObject];
    controller.delegate = self;
   
    if ([segue.identifier isEqualToString:@"MainAdd"]){                                           // if the main currency is to be changed  (otherwise - the "+" button is pressed)
        
        controller.selectedMainSegue = YES;
	} else {
    
    controller.selectedCurrency = self.mainName.text;
    
    
  }
}

#pragma mark - UITableViewDataSource:

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger) section {
    
    return rtAmount;                                                                               //number of selected elements in the second table
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *req = [NSFetchRequest new];    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(checked == %@)", @1];                  //get only those elements wich are selected
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrencyInfo" inManagedObjectContext:context];
    
    [req setEntity:entityDesc];
    [req setPredicate:pred];
    
    NSArray *fetched = [context executeFetchRequest:req error:&error];
    CurrencyInfo *exemplair = fetched [indexPath.row];
    RTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleIdentifier];  //fill the tableView with data of selected currencies

    cell.nameLabel.text = exemplair.abbrev;
    cell.fullNameLabel.text = exemplair.fullName;
    cell.flagImageView.image = [UIImage imageNamed:exemplair.icon];
    
    NSFetchRequest *mainReq = [NSFetchRequest new];
    NSEntityDescription *mainRate = [NSEntityDescription entityForName:@"RateHistory"
                                                inManagedObjectContext:context];
    [mainReq setEntity:mainRate];
    
    NSArray *mainFetched = [context executeFetchRequest:mainReq error:&error];
    RateHistory *mainCurrency = [mainFetched lastObject];
    CurrencyCalculation * calculation = [CurrencyCalculation new];
    createDB = [Starter new];
    
    double resultRate = [ calculation convertNumber:self.howMuch.text
                                         OfCurrency:[mainCurrency
                                        valueForKey:[self.mainName.text lowercaseString]]
                                               into:[mainCurrency
                                                     valueForKey:[exemplair.abbrev lowercaseString]]];     //implement the calculation of enetered amount of the first currency into the target currencies
    
    cell.sumLabel.text = [NSString stringWithFormat: @"%.4f", resultRate];                                 //output the result of converter

        
       return cell;
}


#pragma mark - AddCurrencyDelegate:

- (void) setMainCurrency:(unsigned int) indexTableRow                                                      //change the currency to be converted into the target ones
{
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *req = [NSFetchRequest new];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrencyInfo" inManagedObjectContext:context];
    
    [req setEntity:entityDesc];
    
    NSArray *fetched = [context executeFetchRequest:req error:&error];
    indexMain = [NSNumber numberWithInt:indexTableRow];
    unsigned index = indexTableRow;                                                //detecting the row of selected item to become the main currency
    
    CurrencyInfo *exemplair = fetched[index];
    if ([exemplair.checked isEqualToNumber:@1]) {exemplair.checked = nil;
        rtAmount -=1;
    
    }
    self.mainName.text = exemplair.abbrev;                                                                  //output the changed data
    self.mainFullName.text = exemplair.fullName;
    self.mainImage.image = [UIImage imageNamed:exemplair.icon];
    
    [context save:&error];
 }


- (void) setSelectedCurrency: (unsigned int)amount                                                           //pass the number of selected items from the second view
{
    rtAmount = amount;
}

- (void) backgroundRefresh:(void (^)(UIBackgroundFetchResult))completionHanler
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    ParsingSynchronous *newParse = [ParsingSynchronous new];
    result = [newParse synchroniousConvert];                                                                 //retrieving the data by synchronous request
    completionHanler(UIBackgroundFetchResultNewData);
    WorkWithDB *medium = [WorkWithDB new];
    RateHistory *exemplair2 = [medium the_same_func];                                                        //implementing the objects amount violation control
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strMyDate= [dateFormatter stringFromDate:now];
    NSString *lastSaveString = [dateFormatter stringFromDate:exemplair2.date];
    
    if([strMyDate isEqualToString:lastSaveString])                                                            //check whether there is already updates for the current date
    {                                                                                                         //        ||
                                  NSLog(@"IF used");                                                          //        \/
       [RateHistory rewriteEntityObject:result :exemplair2];                                                  // if there is - rewrite the last Entity object
                                  NSLog(@"rewritten object --->>> from background fetch");                    //        ||
    }else {                                                                                                   //        \/
       [RateHistory newEntityObject:result];                                                                  // otherwise - create new (add) Entity object
                                  NSLog(@"new bject  --->>>  from background fetch");
    }
    [self.myTableView reloadData];
}


- (IBAction)endEditing:(id)sender                                                                              // hiding the keyboard
{
   [sender resignFirstResponder];
   [self.myTableView reloadData];
}


- (IBAction)refreshTableView                                                                       //downloading fresh data on exchange rate from yahoo and loading it to DB MANUALLY
{
    
    WorkWithDB *dbSample = [WorkWithDB new];
    [dbSample DBCheckWithBlock:^(NSString* success){
        if([success isEqualToString:@"Yes!"])
            [self.refreshControl endRefreshing];
            [self.myTableView reloadData];
        
    }];
        NSLog(@"End parSing!!!");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        rtAmount -= 1;
        RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *error;
        NSFetchRequest *req = [NSFetchRequest new];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(checked == %@)", @1];                  //get only those elements wich are selected
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrencyInfo" inManagedObjectContext:context];
        
        [req setEntity:entityDesc];
        [req setPredicate:pred];
        
        NSArray *fetched = [context executeFetchRequest:req error:&error];
        CurrencyInfo *exemplair = fetched [indexPath.row];
        
        exemplair.checked = nil;
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } 
}

@end

//
//  RTViewController.m
//  MultyChoice
//
//  Created by Andriy on 9/5/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () {

  unsigned int amountOfSelectedCurrencies;
  double quantity;
  int dots;
  NSMutableArray *arrayOfSelectedCurrencies;
  DataBaseManager *dataBaseManager;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"HasLaunchedOnce"]) { // if the app has been already
                                            // launched
    [[NSUserDefaults standardUserDefaults]
        setBool:YES
         forKey:@"HasLaunchedOnce"]; // OTHERWISE - if the app is launched for
                                     // the first time
    [[NSUserDefaults standardUserDefaults] synchronize];
    [DataBaseManager startWorkWithCurrencyRateAplication];
  //  NSLog(@"DB is filled");

    self.mainName.text = @"UAH"; // output the changed data
    self.mainFullName.text = @"Ukrainian Hryvnia";
    self.mainImage.image = [UIImage imageNamed:@"UAH.png"];
  }

  arrayOfSelectedCurrencies = [[NSMutableArray alloc] init];
  dataBaseManager = [DataBaseManager sharedManager];
  NSInteger indexMain =
      [[NSUserDefaults standardUserDefaults] integerForKey:@"mainCurrency"];
  CurrencyInfo *mainCurrencySaved = [dataBaseManager.fetchedArrayOfCurrencyInfo
      objectAtIndex:indexMain]; // getting saved main currency from array
  self.mainName.text = mainCurrencySaved.abbrev; // output the changed data
  self.mainFullName.text = mainCurrencySaved.fullName;
  self.mainImage.image = [UIImage imageNamed:mainCurrencySaved.icon];
  self.view.backgroundColor = [UIColor
      colorWithPatternImage:[UIImage imageNamed:@"wood-wallpaper.png"]];
  _myTableView.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.titleTextAttributes =
      @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  self.howMuch.text = @"1"; // the initial amount of currency-to-convert

  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(refreshTheMainTableView)
                forControlEvents:UIControlEventValueChanged];
  [self.myTableView
      addSubview:self.refreshControl]; // Initialize the refresh control.

  UIToolbar *numberToolbar =
      [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)]; // start
                                                                   // custom
                                                                   // keyboard
                                                                   // code
                                                                   // IHOR!!!!!!
  numberToolbar.barStyle = UIBarStyleBlackTranslucent;
  numberToolbar.items = [NSArray
      arrayWithObjects:
          [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                           style:UIBarButtonItemStyleBordered
                                          target:self
                                          action:@selector(cancelNumberPad)],
          [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                   target:nil
                                   action:nil],
          [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                           style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(doneWithNumberPad)],
          nil];
  [numberToolbar sizeToFit];
  _howMuch.inputAccessoryView = numberToolbar;
  self.howMuch.delegate = self;

  [self.howMuch addTarget:self.howMuch
                   action:@selector(checkTyping)
         forControlEvents:UIControlEventEditingChanged];
  _howMuch.clearsOnBeginEditing = YES;
    _howMuch.dots=0;
}


- (void)cancelNumberPad { // cancel button
  _howMuch.text = @"1";
    _howMuch.dots=0;
    quantity = [_howMuch.text doubleValue];
  quantity = [_howMuch.text doubleValue];
  [_howMuch resignFirstResponder];
  [self.myTableView reloadData];
}

- (void)doneWithNumberPad { // done button
  quantity = [_howMuch.text doubleValue];
    if ([_howMuch.text hasSuffix: @"."]) {
       _howMuch.text = [_howMuch.text substringToIndex:[_howMuch.text length]-1 ];
     }
    quantity = [_howMuch.text doubleValue];
    _howMuch.dots=0;
  [_howMuch resignFirstResponder];
  [self.myTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
  [arrayOfSelectedCurrencies removeAllObjects];

  for (CurrencyInfo *inf in dataBaseManager.fetchedArrayOfCurrencyInfo) {
    if (inf.checked) {
      [arrayOfSelectedCurrencies addObject:inf];
    }
  }

  [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UINavigationController *navigationController =
      segue.destinationViewController;
  SelectionListViewController *controller =
      [[navigationController viewControllers] firstObject];
  controller.delegate = self;

  if ([segue.identifier isEqualToString:@"MainAdd"]) { // if the main currency
                                                       // is to be changed
                                                       // (otherwise - the "+"
                                                       // button is pressed)

    controller.selectedMainSegue = YES;
  } else {

    controller.selectedCurrency = self.mainName.text;
  }
}

#pragma mark - UITableViewDataSource:

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return [arrayOfSelectedCurrencies count]; // number of selected elements in
                                            // the second table
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
  //    NSManagedObjectContext *context = [appDelegate managedObjectContext];
  //    NSError *error;
  //
  //    NSFetchRequest *mainReq = [NSFetchRequest new];
  //    NSEntityDescription *mainRate = [NSEntityDescription
  //    entityForName:@"RateHistory"
  //                                                inManagedObjectContext:context];
  //    [mainReq setEntity:mainRate];
  //    NSArray *fetchArrayForRateHistory = [context executeFetchRequest:mainReq
  //    error:&error];
  //_fetchedRateHis = [NSMutableArray arrayWithArray:fetchArrayForRateHistory];
  //    RateHistory *tempCurrencyRate = [fetchArrayForRateHistory firstObject];

  static NSString *SimpleIdentifier = @"SimpleIdentifier";
  CurrencyInfo *tempCurrency =
      [arrayOfSelectedCurrencies objectAtIndex:indexPath.row];
  TableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
  cell.nameLabel.text = tempCurrency.abbrev;
  cell.fullNameLabel.text = tempCurrency.fullName;
  cell.flagImageView.image = [UIImage imageNamed:tempCurrency.icon];
  RateHistory *tempCurrencyRate =
      [dataBaseManager.fetchedRateHistory firstObject];
  CurrencyCalculation *calculation = [CurrencyCalculation new];

  double resultRate = [calculation
      convertNumber:[_howMuch.text doubleValue]
         OfCurrency:[tempCurrencyRate
                        valueForKey:[self.mainName.text lowercaseString]]
               into:[tempCurrencyRate
                        valueForKey:[tempCurrency.abbrev
                                            lowercaseString]]]; // implement the
                                                                // calculation
                                                                // of enetered
                                                                // amount of the
                                                                // first
                                                                // currency into
                                                                // the target
                                                                // currencies

  cell.sumLabel.text = [NSString
      stringWithFormat:@"%.3f", resultRate]; // output the result of converter

  return cell;
}

#pragma mark - AddCurrencyDelegate:

- (void)
    setMainCurrency:(unsigned int)
    indexTableRow // change the currency to be converted into the target ones
{
  if (_mainSaved) {
    _mainSaved2 = _mainSaved;
  }

  CurrencyInfo *exemplair =
      [dataBaseManager.fetchedArrayOfCurrencyInfo objectAtIndex:indexTableRow];
  for (CurrencyInfo *temp in dataBaseManager.fetchedArrayOfCurrencyInfo) {
    if (temp.abbrev == _mainSaved2.abbrev) {
      if (temp.checked != [NSNumber numberWithInt:1]) {
        temp.checked = @1;
        [arrayOfSelectedCurrencies addObject:temp];
      }
    }
    if (temp.abbrev == exemplair.abbrev) {
      temp.checked = nil;
    }
  }

  self.mainName.text = exemplair.abbrev; // output the changed data
  self.mainFullName.text = exemplair.fullName;
  self.mainImage.image = [UIImage imageNamed:exemplair.icon];
  _mainSaved = exemplair;
  UILabel *label = self.mainName;
  [self shakeAnimation:label];

  //[self rotateImage:self.mainImage duration:10.0
  // curve:UIViewAnimationCurveEaseIn degrees:180];
  [[NSUserDefaults standardUserDefaults] setInteger:indexTableRow
                                             forKey:@"mainCurrency"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)refreshTheMainTableView // downloading fresh data on exchange rate from
                                // yahoo and loading it to DB MANUALLY
{
  [ManualRefresh refreshTableViewWithCompletionHandler:^(NSString *success) {
      if ([success isEqualToString:@"Yes!"])
        [self.refreshControl endRefreshing];
      [self.myTableView reloadData];
  }];
  //NSLog(@"End parSing!!!");
}

- (void)shakeAnimation:(UILabel *)label {
  CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
  [shake setDuration:1.1];
  [shake setRepeatCount:30];
  [shake setAutoreverses:YES];
  [shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(label.center.x - 5,
                                                            label.center.y)]];
  [shake setToValue:[NSValue valueWithCGPoint:CGPointMake(label.center.x + 5,
                                                          label.center.y)]];
  [label.layer addAnimation:shake forKey:@"position"];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {

    CurrencyInfo *exemplair =
        [arrayOfSelectedCurrencies objectAtIndex:indexPath.row];

    exemplair.checked = nil;
    [arrayOfSelectedCurrencies removeObjectAtIndex:indexPath.row]; // Delete the
                                                                   // row from
                                                                   // the data
                                                                   // source
    [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

@end

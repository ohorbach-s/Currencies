#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionListViewController.h"

NSString * const backgroundImage = @"wood-wallpaper.png";
NSString * const cellIdentifier = @"SimpleIdentifier";

static NSString *mainCurrencyKey = @"mainCurrency";
static NSString *mainSegueIdentifier = @"MainAdd";
static NSString *addSegueIdentifier = @"Add";


@interface MainViewController () {
    DataBaseManager *dataBaseManager;
}
@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeApplicationMoreStylish];
    if (![AppLaunchDefaultManager checkApplicationLaunch]) {
        [self firstLoadOfApplication];
    } else {
        dataBaseManager = [DataBaseManager sharedManager];
        dataBaseManager.mainCurrencySaved = [[dataBaseManager.fetchedRateHistory firstObject] mainCurrencySaved];
        [self setTheMainCurrency:dataBaseManager.mainCurrencySaved];
    }
    //RateHistory *tempRate = [dataBaseManager.fetchedRateHistory firstObject];
    [self linkToTextField];
    self.currencyAmount.clearsOnBeginEditing = YES;
    [self createTableViewSwipeDownRefresh];
    self.shownIndexes = [NSMutableSet set];
    [self setObservingForMainCurrencyAndCheckmarks];
}
- (void)reloadTable {
    [self.myTableView reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.currencyAmount customButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [AnimationFile animateTableViewAppearance:self.myTableView];
    [dataBaseManager.selectedCurrencies removeAllObjects];
    for (CurrencyInfo* temp in dataBaseManager.arrayOfAllCurrencyInfo) {
        if ((temp.checked) && (![temp isEqual:dataBaseManager.mainCurrencySaved])) {
            [dataBaseManager.selectedCurrencies addObject:temp];
        }
    }
    [self.myTableView reloadData];     ////  ???
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    UINavigationController* navigationController = segue.destinationViewController;
    SelectionListViewController* controller = [[navigationController viewControllers] firstObject];
   // controller.delegate = self;
    if ([segue.identifier isEqualToString:mainSegueIdentifier]) {
        controller.selectedMainSegue = YES;
    }
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [dataBaseManager.selectedCurrencies count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    CurrencyInfo* tempCurrency =
    [dataBaseManager.selectedCurrencies objectAtIndex:indexPath.row];
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.nameLabel.text = tempCurrency.abbrev;
    cell.fullNameLabel.text = tempCurrency.fullName;
    cell.flagImageView.image = [UIImage imageNamed:tempCurrency.icon];
    RateHistory* tempCurrencyRate =
    [dataBaseManager.fetchedRateHistory firstObject];
  //  tempCurrencyRate.mainCurrencySaved = tempCurrency;
    CurrencyCalculation* calculation = [CurrencyCalculation new];
    double inputAmount = [self.currencyAmount.text doubleValue];
    NSString *mainAbbrev = [tempCurrencyRate
                            valueForKey:[self.mainName.text lowercaseString]];
    NSString *curr = [tempCurrencyRate
                      valueForKey:[tempCurrency.abbrev
                                   lowercaseString]];
    double resultRate = [calculation
                         convertNumber:inputAmount
                         OfCurrency:mainAbbrev
                         into:curr];
    cell.sumLabel.text = [NSString stringWithFormat:@"%.3f", resultRate];
    return cell;
}

// change the currency to be converted into the target ones
//- (void)receiveMainCurrencyFromSelectionTable:(CurrencyInfo*)selectedMain {
//    
//    CurrencyInfo* temp = dataBaseManager.mainCurrencySaved;
//    for (CurrencyInfo* inf in dataBaseManager.arrayOfAllCurrencyInfo) {
//        if ([inf isEqual:temp]){
//            inf.isMainCurrency = nil;
//        }
//    }
//    [self setTheMainCurrency:selectedMain];
//    [self.view addSubview:self.mainImage];                                       //add animation for main currency
//    [AnimationFile addFallAnimationForLayer:self.mainImage.layer];
//    [self.view addSubview:self.mainFullName];
//    [AnimationFile addFallAnimationForLayer:self.mainFullName.layer];
//    dataBaseManager.mainCurrencySaved = selectedMain;
//}

- (void)refreshTheMainTableView {
    [RefreshData refreshTableViewWithCompletionHandler:^(BOOL success) {
        if (success){
            [self.refreshControl endRefreshing];
        }
        [self.myTableView reloadData];
    }];
}

- (void)tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CurrencyInfo *exemplair = [dataBaseManager.selectedCurrencies objectAtIndex:indexPath.row];
        exemplair.checked = nil;
        [dataBaseManager.selectedCurrencies removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
    }
}

-(void) setTheMainCurrency: (CurrencyInfo *)main {
    self.mainName.text = main.abbrev;
    self.mainFullName.text = main.fullName;
    self.mainImage.image = [UIImage imageNamed:main.icon];
}

-(void)firstLoadOfApplication {
    [AppLaunchDefaultManager rememberAboutApplicationLaunchWithKey];
    [DataBaseManager startWorkWithCurrencyRateAplication];
       
            dataBaseManager = [DataBaseManager sharedManager];
            dataBaseManager.mainCurrencySaved = [dataBaseManager.arrayOfAllCurrencyInfo firstObject];
            //dataBaseManager.mainCurrencySaved.isMainCurrency = @(YES);
            [self  setTheMainCurrency:dataBaseManager.mainCurrencySaved];
            [self.myTableView reloadData];
        

}

-(void) makeApplicationMoreStylish {
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor] };
}

-(void)createTableViewSwipeDownRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTheMainTableView)
                  forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];
}

-(void) linkToTextField {
    self.currencyAmount.text = @"1";
    self.currencyAmount.reloadDelegate = self;
    [self.currencyAmount addTarget:self.currencyAmount
                            action:@selector(checkTyping)
                  forControlEvents:UIControlEventEditingChanged];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"mainCurrencySaved"]) {
        self.mainName.text = dataBaseManager.mainCurrencySaved.abbrev;
        self.mainFullName.text = dataBaseManager.mainCurrencySaved.fullName;
        self.mainImage.image = [UIImage imageNamed:dataBaseManager.mainCurrencySaved.icon];
        
        [self.view addSubview:self.mainImage];                                       //add animation for main currency
        [AnimationFile addFallAnimationForLayer:self.mainImage.layer];
        [self.view addSubview:self.mainFullName];
        [AnimationFile addFallAnimationForLayer:self.mainFullName.layer];
    }
    
}

-(void)setObservingForMainCurrencyAndCheckmarks {
    [dataBaseManager addObserver:self forKeyPath:@"mainCurrencySaved" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

@end

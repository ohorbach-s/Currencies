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
        [self setTheMainCurrency:[[dataBaseManager.fetchedRateHistory firstObject] mainCurrencySaved]];
    }
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
        if ((temp.checked) && (![temp isEqual:[[dataBaseManager.fetchedRateHistory firstObject] mainCurrencySaved]])) {
            [dataBaseManager.selectedCurrencies addObject:temp];
        }
    }
    [self.myTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    //UINavigationController* navigationController = segue.destinationViewController;
    
    SelectionListViewController* controller = segue.destinationViewController;    //[[navigationController viewControllers] firstObject];
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
    CurrencyCalculation* calculation = [CurrencyCalculation new];
    double resultRate = [calculation
                         convertNumber:[self.currencyAmount.text doubleValue]
                         OfCurrency:[tempCurrencyRate valueForKey:[self.mainName.text lowercaseString]]
                         into:[tempCurrencyRate valueForKey:[tempCurrency.abbrev lowercaseString]]];
    cell.sumLabel.text = [NSString stringWithFormat:@"%.3f", resultRate];
    return cell;
    //  }
}

- (void)refreshTheMainTableView {
    [RefreshData refreshTableViewWithCompletionHandler:^(BOOL success) {
        if (success){
            [self.myTableView reloadData];
        }
        
        [self.refreshControl endRefreshing];
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
    [[dataBaseManager.fetchedRateHistory firstObject] setMainCurrencySaved:[dataBaseManager.arrayOfAllCurrencyInfo firstObject]];
    [self  setTheMainCurrency:[[dataBaseManager.fetchedRateHistory firstObject] mainCurrencySaved]];
}

-(void) makeApplicationMoreStylish {
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"mainCurrencySaved"]) {
        self.mainName.text =  [object mainCurrencySaved].abbrev;
        self.mainFullName.text = [object mainCurrencySaved].fullName;
        self.mainImage.image = [UIImage imageNamed:[object mainCurrencySaved].icon];
        [self.view addSubview:self.mainImage];
        [AnimationFile addFallAnimationForLayer:self.mainImage.layer];
        [self.view addSubview:self.mainFullName];
        [AnimationFile addFallAnimationForLayer:self.mainFullName.layer];
        
        //        if ([dataBaseManager.selectedCurrencies containsObject:[object mainCurrencySaved]]) {
        //
        //        }
    }
    //    if ([keyPath isEqualToString:@"checked"]) {
    //        NSNumber *newCheck = [change objectForKey:NSKeyValueChangeNewKey];
    //        if (([newCheck  isEqual: @(YES)])&&(![object isEqual
    //                                          :[[dataBaseManager.fetchedRateHistory firstObject] mainCurrencySaved]])) {
    //            [dataBaseManager.selectedCurrencies addObject:object];
    //        } else {
    //            [dataBaseManager.selectedCurrencies removeObject:object];
    //        }
    //    }
}

-(void)setObservingForMainCurrencyAndCheckmarks {
    [[dataBaseManager.fetchedRateHistory firstObject]addObserver:self
                                                      forKeyPath:@"mainCurrencySaved"
                                                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //    for (CurrencyInfo *temp in dataBaseManager.arrayOfAllCurrencyInfo ) {
    //        [temp addObserver:self forKeyPath:@"checked"
    //                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //    }
}

@end

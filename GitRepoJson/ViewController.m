//
//  ViewController.m
//  GitRepoJson
//
//  Created by Tyler Boudreau on 2018-04-26.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "Repo.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableVIew;
@property (strong,nonatomic)NSMutableArray *myBigArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myBigArray = [NSMutableArray new];
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/TheBestBoudreau/repos"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSArray *repos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        for (NSDictionary *repo in repos) {
                NSString *repoName = repo[@"name"];
                NSLog(@"repo: %@", repoName);
                Repo *arepo =[Repo new];
                arepo.RepoName=repoName;
            [self.myBigArray addObject:arepo];
            //DO NOT PUT ARRAYS IN FOR LOOPS
            
        }
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          [self.myTableVIew reloadData];
               }];
    }];
    
    [dataTask resume];
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myBigArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Repos";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Repo *myRepo =[Repo new];
    TableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cellid" forIndexPath:indexPath];
    myRepo =[self.myBigArray objectAtIndex:indexPath.row];
    cell.MyHeader.text=myRepo.RepoName;
    
    return cell;
}

@end

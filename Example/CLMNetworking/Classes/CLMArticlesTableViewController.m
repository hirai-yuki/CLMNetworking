//
//  CLMArticlesTableViewController.m
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import "CLMArticlesTableViewController.h"
#import "CLMArticleListPresenter.h"
#import "CLMArticle.h"

@interface CLMArticlesTableViewController () <CLMArticleListViewProtocol>

@property (nonatomic) CLMArticleListPresenter *articleListPresenter;
@property (nonatomic) NSArray *articles;


@end

@implementation CLMArticlesTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.articleListPresenter = [CLMArticleListPresenter presenterWithView:self];
    [self.articleListPresenter viewDidLoad];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];

    CLMArticle *article = self.articles[indexPath.row];
    
    cell.textLabel.text = article.title;
    cell.detailTextLabel.text = article.content;
    
    return cell;
}

#pragma mark - <CLMArticleListViewProtocol>

- (void)displayArticles:(NSArray *)articles {
    self.articles = articles;
    [self.tableView reloadData];
}

@end

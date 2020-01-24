import UIKit
class EverythingViewController: UITableViewController {
    //MARK:- Variables
    var pageSize = 15
    var fetchingMore = false
    var articles :[EverythingCached] = []
    var newsProvider : NewsProvider?
    // Realm database for caching
    let realmOps = RealmOps()
    // Pull to refresh implementation
    let myRefreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    @objc private func refresh (sender: UIRefreshControl)  {
        newsProvider?.generateEverything(givenPageSize: pageSize)
        sender.endRefreshing()
    }
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        articles = realmOps.readEverything()
        NotificationCenter.default.addObserver(self, selector: #selector(received(notif:)), name: Constants.everythingNotificationName, object: nil)
        newsProvider = NewsProvider()
        newsProvider?.generateEverything(givenPageSize: pageSize)
        tableView.refreshControl = myRefreshControl
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let saveArticle = saveArticleAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [saveArticle])
    }
    
    func saveArticleAction (at IndexPath: IndexPath) -> UIContextualAction {
        let article = articles[IndexPath.row]
        let action = UIContextualAction(style: .normal, title: "Save") { (action, view, completion) in
            self.tableView.cellForRow(at: IndexPath)?.backgroundColor = .systemBlue
            self.realmOps.saveEverythingToBookmark(article: article)
            self.sendNotification()
        }
        action.image = UIImage(systemName: "bookmark")
        action.backgroundColor = .systemBlue
        return action
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "everythingCellIdentifier", for: indexPath) as! EverythingNewsCell
        
        let article = articles[indexPath.row]
        if article.urlToImage != "" {
            if let unwrappedURL = URL(string: article.urlToImage) {
                newsProvider?.downloadImage(url: unwrappedURL, completion: { image in
                    cell.everythingImageView.image = image
                })
            }
        }
        cell.everythingTitleLabel.text = article.title
        return cell
    }
    // Sending notification that article is saved
    private func sendNotification() {
        NotificationCenter.default.post(name: Constants.savedNotificationName, object: nil, userInfo: nil)
        print("article saved")
    }
    
    //MARK:- Pagination implementation
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if contentHeight != 0.0 {
            if offsetY > contentHeight - scrollView.frame.height {
                if !fetchingMore {
                    beginBatchFetch()
                    print("batch fetch")
                }
            }
        }
    }
    func beginBatchFetch () {
        fetchingMore = true
        pageSize += 15
        newsProvider?.generateEverything(givenPageSize: pageSize)
    }
    
    //observer
    @objc func received(notif: Notification) {
        if articles.count == 0 {
            articles = realmOps.readEverything()
            tableView.reloadData()
        } else if articles.count > 0 {
            fetchingMore = false
            if realmOps.readEverything() == articles {
                print("news are the same")
            }
            else {
                articles = realmOps.readEverything()
                tableView.reloadData()
            }
        }
    }
    // segue to detailed view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailEverything" else {return}
        if let articleDetail = segue.destination as? EverythingDetailsViewController {
            if let cell = sender as? EverythingNewsCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let article = articles[indexPath.row]
                    articleDetail.articleDetail = article
                }
            }
        }
    }
}

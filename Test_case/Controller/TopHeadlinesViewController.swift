import UIKit
class TopHeadlinesViewController: UITableViewController {
    //MARK:- Variables
    var pageSize = 15
    var fetchingMore = false
    var articles :[ArticleCached] = []
    var newsProvider : NewsProvider?
    // Realm database for caching
    let realmOps = RealmOps()
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // looking for cached data
        articles = realmOps.readData()
        // observer for new data
        NotificationCenter.default.addObserver(self, selector: #selector(received(notif:)), name: Constants.notificationName, object: nil)
        newsProvider = NewsProvider()
        newsProvider?.generateArticles(givenPageSize: pageSize)
        // setting up timer
        newsProvider?.reloadTimer(timerPageSize : pageSize)
    }
    // MARK:- Table view data source metods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellIdentifier", for: indexPath) as! NewsCell
        let article = articles[indexPath.row]
        if article.urlToImage != ""  {
            if let unwrappedURL = URL(string: article.urlToImage) {
                newsProvider?.downloadImage(url: unwrappedURL, completion: { image in
                    cell.newsImageView.image = image
                })
            }
        }
        cell.titleField.text = article.title
        return cell
    }
    //MARK:-Table view delegate metods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let saveArticle = saveArticleAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [saveArticle])
    }
    // Swipe cell to save article
    func saveArticleAction (at IndexPath: IndexPath) -> UIContextualAction {
        let article = articles[IndexPath.row]
        let action = UIContextualAction(style: .normal, title: "Save") { (action, view, completion) in
            self.tableView.cellForRow(at: IndexPath)?.backgroundColor = .systemBlue
            self.realmOps.saveArticle(article: article)
            self.sendNotification()
        }
        action.image = UIImage(systemName: "bookmark")
        action.backgroundColor = .systemBlue
        return action
    }
    
    private func sendNotification() {
        NotificationCenter.default.post(name: Constants.savedNotificationName, object: nil, userInfo: nil)
        print("article saved")
    }
    
    //MARK:- Pagination implementation
    
    //begin fetching new elements when at the bottom of tableView
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
        newsProvider?.reloadTimer(timerPageSize: pageSize)
        newsProvider?.generateArticles(givenPageSize: pageSize)
    }
    
    //MARK:- Observing for new data
    
    @objc func received(notif: Notification) {
        if articles.count == 0 {
            articles = realmOps.readData()
            tableView.reloadData()
        } else if articles.count > 0 {
            fetchingMore = false
            if realmOps.readData() == articles {
                print("news are the same")
            }
            else {
                articles = realmOps.readData()
                tableView.reloadData()
            }
        }
    }
    
    //MARK:- Sending data to detail view
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetail1" else {return}
        if let articleDetail = segue.destination as? TopHeadlinesDetailsViewController {
            if let cell = sender as? NewsCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let article = articles[indexPath.row]
                    articleDetail.articleDetail = article
                }
            }
        }
    }
    
}


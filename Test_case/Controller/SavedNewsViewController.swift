import UIKit
class SavedNewsViewController: UITableViewController {
    var articles :[ArticleSaved] = []
    var newsProvider : NewsProvider?
    let realmOps = RealmOps()
    let myRefreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(received(notif:)), name: Constants.savedNotificationName, object: nil)
        articles = realmOps.readSaved()
        newsProvider = NewsProvider()
        
        tableView.refreshControl = myRefreshControl
        print("first request (everything)")
        
    }
    
    @objc private func refresh (sender: UIRefreshControl)  {
        articles = realmOps.readSaved()
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    @objc func received(notif: Notification) {
        articles = realmOps.readSaved()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedNewsCellIdentifier", for: indexPath) as! savedNewsCell
        let article = articles[indexPath.row]
        if article.urlToImage != "" {
            if let unwrappedURL = URL(string: article.urlToImage) {
                newsProvider?.downloadImage(url: unwrappedURL, completion: { image in
                    cell.savedImageView.image = image
                })
            }
        }
        cell.savedTitleLabel.text = article.title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toSaveDetail" else {return}
        if let articleDetail = segue.destination as? SavedDetailsViewController {
            if let cell = sender as? savedNewsCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let article = articles[indexPath.row]
                    articleDetail.articleDetail = article
                }
            }
        }
    }
}

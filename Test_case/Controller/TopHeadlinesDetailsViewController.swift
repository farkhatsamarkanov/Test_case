import UIKit
class TopHeadlinesDetailsViewController : UIViewController, UITextViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishmentLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var URLtextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    var articleDetail : ArticleCached?
    var newsProvider : NewsProvider?
    
    override func viewDidLoad() {
        newsProvider = NewsProvider()
        if let article = articleDetail {
            authorLabel.text = article.author
            publishmentLabel.text  = article.publishedAt
            sourceLabel.text = article.sourceName
            titleLabel.text = article.title
            descriptionTextView.text = article.articleDescription
            URLtextView.text = article.url
            contentTextView.text = article.content
            if article.urlToImage != "" {
            newsProvider?.downloadImage(url: URL(string: article.urlToImage)!, completion: { image in
                self.imageView.image = image
            })
        }
    }
}
}

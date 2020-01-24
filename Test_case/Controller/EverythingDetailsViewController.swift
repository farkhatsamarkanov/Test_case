import UIKit
class EverythingDetailsViewController : UIViewController, UITextViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var publishLabel: UILabel!
    @IBOutlet weak var URLfield: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    var articleDetail : EverythingCached?
    var newsProvider : NewsProvider?
    override func viewDidLoad() {
        newsProvider = NewsProvider()
        if let article = articleDetail {
            authorLabel.text = article.author
            publishLabel.text  = article.publishedAt
            sourceLabel.text = article.sourceName
            titleLabel.text = article.title
            descriptionTextView.text = article.articleDescription
            URLfield.text = article.url
            contentTextView.text = article.content
            if article.urlToImage != "" {
                newsProvider?.downloadImage(url: URL(string: article.urlToImage)!, completion: { image in
                    self.imageView.image = image
                })
            }
        }    
    }
}

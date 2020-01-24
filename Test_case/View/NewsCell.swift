import UIKit
//MARK:- Custom cell
class NewsCell: UITableViewCell {
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Activity indicator for image downloading
        imageActivityIndicator.startAnimating()
        imageActivityIndicator.isHidden = false
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


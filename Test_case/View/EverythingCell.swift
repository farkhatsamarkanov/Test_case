import UIKit
class EverythingNewsCell: UITableViewCell {
    @IBOutlet weak var everythingImageView: UIImageView!
    @IBOutlet weak var everythingTitleLabel: UILabel!
    @IBOutlet weak var everythingActivityIndicator: UIActivityIndicatorView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        everythingActivityIndicator.startAnimating()
        everythingActivityIndicator.isHidden = false
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


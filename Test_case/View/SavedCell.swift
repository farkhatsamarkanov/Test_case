import UIKit
class savedNewsCell: UITableViewCell {
    @IBOutlet weak var savedActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var savedTitleLabel: UILabel!
    @IBOutlet weak var savedImageView: UIImageView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        savedActivityIndicator.startAnimating()
        savedActivityIndicator.isHidden = false
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}



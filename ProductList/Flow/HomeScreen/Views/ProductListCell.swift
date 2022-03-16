import UIKit

class ProductListCell: UITableViewCell {
    static var reuseIdentifier: String = String(describing: self)
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var representedIdentifier: String = ""
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image
        }
    }

    func configure(title: String, price: Double) {
        titleLabel.text = title
        priceLabel.text = String(price)
    }
}

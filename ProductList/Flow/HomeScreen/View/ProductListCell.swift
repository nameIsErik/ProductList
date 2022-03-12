import UIKit

class ProductListCell: UITableViewCell {
    static var reuseIdentifier: String = String(describing: self)
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    func configure(title: String, price: Double, iconURL: URL) {
        titleLabel.text = title
        priceLabel.text = String(price)
        
        URLSession.shared.dataTask(with: iconURL) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.iconImageView.image = UIImage(data: data)
                }
            } else {
                fatalError("error: \(error)")
            }
        }.resume()
    }
}

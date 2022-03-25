import UIKit

class ProductDetailViewController: UIViewController {
    static let identifier = String(describing: ProductDetailViewController.self)
    
    var product: Product?
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    func configure(with product: Product) {
        self.product = product
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        guard let product = product else { return }

        productPriceLabel.text = String(product.price)
        productTitleLabel.text = product.title
        productDescriptionTextView.text = product.description
        
        if FilesManager.fileExists(at: FilesManager.fileUrl(named: product.image.lastPathComponent)) {
            productImageView.image = FilesManager.retrieveImage(forKey: product.image.lastPathComponent)
        } else {
            NetworkService().image(product: product) { [weak self] data, error in
                if let data = data,
                   error == nil {
                    DispatchQueue.main.async {
                        self?.productImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}

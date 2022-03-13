import UIKit

class HeaderTableView: UITableViewHeaderFooterView {
    private var viewController: UIViewController?
    
    private var currentCategory: Category = .men
    
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewController: UIViewController) {
        self.viewController = viewController
    }

    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentCategory = .men
        } else {
            currentCategory = .women
        }
        
        if let viewController = viewController as? HomeViewController {
            viewController.setCategory(category: currentCategory)
        }
    }
    
}

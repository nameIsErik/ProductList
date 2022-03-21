import UIKit

class SearchViewConroller: UIViewController {

    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        
    }
}


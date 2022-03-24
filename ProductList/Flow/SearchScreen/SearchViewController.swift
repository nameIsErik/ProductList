import UIKit

class SearchViewConroller: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Category"
        navigationItem.searchController = searchController
        setupTableView()
        
    }
    
    func setupTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SearchViewConroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = Category(rawValue: indexPath.row)?.getText()
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as? SearchResultViewController else {
            return
        }
        guard let category = Category(rawValue: indexPath.row) else { return }
        
        vc.configure(urlString: category.urlString)
        self.navigationItem.backButtonTitle = category.getText()
        self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

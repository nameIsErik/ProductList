import UIKit

class SearchResultViewController: UIViewController {
    static let identifier = String(describing: SearchResultViewController.self)
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    
    var products: [Product]?
    var urlString: String?
    let networkService = NetworkService.shared
    
    func configure(urlString: String) {
        self.urlString = urlString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myMenu = UIMenu(title: "", children: [
            UIAction(title: "Price: Low to High",  handler: { [weak self] press in
                self?.products = self?.products?.sorted {
                    $0.price < $1.price
                }
                
                self?.searchResultsTableView.reloadData()
        }),
            UIAction(title: "Price: High to Low",  handler: { [weak self] press in
                self?.products = self?.products?.sorted {
                    $0.price > $1.price
                }
                
                self?.searchResultsTableView.reloadData()

            })
        
        ])
        filterButton.menu = myMenu
        filterButton.showsMenuAsPrimaryAction = true
        
        setupTableView()
        if let urlString = urlString {
            NetworkDataFetcher().fetchProducts(urlString: urlString) { [weak self] response in
                guard let response = response else { return }
                self?.products = response
                self?.products = self?.products?.sorted {
                    $0.price < $1.price
                }
                
                DispatchQueue.main.async {
                    self?.searchResultsTableView.reloadData()
                }
            }
        }
        
    }
    
    func setupTableView() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.register(UINib(nibName: "ProductListCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as? ProductListCell else { fatalError("Error dequeuing cell") }
        
        if let product = products?[indexPath.row] {
            cell.configure(title: product.title, price: product.price)
            cell.image = nil
            
            let representedIdentifier = String(product.id)
            cell.representedIdentifier = representedIdentifier
            
            networkService.image(product: product) { data, error in
                if let data = data,
                   let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        if cell.representedIdentifier == representedIdentifier {
                            cell.image = image
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }    
}

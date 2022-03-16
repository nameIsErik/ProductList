import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var productListTableView: UITableView!
    
    var productArray: [Product]?
    let networkService = NetworkService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        let urlString = "https://fakestoreapi.com/products"
        
        NetworkDataFetcher().fetchProducts(urlString: urlString) { [weak self] response in
            guard let response = response else { return }
            self?.productArray = response
            DispatchQueue.main.async {
                self?.productListTableView.reloadData()
            }
        }
    }
    
    func setCategory(category: Category) {
        NetworkDataFetcher().fetchProducts(urlString: category.urlString) { [weak self] response in
            guard let response = response else { return }
            self?.productArray = response
            DispatchQueue.main.async {
                self?.productListTableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        productListTableView.delegate = self
        productListTableView.dataSource = self
        productListTableView.register(UINib(nibName: "ProductListCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        productListTableView.register(UINib(nibName: "HeaderTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderTableView")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as? ProductListCell else { fatalError("Error dequeuing cell") }
        
        if let product = productArray?[indexPath.row] {
            cell.configure(title: product.title, price: product.price)
            cell.image = nil
            
            let representedIdentifier = String(product.id)
            cell.representedIdentifier = representedIdentifier
            
            networkService.image(product: product) { data, error in
                if let data = data {
                    let image = UIImage(data: data)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderTableView") as? HeaderTableView else { return UIView() }
        
        header.configure(with: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

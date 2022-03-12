import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var productListTableView: UITableView!
    
    var productArray: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        let urlString = "https://fakestoreapi.com/products"
        
        NetworkDataFetcher().fetchProducts(urlString: urlString) { response in
            guard let response = response else { return }
            self.productArray = response
            self.productListTableView.reloadData()
        }
    }
    
    private func setupTableView() {
        productListTableView.delegate = self
        productListTableView.dataSource = self
        productListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = productArray?[indexPath.row].title
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var productListTableView: UITableView!
    
    var productArray: [Product]?
    let networkService = NetworkService.shared
    let databaseHelper = DatabaseHelper()
    let urlString = "https://fakestoreapi.com/products"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Product List"
        setupTableView()
        
        
        if NetworkMonitor.shared.isConnected {
           updateData()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: NoInternetViewController.identifier) as? NoInternetViewController else { return }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            vc.configure(dismissAction: { [weak self] in
                self?.updateData()
            })
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func updateData() {
        NetworkDataFetcher().fetchProducts(urlString: urlString) { [weak self] response in
            guard let response = response else { return }
            self?.productArray = response
            
            guard let productArray = self?.productArray else { return }
            
            self?.databaseHelper.saveProductsToDB(products: productArray)
            
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
        return productArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as? ProductListCell else { fatalError("Error dequeuing cell") }
        
        if let product = productArray?[indexPath.row] {
            cell.configure(title: product.title, price: product.price)
            cell.image = nil
            
            let representedIdentifier = String(product.id)
            cell.representedIdentifier = representedIdentifier
            
            networkService.image(product: product) { data, error in
                if let data = data,
                   let image = UIImage(data: data) {
                     
                    if !FilesManager.fileExists(at: FilesManager.fileUrl(named: product.image.lastPathComponent)) {
                        DispatchQueue.global(qos: .background).async {
                            FilesManager.store(image: image, forKey: product.image.lastPathComponent)
                        }
                    }
                    
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

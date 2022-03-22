import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var productListTableView: UITableView!
    
    var productArray: [Product]?
    var productArrayDB: [ProductDB]?
    var session: Session?
    
    let networkService = NetworkService.shared
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        let urlString = "https://fakestoreapi.com/products"
        if NetworkMonitor.shared.isConnected {
            NetworkDataFetcher().fetchProducts(urlString: urlString) { [weak self] response in
                guard let response = response else { return }
                self?.productArray = response
                
                guard let productArray = self?.productArray else {
                    return
                }
                self?.saveProductsToDB(products: productArray)
            
                
                
                DispatchQueue.main.async {
                    self?.productListTableView.reloadData()
                }
            }
        } else {
            do {
                session = try context.fetch(Session.fetchRequest()).last
            } catch {
                fatalError("here HERE ERIK HI JO HI")
            }
            
            guard let session = session else { return }
        
            productArrayDB = DatabaseHelper().getAllProducts(in: session)

            guard let productArrayDB = productArrayDB else {
                return
            }
            
            productArray = []
            for productDB in productArrayDB {
                productArray?.append(Product(id: Int(productDB.id), title: productDB.title!,
                                             price: productDB.price, category: productDB.category!,
                                             description: productDB.description, image: productDB.image!))
            }
            productListTableView.reloadData()
        }
    }
    
    func saveProductsToDB(products: [Product]) {
        session = Session(context: context)
        
        for product in products {
            let productDB = ProductDB(context: context)
            productDB.id = Int64(product.id)
            productDB.title = product.title
            productDB.price = product.price
            productDB.category = product.category
            productDB.descriptionDB = product.description
            productDB.image = product.image
            productDB.session = session
            
            session?.addToProducts(productDB)
        }
        
        do {
            try context.save()
        } catch let error {
            print("ERROR SAVING CONTEXT: \(error)")
            fatalError()
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

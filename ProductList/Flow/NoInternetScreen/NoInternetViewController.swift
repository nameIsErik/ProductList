import UIKit

class NoInternetViewController: UIViewController {
    static let identifier = String(describing: NoInternetViewController.self)
    @IBOutlet weak var updateConnectionButton: UIButton!
    
    typealias onDismiss = () -> Void
    var dismissAction: onDismiss?
    let monitor = NetworkMonitor.shared
    
    func configure(dismissAction: @escaping onDismiss) {
        self.dismissAction = dismissAction
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        monitor.startMonitoring()
    }
    
    func setupViews() {
        updateConnectionButton.layer.shadowOffset = .init(width: 0, height: 1.5)
        updateConnectionButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        updateConnectionButton.layer.shadowRadius = 0.0
        updateConnectionButton.layer.shadowOpacity = 1
        updateConnectionButton.layer.cornerRadius = 10
    }
    
    @IBAction func updateConnectionPressed(_ sender: Any) {
        if monitor.isConnected {
            self.dismiss(animated: true) {
                self.dismissAction?()
            }
        }
    }
}

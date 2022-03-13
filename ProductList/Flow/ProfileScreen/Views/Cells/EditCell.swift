import UIKit

class EditCell: UITableViewCell {
    typealias NameChangeAction = (String) -> Void
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    private var nameChangeAction: NameChangeAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
    }
    
    func configure(name: String, changeAction: @escaping NameChangeAction) {
        nameTextField.text = name
        self.nameChangeAction = changeAction
    }
}

extension EditCell: UITextFieldDelegate {
    
}

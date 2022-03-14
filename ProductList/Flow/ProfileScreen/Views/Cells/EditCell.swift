import UIKit

class EditCell: UITableViewCell {
    typealias TextChanged = (String) -> ()
    @IBOutlet weak var nameTextField: UITextField!
    
    private var textChanged: TextChanged?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
    }
    
    func configure(text: String, placeholderText: String, textChanged: @escaping TextChanged) {
        nameTextField.text = text
        nameTextField.placeholder = placeholderText
        self.textChanged = textChanged
    }
}

extension EditCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let originalText = textField.text {
            let newText = (originalText as NSString).replacingCharacters(in: range, with: string)
            textChanged?(newText)
        }
        return true
    }
}

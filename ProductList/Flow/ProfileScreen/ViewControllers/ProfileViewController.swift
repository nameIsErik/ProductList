import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    private var profile: Profile? = Profile(name: "Leo", lastName: "last", secondName: "sec",
                                            email: "email", photo: UIImage(named: "leo") ?? UIImage())
    private var tempProfile: Profile?
    private var profileDataSource: UITableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEditing(false, animated: false)
        setupViews()
    }
    
    func setupViews() {
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
    }
    
    func transitionToViewMode(_ profile: Profile) {
        if let tempProfile = tempProfile {
            self.profile = tempProfile
            self.tempProfile = nil
            profileDataSource = ProfileViewDataSource(profile: tempProfile)
            profileImageView.image = tempProfile.photo
        } else {
            profileDataSource = ProfileViewDataSource(profile: profile)
            profileImageView.image = profile.photo
        }
        navigationItem.title = NSLocalizedString("Profile", comment: "profile nav title")
        navigationItem.leftBarButtonItem = nil
        editButtonItem.isEnabled = true
    }
    
    func transitionToEditMode(_ profile: Profile) {
        profileDataSource = ProfileEditDataSource(profile: profile, profileChanged: { newProfile in
            self.tempProfile = newProfile
            self.editButtonItem.isEnabled = true
            self.profileImageView.image = newProfile.photo
        })
        navigationItem.title = NSLocalizedString("Edit Profile", comment: "edit profile nav title")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChanges))
    }
    
    @objc func cancelChanges() {
        self.tempProfile = nil
        setEditing(false, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let profile = profile else {
            return
        }
        
        if editing {
            transitionToEditMode(profile)
            view.backgroundColor = .systemPink
            profileTableView.backgroundColor = .systemPink
            addPhotoButton.alpha = 1
        } else {
            transitionToViewMode(profile)
            view.backgroundColor = .gray
            profileTableView.backgroundColor = .gray
            addPhotoButton.alpha = 0
        }
        profileTableView.dataSource = profileDataSource
        profileTableView.reloadData()
    }
}

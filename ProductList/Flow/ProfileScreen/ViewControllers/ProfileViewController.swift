import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    
    private var profile: Profile? = Profile(name: "Leo", lastName: "last", secondName: "sec", email: "email")
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
//        if let tempReminder = tempReminder {
//            self.reminder = tempReminder
//            self.tempReminder = nil
//            reminderEditAction?(tempReminder)
//            dataSource = ReminderDetailViewDataSource(reminder: tempReminder)
//        } else {
//            dataSource = ReminderDetailViewDataSource(reminder: reminder)
//        }
        if let tempProfile = tempProfile {
            self.profile = tempProfile
            self.tempProfile = nil
            profileEd
        }
        profileDataSource = ProfileViewDataSource(profile: profile)
        navigationItem.title = NSLocalizedString("Profile", comment: "profile nav title")
    }
    
    func transitionToEditMode(_ profile: Profile) {
        profileDataSource = ProfileEditDataSource(profile: profile, changeAction: { profile in
            self.profile = profile
            self.editButtonItem.isEnabled = true
        })
        navigationItem.title = NSLocalizedString("Edit Profile", comment: "edit profile nav title")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let profile = profile else {
            return
        }
        
        if editing {
            transitionToEditMode(profile)
            view.backgroundColor = .blue
        } else {
            transitionToViewMode(profile)
            view.backgroundColor = .gray
        }
        
        profileTableView.dataSource = profileDataSource
        profileTableView.reloadData()
    }
}

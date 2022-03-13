import UIKit

class ProfileEditDataSource: NSObject {
    typealias ProfileChangeAction = (Profile) -> Void
    
    enum ProfileSection: Int, CaseIterable {
        case name
        case lastName
//        case secondName
//        case email
        
        var displayText: String {
            switch self {
            case .name:
                return "Name"
            case .lastName:
                return "Last Name"
//            case .secondName:
//                return "Second Name"
//            case .email:
//                return "Email"
            }
        }
        
        func cellIdentifier(for row: Int) -> String {
            switch self {
            case .name:
                return "EditCell"
            case .lastName:
                return "EditCell"
//            case .secondName:
//                return "EditNameCell"
//            case .email:
//                return "EditNameCell"
            }
        }
    }
    
    private var profile: Profile
    private var profileChangeAction: ProfileChangeAction?
    
    init(profile: Profile, changeAction: @escaping ProfileChangeAction) {
        self.profile = profile
        self.profileChangeAction = changeAction
    }
    
    private func dequeueAndConfigureCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        guard let section = ProfileSection(rawValue: indexPath.row) else { fatalError() }
        
        let identifier = section.cellIdentifier(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let nameCell = cell as? EditCell {
            nameCell.configure(name: profile.name) { name in
                self.profile.name = name
                self.profileChangeAction?(self.profile)
            }
        }
        return cell
    }
}

extension ProfileEditDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueAndConfigureCell(for: indexPath, in: tableView)
    }
    
    
}

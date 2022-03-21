import UIKit

class ProfileEditDataSource: NSObject {
    typealias ProfileChanged = (Profile) -> ()
    
    enum ProfileEditRows: Int, CaseIterable {
        case name
        case lastName
        case secondName
        case email
        
        var displayText: String {
            switch self {
            case .name:
                return "Name"
            case .lastName:
                return "Last Name"
            case .secondName:
                return "Second Name"
            case .email:
                return "Email"
            }
        }
        
    }
    
    private var profile: Profile
    private var profileChanged: ProfileChanged
    
    init(profile: Profile, profileChanged: @escaping ProfileChanged) {
        self.profile = profile
        self.profileChanged = profileChanged
        super.init()
    }
}

extension ProfileEditDataSource: UITableViewDataSource {
    static let cellIdentifier = "EditCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileEditRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath) as? EditCell else { return UITableViewCell() }
        
        cell.contentView.backgroundColor = .white
        
        guard let row = ProfileEditRows(rawValue: indexPath.row) else { fatalError() }
        switch row {
        case .name:
            cell.configure(text: profile.name, placeholderText: row.displayText) { text in
                self.profile.name = text
                self.profileChanged(self.profile)
            }
        case .lastName:
            cell.configure(text: profile.lastName, placeholderText: row.displayText) { text in
                self.profile.lastName = text
                self.profileChanged(self.profile)
            }
        case .secondName:
            cell.configure(text: profile.secondName, placeholderText: row.displayText) { text in
                self.profile.secondName = text
                self.profileChanged(self.profile)
            }
        case .email:
            cell.configure(text: profile.email, placeholderText: row.displayText) { text in
                self.profile.email = text
                self.profileChanged(self.profile)
            }
        }
        
        return cell
    }
}

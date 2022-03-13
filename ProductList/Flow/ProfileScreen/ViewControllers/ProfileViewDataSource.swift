import UIKit

class ProfileViewDataSource: NSObject {
    enum ProfileRow: Int, CaseIterable {
        case name
        case lastName
        case secondName
        case email
        
        func displayText(for profile: Profile) -> String {
            switch self {
            case .name:
                return profile.name
            case .lastName:
                return profile.lastName
            case .secondName:
                return profile.secondName
            case .email:
                return profile.email
            }
        }
    }
    
    private var profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
        super.init()
    }
}


extension ProfileViewDataSource: UITableViewDataSource {
    static let profileCellIdentifier = "EditCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.profileCellIdentifier, for: indexPath)
        let row = ProfileRow(rawValue: indexPath.row)
    
        var content = cell.defaultContentConfiguration()
        
        content.text = row?.displayText(for: profile)
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

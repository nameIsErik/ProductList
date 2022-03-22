import UIKit

struct FilesManager {
    private static let defaultManager = FileManager.default
    
    static var documentsUrl: URL {
        return defaultManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func filePath(for key: String) -> URL {
        return documentsUrl.appendingPathComponent(key)
    }
    
    static func store(image: UIImage, forKey key: String) {
        if let jpgRepresentation = image.jpegData(compressionQuality: 1.0) {
            do {
                print(filePath(for: key))
                try jpgRepresentation.write(to: filePath(for: key))
            } catch let error {
                print("Error writing image to FileSystem: \(error)")
            }
        }
    }
    
    static func fileUrl(named name: String) -> URL {
        return documentsUrl.appendingPathComponent(name)
    }
    
    static func retrieveImage(forKey key: String) -> UIImage? {
        if let fileData = defaultManager.contents(atPath: filePath(for: key).path),
            let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    static func retrieveImage(forKey key: String) -> Data? {
        if let fileData = defaultManager.contents(atPath: filePath(for: key).path) {
            return fileData
        }
//            let image = UIImage(data: fileData) {
//            return image
//        }
        
        return nil
    }
    
    static func removeImage(at url: URL) {
        try? defaultManager.removeItem(at: url)
    }

    static func fileExists(at url: URL) -> Bool {
        return defaultManager.fileExists(atPath: url.path)
    }
}

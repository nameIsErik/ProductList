import UIKit

struct FilesManager {
    private static let defaultManager = FileManager.default
    
    static var documentsUrl: URL {
        return defaultManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func filePath(for key: String) -> URL {
        return documentsUrl.appendingPathComponent(key + ".png")
    }
    
    static func store(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.pngData() {
            do {
                try pngRepresentation.write(to: filePath(for: key))
            } catch {
                print("Error writing image to FileSystem")
            }
        }
    }
    
    static func retrieveImage(forKey key: String) -> UIImage? {
        if let fileData = defaultManager.contents(atPath: filePath(for: key).path),
            let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    static func removeImage(at url: URL) {
        try? defaultManager.removeItem(at: url)
    }
}

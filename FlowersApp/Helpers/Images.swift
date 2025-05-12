//
//  Images.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 03.05.25.
//

import UIKit

struct Images {
    struct Welcome {
        static let logo = UIImage(named: "logo")!
        static let backgroundImage = UIImage(named: "background")!
    }
    
    struct Category {
        static let flower_1 = UIImage(named: "anemone")!
        static let flower_2 = UIImage(named: "camellia")!
        static let flower_3 = UIImage(named: "cosmos")!
        static let flower_4 = UIImage(named: "dahlia")!
        static let flower_5 = UIImage(named: "freesia")!
        static let flower_6 = UIImage(named: "hydrangea")!
        static let flower_7 = UIImage(named: "lilyoftheValley")!
        static let flower_8 = UIImage(named: "orchid")!
        static let flower_9 = UIImage(named: "peony")!
        static let flower_10 = UIImage(named: "zinnia")!
    }
}
extension UIImage {
    func compressedData(maxSizeMB: Double = 1.0) -> Data? {
        var compression: CGFloat = 1.0
        let maxSizeBytes = maxSizeMB * 1024 * 1024
        guard var data = self.jpegData(compressionQuality: compression) else { return nil }
        
        while data.count > Int(maxSizeBytes) && compression > 0.1 {
            compression -= 0.1
            guard let newData = self.jpegData(compressionQuality: compression) else { return nil }
            data = newData
        }
        
        return data
    }
}

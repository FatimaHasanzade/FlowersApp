//
//  Color+Extension.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 03.05.25.
//

import UIKit

extension UIColor {
    static let primary = UIColor(red: 0.33, green: 0.69, blue: 0.46, alpha: 1.00)
    static let description = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 0.7)
    
    struct Cards {
        static let flower1 = UIColor(red: 0.33, green: 0.69, blue: 0.46, alpha: 0.1)
        static let flower1_Outline = UIColor(red: 033, green: 0.69, blue: 0.46, alpha: 0.7)
        static let flower2 = UIColor(red: 0.97, green: 0.64, blue: 0.30, alpha: 0.1)
        static let flower2_Outline = UIColor(red: 0.97, green: 0.64, blue: 0.30, alpha: 0.7)
        static let flower3 = UIColor(red: 0.64, green: 0.30, blue: 0.70, alpha: 0.1)
        static let flower3_Outline = UIColor(red: 0.64, green: 0.30, blue: 0.70, alpha: 0.7)
        static let flower4 = UIColor(red: 0.99, green: 0.33, blue: 0.33, alpha: 0.1)
        static let flower4_Outline = UIColor(red: 0.99, green: 0.33, blue: 0.33, alpha: 0.7)
        static let flower5 = UIColor(red: 0.99, green: 0.99, blue: 0.33, alpha: 0.1)
        static let flower5_Outline = UIColor(red: 0.99, green: 0.99, blue: 0.33, alpha: 0.7)
        static let flower6 = UIColor(red: 0.33, green: 0.33, blue: 0.99, alpha: 0.1)
        static let flower6_Outline = UIColor(red: 0.33, green: 0.33, blue: 0.99, alpha: 0.7)
        static let flower7 = UIColor(red: 0.99, green: 0.33, blue: 0.64, alpha: 0.1)
        static let flower7_Outline = UIColor(red: 0.99, green: 0.33, blue: 0.64, alpha: 0.7)
        static let flower8 = UIColor(red: 0.33, green: 0.69, blue: 0.99, alpha: 0.1)
        static let flower8_Outline = UIColor(red: 0.33, green: 0.69, blue: 0.99, alpha: 0.7)
        static let flower9 = UIColor(red: 0.99, green: 0.33, blue: 0.33, alpha: 0.1)
        static let flower9_Outline = UIColor(red: 0.99, green: 0.99, blue: 0.33, alpha: 0.7)
        static let flower10 = UIColor(red: 0.97, green: 0.64, blue: 0.30, alpha: 0.1)
        static let flower10_Outline = UIColor(red: 0.97, green: 0.64, blue: 0.30, alpha: 0.7)
    }
    
    func encode() -> String {
           var red: CGFloat = 0
           var green: CGFloat = 0
           var blue: CGFloat = 0
           var alpha: CGFloat = 0
           self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
           
           let colorData = [red, green, blue, alpha].map { Float($0) }
           let data = try! JSONEncoder().encode(colorData)
           return data.base64EncodedString()
       }
       
       static func decode(from base64: String) throws -> UIColor {
           guard let data = Data(base64Encoded: base64) else {
               throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid base64 string"))
           }
           
           let colorComponents = try JSONDecoder().decode([Float].self, from: data)
           guard colorComponents.count == 4 else {
               throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid color components"))
           }
           
           return UIColor(
               red: CGFloat(colorComponents[0]),
               green: CGFloat(colorComponents[1]),
               blue: CGFloat(colorComponents[2]),
               alpha: CGFloat(colorComponents[3])
           )
       }
}

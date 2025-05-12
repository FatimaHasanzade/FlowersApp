//
//  CategoryCardModel.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 03.05.25.
//

import UIKit

struct CategoryCardModel: Codable, Equatable {
    let id: Int
    var title: String
    var imageData: Data?
    var color: UIColor
    var borderColor: UIColor
    var isFavorite: Bool
    let isUserCreated: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, imageData, color, borderColor, isFavorite, isUserCreated
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(color.encode(), forKey: .color)
        try container.encode(borderColor.encode(), forKey: .borderColor)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(isUserCreated, forKey: .isUserCreated)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        color = try UIColor.decode(from: container.decode(String.self, forKey: .color))
        borderColor = try UIColor.decode(from: container.decode(String.self, forKey: .borderColor))
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        isUserCreated = try container.decode(Bool.self, forKey: .isUserCreated)
    }
    
    init(title: String, image: UIImage?, color: UIColor, borderColor: UIColor, isFavorite: Bool, isUserCreated: Bool) {
        self.id = CategoryCardModel.generateRandomId()
        self.title = title
        self.imageData = image?.compressedData(maxSizeMB: 1.0)
        self.color = color
        self.borderColor = borderColor
        self.isFavorite = isFavorite
        self.isUserCreated = isUserCreated
    }
    
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
    
    static func ==(lhs: CategoryCardModel, rhs: CategoryCardModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func generateRandomId() -> Int {
        return Int(UUID().uuidString.hashValue & 0x7FFFFFFF)
    }
}

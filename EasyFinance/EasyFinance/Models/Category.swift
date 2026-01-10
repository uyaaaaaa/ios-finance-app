import Foundation
import SwiftData

@Model
final class Category {
    @Attribute(.unique) var id: UUID
    var name: String
    var iconSymbol: String // SF Symbol name
    var colorHex: String // Simple hex string or color name
    var sortOrder: Int
    
    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction]?
    
    init(id: UUID = UUID(), name: String, iconSymbol: String = "cart", colorHex: String = "gray", sortOrder: Int = 0) {
        self.id = id
        self.name = name
        self.iconSymbol = iconSymbol
        self.colorHex = colorHex
        self.sortOrder = sortOrder
    }
    
    // Default presets
    static let defaults: [Category] = [
        Category(name: "食費", iconSymbol: "fork.knife", colorHex: "orange", sortOrder: 0),
        Category(name: "日用品", iconSymbol: "cart", colorHex: "blue", sortOrder: 1),
        Category(name: "交通費", iconSymbol: "tram", colorHex: "green", sortOrder: 2),
        Category(name: "交際費", iconSymbol: "person.2", colorHex: "pink", sortOrder: 3),
        Category(name: "固定費", iconSymbol: "house", colorHex: "indigo", sortOrder: 4),
        Category(name: "その他", iconSymbol: "ellipsis.circle", colorHex: "gray", sortOrder: 5)
    ]
}

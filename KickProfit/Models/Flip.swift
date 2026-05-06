import SwiftData
import Foundation

@Model
final class Flip {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var flipDate: Date = Date()

    var brand: String = ""
    var name: String = ""
    var colorway: String = ""
    var sizeUS: Double = 10.0
    var conditionRaw: String = FlipCondition.deadstock.rawValue

    var purchasePrice: Double = 0
    var salePrice: Double = 0

    var statusRaw: String = FlipStatus.sold.rawValue
    var notes: String = ""

    init() {}

    var profit: Double { salePrice - purchasePrice }
    var roi: Double { purchasePrice > 0 ? profit / purchasePrice : 0 }
    var displayName: String { "\(brand) \(name)".trimmingCharacters(in: .whitespaces) }

    var condition: FlipCondition {
        get { FlipCondition(rawValue: conditionRaw) ?? .deadstock }
        set { conditionRaw = newValue.rawValue }
    }

    var status: FlipStatus {
        get { FlipStatus(rawValue: statusRaw) ?? .sold }
        set { statusRaw = newValue.rawValue }
    }
}

enum FlipStatus: String, CaseIterable, Identifiable {
    case sold = "Sold"
    case listed = "Listed"
    case unwound = "Unwound"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .sold:    return "checkmark.circle.fill"
        case .listed:  return "tag.fill"
        case .unwound: return "xmark.circle.fill"
        }
    }
}

enum FlipCondition: String, CaseIterable, Identifiable {
    case deadstock = "Deadstock"
    case vnds = "VNDS"
    case used = "Used"

    var id: String { rawValue }
}

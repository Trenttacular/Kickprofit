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
    var sizeCategoryRaw: String = SizeCategory.mens.rawValue
    var conditionRaw: String = FlipCondition.deadstock.rawValue

    var purchasePrice: Double = 0
    var salePrice: Double = 0

    var statusRaw: String = FlipStatus.listed.rawValue
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
        get { FlipStatus(rawValue: statusRaw) ?? .listed }
        set { statusRaw = newValue.rawValue }
    }

    var sizeCategory: SizeCategory {
        get { SizeCategory(rawValue: sizeCategoryRaw) ?? .mens }
        set { sizeCategoryRaw = newValue.rawValue }
    }

    // Cash flow view: listed = money tied up (negative), sold = money received (positive)
    var cashFlowValue: Double {
        switch status {
        case .sold:             return salePrice
        case .listed, .unwound: return -purchasePrice
        }
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

enum SizeCategory: String, CaseIterable, Identifiable {
    case mens    = "Men's"
    case womens  = "Women's"
    case youth   = "Youth"
    case toddler = "Toddler"
    case infant  = "Infant"

    var id: String { rawValue }

    var sizeMin: Double {
        switch self {
        case .mens:    return 6.0
        case .womens:  return 5.0
        case .youth:   return 3.5
        case .toddler: return 1.0
        case .infant:  return 1.0
        }
    }

    var sizeMax: Double {
        switch self {
        case .mens:    return 18.0
        case .womens:  return 13.0
        case .youth:   return 7.0
        case .toddler: return 10.0
        case .infant:  return 4.0
        }
    }

    var defaultSize: Double {
        switch self {
        case .mens:    return 10.0
        case .womens:  return 8.0
        case .youth:   return 5.0
        case .toddler: return 6.0
        case .infant:  return 2.0
        }
    }
}

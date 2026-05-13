import Foundation

struct ShoeDatabase {

    struct ShoeModel: Identifiable {
        var id: String { name }
        let name: String
        let popularColorways: [String]
    }

    struct Brand: Identifiable {
        var id: String { name }
        let name: String
        let models: [ShoeModel]
    }

    static let brands: [Brand] = [
        Brand(name: "Jordan", models: [
            ShoeModel(name: "Air Jordan 1 Retro High OG", popularColorways: [
                "Chicago", "Bred Toe", "Royal", "Shadow", "Dark Mocha", "UNC", "Court Purple",
                "Patina", "Starfish", "Electro Orange", "Washed Heritage", "Lost & Found",
                "Olive", "Yellow Ochre"
            ]),
            ShoeModel(name: "Air Jordan 1 Mid", popularColorways: [
                "White Shadow", "Bred", "Gym Red", "College Grey", "Multi-Color"
            ]),
            ShoeModel(name: "Air Jordan 1 Low", popularColorways: [
                "Shadow Toe", "Bred", "Golf Neutral Grey", "Mocha", "Olive"
            ]),
            ShoeModel(name: "Air Jordan 2 Retro", popularColorways: [
                "White Red", "Chicago", "Black Cement"
            ]),
            ShoeModel(name: "Air Jordan 3 Retro", popularColorways: [
                "Black Cement", "Fire Red", "True Blue", "Pine Green",
                "Midnight Navy", "Muslin", "Palomino", "Fear"
            ]),
            ShoeModel(name: "Air Jordan 4 Retro", popularColorways: [
                "Bred", "Fire Red", "White Cement", "Military Blue", "Cool Grey",
                "Lightning", "Pine Green", "Canyon Purple", "Vivid Sulfur",
                "Infrared", "Sail", "Oxidized Green"
            ]),
            ShoeModel(name: "Air Jordan 5 Retro", popularColorways: [
                "Moonlight", "Lucky Green", "Aqua", "Raging Bull", "Olive",
                "Metallic Silver", "Oreo", "Anthracite"
            ]),
            ShoeModel(name: "Air Jordan 6 Retro", popularColorways: [
                "Carmine", "Midnight Navy", "Georgetown", "Yellow Ochre",
                "Aqua", "DMP", "Infrared"
            ]),
            ShoeModel(name: "Air Jordan 7 Retro", popularColorways: [
                "Flint", "Cardinal", "DMP", "Citrus"
            ]),
            ShoeModel(name: "Air Jordan 11 Retro", popularColorways: [
                "Bred", "Space Jam", "Legend Blue", "Gamma Blue",
                "Concord", "Cool Grey", "Win Like 96", "Cherry"
            ]),
            ShoeModel(name: "Air Jordan 12 Retro", popularColorways: [
                "Playoffs", "Flu Game", "Cherry", "Dark Concord", "Stealth", "University Gold"
            ]),
            ShoeModel(name: "Air Jordan 13 Retro", popularColorways: [
                "French Blue", "Black Flint", "Brave Blue", "Del Sol"
            ]),
            ShoeModel(name: "Air Jordan 14 Retro", popularColorways: [
                "Gym Red", "Black Toe", "Laney"
            ]),
        ]),

        Brand(name: "Nike", models: [
            ShoeModel(name: "Dunk Low", popularColorways: [
                "Panda", "University Red", "Syracuse", "Michigan", "Chicago",
                "Reverse Panda", "Green Glow", "Photon Dust", "Plum",
                "Setsubun", "Polar Blue", "Futura"
            ]),
            ShoeModel(name: "Dunk High", popularColorways: [
                "Championship Navy", "Spartan Green", "Grinch", "Baroque Brown"
            ]),
            ShoeModel(name: "Air Force 1 Low '07", popularColorways: [
                "White", "Black", "Wheat", "Flax", "Rose Whisper", "Summit White Coconut Milk"
            ]),
            ShoeModel(name: "Air Force 1 High '07", popularColorways: ["White", "Black"]),
            ShoeModel(name: "Air Max 1", popularColorways: [
                "Anniversary Red", "Curry", "Pollen", "Treeline", "Obsidian"
            ]),
            ShoeModel(name: "Air Max 90", popularColorways: [
                "Infrared", "White", "Black", "Bacon", "Camo", "Triple White"
            ]),
            ShoeModel(name: "Air Max 95", popularColorways: [
                "Neon", "White", "Black", "Grape", "SC New York"
            ]),
            ShoeModel(name: "Air Max 97", popularColorways: [
                "Silver Bullet", "Gold", "OG", "Atlantic Blue", "South Beach"
            ]),
            ShoeModel(name: "Air Max 270", popularColorways: ["Black", "White", "React"]),
            ShoeModel(name: "Air Max TN Plus", popularColorways: [
                "Hyper Blue", "Black", "Anthracite", "University Red"
            ]),
            ShoeModel(name: "Air Max Plus 3", popularColorways: ["Black", "Voltage Purple"]),
            ShoeModel(name: "Blazer Mid '77", popularColorways: [
                "White Gum", "Vintage White", "Black", "Halloween"
            ]),
            ShoeModel(name: "P-6000", popularColorways: [
                "Silver White", "Metallic Silver", "Black"
            ]),
            ShoeModel(name: "Cortez", popularColorways: [
                "White Red Blue", "Black White", "Metallic Gold"
            ]),
        ]),

        Brand(name: "Yeezy", models: [
            ShoeModel(name: "Yeezy Boost 350 V2", popularColorways: [
                "Zebra", "Beluga", "Black Non-Reflective", "Black Reflective",
                "Cream White", "Oreo", "Israfil", "Yeshaya", "Ash Blue",
                "Ash Pearl", "Ash Stone", "Natural", "Bone", "Slate",
                "MX Oat", "MX Rock", "MX Frost Orange"
            ]),
            ShoeModel(name: "Yeezy Boost 700", popularColorways: [
                "Wave Runner", "Mauve", "Analog", "Utility Black", "Salt", "Sun", "Bright Blue"
            ]),
            ShoeModel(name: "Yeezy Boost 700 V2", popularColorways: [
                "Static", "Cream", "Geode", "Vanta", "Hospital Blue"
            ]),
            ShoeModel(name: "Yeezy Boost 700 MNVN", popularColorways: [
                "Triple Black", "Orange", "Phosphor", "Geode"
            ]),
            ShoeModel(name: "Yeezy Boost 380", popularColorways: [
                "Alien", "Mist", "Calcite Glow", "Pepper", "Hylte Glow", "Azure"
            ]),
            ShoeModel(name: "Yeezy Slide", popularColorways: [
                "Bone", "Pure", "Onyx", "Granite", "Flax", "MX Sand Grey",
                "Ochre", "Azure", "Fade Salt"
            ]),
            ShoeModel(name: "Yeezy Foam Runner", popularColorways: [
                "Ochre", "Sand", "Mineral Blue", "Onyx", "MX Cream Clay",
                "Stone Sage", "MX Cinder"
            ]),
            ShoeModel(name: "Yeezy 500", popularColorways: [
                "Blush", "Utility Black", "Salt", "Bone White", "Enflame", "High Slate"
            ]),
            ShoeModel(name: "Yeezy 450", popularColorways: [
                "Cloud White", "Dark Slate", "Cinder"
            ]),
        ]),

        Brand(name: "Adidas", models: [
            ShoeModel(name: "Samba OG", popularColorways: [
                "White Gum", "Black White", "Cloud White Green", "Cloud White Preloved Red"
            ]),
            ShoeModel(name: "Gazelle", popularColorways: [
                "Bold Green", "Blue", "Red", "Black"
            ]),
            ShoeModel(name: "Campus 00s", popularColorways: [
                "Core Black", "Better Scarlet", "Cloud White"
            ]),
            ShoeModel(name: "Forum Low", popularColorways: [
                "White", "Black", "Buckle Low", "White Blue"
            ]),
            ShoeModel(name: "Superstar", popularColorways: [
                "White Black", "Shelltoe White", "Black"
            ]),
            ShoeModel(name: "NMD R1", popularColorways: [
                "OG", "Black", "White", "Monochrome", "Primeknit"
            ]),
            ShoeModel(name: "Ultraboost 1.0", popularColorways: [
                "Triple White", "Triple Black", "Light Grey", "OG"
            ]),
        ]),

        Brand(name: "New Balance", models: [
            ShoeModel(name: "New Balance 550", popularColorways: [
                "White Green", "White Navy", "Burgundy", "Grey", "Black"
            ]),
            ShoeModel(name: "New Balance 990v5", popularColorways: [
                "Grey", "Navy", "Black", "Green"
            ]),
            ShoeModel(name: "New Balance 990v6", popularColorways: [
                "Grey", "Black", "Cream", "Navy"
            ]),
            ShoeModel(name: "New Balance 2002R", popularColorways: [
                "Protection Pack Castlerock", "White Silver", "Black", "Sea Salt"
            ]),
            ShoeModel(name: "New Balance 1906R", popularColorways: [
                "Protection Pack Lunar New Year", "Grey Day", "White", "Chrome"
            ]),
            ShoeModel(name: "New Balance 9060", popularColorways: [
                "Sea Salt", "Black", "Quartz Grey", "Stone Pink"
            ]),
            ShoeModel(name: "New Balance 574", popularColorways: [
                "Grey", "Navy", "Classic", "White"
            ]),
            ShoeModel(name: "New Balance 327", popularColorways: [
                "White Black", "Sea Salt", "Varsity Gold"
            ]),
            ShoeModel(name: "New Balance 1080v12", popularColorways: [
                "White", "Black", "Navy"
            ]),
        ]),

        Brand(name: "Travis Scott", models: [
            ShoeModel(name: "Air Jordan 1 Low x Travis Scott", popularColorways: [
                "Mocha", "Olive", "Purple"
            ]),
            ShoeModel(name: "Air Jordan 1 High x Travis Scott", popularColorways: ["Mocha"]),
            ShoeModel(name: "Air Jordan 4 x Travis Scott", popularColorways: [
                "Purple", "Olive", "Cactus Jack"
            ]),
            ShoeModel(name: "Air Jordan 6 x Travis Scott", popularColorways: ["British Khaki"]),
            ShoeModel(name: "Nike Dunk Low x Travis Scott", popularColorways: ["Wheat"]),
            ShoeModel(name: "Nike Air Max 1 x Travis Scott", popularColorways: ["Baroque Brown"]),
            ShoeModel(name: "Nike Air Force 1 x Travis Scott", popularColorways: ["White"]),
        ]),

        Brand(name: "Off-White", models: [
            ShoeModel(name: "Air Jordan 1 Retro High x Off-White", popularColorways: [
                "Chicago", "UNC", "White", "NRG"
            ]),
            ShoeModel(name: "Nike Dunk Low x Off-White", popularColorways: [
                "Pine Green", "Varsity Maize", "Lot 1", "Lot 2", "Lot 30", "Lot 40"
            ]),
            ShoeModel(name: "Nike Air Force 1 x Off-White", popularColorways: ["White"]),
            ShoeModel(name: "Nike Air Max 90 x Off-White", popularColorways: [
                "Black", "Desert Ore"
            ]),
            ShoeModel(name: "Nike Air Max 97 x Off-White", popularColorways: [
                "Black", "Menta"
            ]),
        ]),

        Brand(name: "Fear of God", models: [
            ShoeModel(name: "Nike Air Fear of God 1", popularColorways: [
                "Black", "Light Bone", "All-Star", "Gold"
            ]),
            ShoeModel(name: "Adidas Athletics 86 Low x FOG", popularColorways: [
                "Carbon", "Light Brown"
            ]),
        ]),

        Brand(name: "Union", models: [
            ShoeModel(name: "Air Jordan 4 x Union", popularColorways: [
                "Off-Noir", "Taupe Haze"
            ]),
            ShoeModel(name: "Air Jordan 1 x Union", popularColorways: [
                "Black Toe", "Storm Blue"
            ]),
            ShoeModel(name: "Nike Dunk Low x Union", popularColorways: ["Passport Pack"]),
        ]),

        Brand(name: "Kith", models: [
            ShoeModel(name: "New Balance 1000 x Kith", popularColorways: [
                "Maldives", "Tokyo", "Paris"
            ]),
            ShoeModel(name: "Nike Air Max 1 x Kith", popularColorways: ["White", "Jewel"]),
            ShoeModel(name: "Adidas NMD x Kith", popularColorways: [
                "White", "Black", "Monochrome Pack"
            ]),
        ]),

        Brand(name: "Supreme", models: [
            ShoeModel(name: "Nike Dunk High x Supreme", popularColorways: [
                "Red", "Navy", "Green", "Barkroot Brown"
            ]),
            ShoeModel(name: "Nike Air Force 1 High x Supreme", popularColorways: [
                "White", "Black"
            ]),
            ShoeModel(name: "Air Jordan 5 x Supreme", popularColorways: [
                "Black", "White", "Camo"
            ]),
        ]),

        Brand(name: "Salehe Bembury", models: [
            ShoeModel(name: "New Balance 2002R x Salehe Bembury", popularColorways: [
                "Water be the Guide", "You Be the Judge"
            ]),
            ShoeModel(name: "Crocs Classic Clog x Salehe Bembury", popularColorways: [
                "Cucumber", "Citrus Milk"
            ]),
            ShoeModel(name: "New Balance 574 x Salehe Bembury", popularColorways: [
                "Sea Salt", "Auralee"
            ]),
        ]),

        Brand(name: "Concepts", models: [
            ShoeModel(name: "Nike Dunk Low x Concepts", popularColorways: [
                "Lobster", "Purple Lobster", "Yellow Lobster"
            ]),
            ShoeModel(name: "New Balance 990v3 x Concepts", popularColorways: ["Kennedy"]),
            ShoeModel(name: "Nike SB Dunk Low x Concepts", popularColorways: [
                "Orange Lobster", "Blue Lobster"
            ]),
        ]),

        Brand(name: "Sacai", models: [
            ShoeModel(name: "Nike LDWaffle x Sacai", popularColorways: [
                "Undercover Black", "Blue Multi", "White Nylon"
            ]),
            ShoeModel(name: "Nike Pegasus x Sacai", popularColorways: [
                "White Black", "Blue Void"
            ]),
            ShoeModel(name: "Nike Blazer Low x Sacai", popularColorways: [
                "Magma Orange", "White Patent Leather"
            ]),
        ]),

        Brand(name: "Fragment", models: [
            ShoeModel(name: "Air Jordan 1 Retro High x Fragment", popularColorways: [
                "Royal Blue"
            ]),
            ShoeModel(name: "Nike Dunk High x Fragment", popularColorways: ["Lightning"]),
        ]),

        Brand(name: "Stussy", models: [
            ShoeModel(name: "Nike Air Force 1 x Stussy", popularColorways: [
                "White", "Fossil", "Triple Black"
            ]),
            ShoeModel(name: "Nike Air Huarache x Stussy", popularColorways: [
                "White", "Bright Mandarin"
            ]),
        ]),

        Brand(name: "Puma", models: [
            ShoeModel(name: "Puma Suede Classic", popularColorways: [
                "Black White", "Navy White", "Team Gold"
            ]),
            ShoeModel(name: "Puma Speedcat", popularColorways: ["Black", "White", "Red"]),
            ShoeModel(name: "Puma Clyde", popularColorways: ["Black", "White", "Royal"]),
        ]),

        Brand(name: "Converse", models: [
            ShoeModel(name: "Chuck Taylor All Star '70 High", popularColorways: [
                "Black", "White", "Natural Ivory", "Parchment"
            ]),
            ShoeModel(name: "Chuck Taylor All Star '70 Low", popularColorways: [
                "Black", "White", "Ox"
            ]),
            ShoeModel(name: "One Star Pro", popularColorways: ["White Black", "Black"]),
        ]),

        Brand(name: "Vans", models: [
            ShoeModel(name: "Old Skool", popularColorways: [
                "Black White", "Navy White", "Checkerboard", "True White"
            ]),
            ShoeModel(name: "Sk8-Hi", popularColorways: ["Black White", "True White"]),
            ShoeModel(name: "Authentic", popularColorways: ["Black", "White"]),
        ]),

        Brand(name: "ASICS", models: [
            ShoeModel(name: "Gel-Kayano 14", popularColorways: [
                "White Sky", "Cream Black", "Midnight", "Piedmont Grey"
            ]),
            ShoeModel(name: "Gel-Lyte III OG", popularColorways: [
                "White White", "Cream", "Mid Grey"
            ]),
            ShoeModel(name: "Gel-Nimbus 9", popularColorways: [
                "French Blue", "Burgundy", "White"
            ]),
            ShoeModel(name: "GT-2160", popularColorways: [
                "White Black", "Cream Black", "Pink"
            ]),
        ]),

        Brand(name: "Reebok", models: [
            ShoeModel(name: "Club C 85", popularColorways: [
                "White Green", "Black", "Chalk"
            ]),
            ShoeModel(name: "Classic Leather", popularColorways: ["White", "Black"]),
            ShoeModel(name: "Freestyle Hi", popularColorways: ["White", "Black"]),
            ShoeModel(name: "Question Mid", popularColorways: [
                "Playoff", "Shaq Attaq", "Iverson"
            ]),
        ]),

        Brand(name: "Saucony", models: [
            ShoeModel(name: "Jazz Original", popularColorways: [
                "Silver Navy", "White Blue"
            ]),
            ShoeModel(name: "Shadow 5000", popularColorways: ["Grey Black", "White Black"]),
            ShoeModel(name: "Grid Azura 2000", popularColorways: [
                "Grey Navy", "Blue Green"
            ]),
        ]),

        Brand(name: "On Running", models: [
            ShoeModel(name: "Cloudmonster", popularColorways: ["White Black", "Black", "Cobalt"]),
            ShoeModel(name: "Cloudsurfer", popularColorways: ["Black", "White", "Flame"]),
            ShoeModel(name: "Cloud 5", popularColorways: ["White", "Black", "Midnight"]),
        ]),

        Brand(name: "Other", models: [
            ShoeModel(name: "Custom / Other", popularColorways: []),
        ]),
    ]

    static func models(for brandName: String) -> [ShoeModel] {
        brands.first { $0.name == brandName }?.models ?? []
    }

    static func colorways(for brandName: String, model modelName: String) -> [String] {
        brands.first { $0.name == brandName }?
            .models.first { $0.name == modelName }?
            .popularColorways ?? []
    }

    static var brandNames: [String] { brands.map(\.name) }
}

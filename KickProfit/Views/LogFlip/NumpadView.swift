import SwiftUI

struct NumpadView: View {
    @Binding var value: String
    let maxValue: Double = 9_999_999

    private let keys: [[String]] = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        ["00","0","⌫"],
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { key in
                        Button {
                            handleKey(key)
                        } label: {
                            Text(key)
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.kickSurfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressAnimationStyle())
                    }
                }
            }
        }
    }

    private func handleKey(_ key: String) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        switch key {
        case "⌫":
            if !value.isEmpty { value.removeLast() }
        case "00":
            let candidate = value + "00"
            if (Double(candidate) ?? 0) <= maxValue { value = candidate }
        default:
            if value == "0" { value = key; return }
            let candidate = value + key
            if (Double(candidate) ?? 0) <= maxValue { value = candidate }
        }
    }
}

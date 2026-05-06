import SwiftUI
import QuartzCore

struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            addEmitter(to: view)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func addEmitter(to view: UIView) {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.midX, y: -10)
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
        emitter.emitterShape = .line

        let colors: [UIColor] = [
            UIColor(Color.kickAccent),
            UIColor(Color.kickWarning),
            UIColor.white,
            UIColor(Color.kickGreen),
        ]

        emitter.emitterCells = colors.flatMap { color -> [CAEmitterCell] in
            [makeCell(color: color, isSquare: true), makeCell(color: color, isSquare: false)]
        }

        view.layer.addSublayer(emitter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            emitter.birthRate = 0
        }
    }

    private func makeCell(color: UIColor, isSquare: Bool) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 5
        cell.lifetime = 4
        cell.velocity = CGFloat.random(in: 150...300)
        cell.velocityRange = 60
        cell.emissionRange = .pi / 4
        cell.spin = 3
        cell.spinRange = 6
        cell.scaleRange = 0.2
        cell.scale = 0.1
        cell.color = color.cgColor

        let size: CGFloat = isSquare ? 8 : 6
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        color.setFill()
        if isSquare {
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: size, height: size)).fill()
        } else {
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size)).fill()
        }
        cell.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        return cell
    }
}

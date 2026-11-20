import UIKit

/// Lets touches pass through everywhere except the test panel's own controls.
private final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        if hit === self || hit === rootViewController?.view { return nil }
        return hit
    }
}

/// Test panel: a glass card with a glass switch and slider, shown over SpringBoard.
@objc(LGTestHarness)
public final class LGTestHarness: NSObject {

    private static var window: UIWindow?

    @objc public static func show() {
        guard window == nil else { return }

        let bounds = UIScreen.main.bounds
        let newWindow = PassthroughWindow(frame: bounds)
        newWindow.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue + 100)
        newWindow.backgroundColor = .clear

        let root = UIViewController()
        root.view.backgroundColor = .clear
        newWindow.rootViewController = root
        let host: UIView = root.view

        // Colourful strip behind the card so there is always something to refract
        let strip = UIView(frame: CGRect(x: 0, y: 70, width: bounds.width, height: 260))
        strip.isUserInteractionEnabled = false
        let gradient = CAGradientLayer()
        gradient.frame = strip.bounds
        gradient.colors = [UIColor.systemPink.cgColor, UIColor.systemOrange.cgColor,
                           UIColor.systemTeal.cgColor, UIColor.systemPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        strip.layer.addSublayer(gradient)
        let big = UILabel(frame: strip.bounds)
        big.text = "GLASS"
        big.textAlignment = .center
        big.textColor = UIColor.white.withAlphaComponent(0.9)
        big.font = UIFont.systemFont(ofSize: 90, weight: .heavy)
        big.adjustsFontSizeToFitWidth = true
        strip.addSubview(big)
        host.addSubview(strip)

        // Glass card
        let card = LiquidGlassEffectView(effect: LiquidGlassEffect(style: .regular, isNative: false))
        card.frame = CGRect(x: 20, y: 120, width: bounds.width - 40, height: 170)
        card.layer.cornerRadius = 32
        host.addSubview(card)

        let glassSwitch = LiquidGlassSwitch()
        glassSwitch.frame = CGRect(x: 20, y: 20, width: 63, height: 28)
        card.contentView.addSubview(glassSwitch)

        let slider = LiquidGlassSlider()
        slider.frame = CGRect(x: 20, y: 70, width: card.frame.width - 40, height: 28)
        slider.value = 0.5
        card.contentView.addSubview(slider)

        let captureButton = UIButton(type: .system)
        captureButton.frame = CGRect(x: 14, y: 118, width: 170, height: 36)
        captureButton.setTitle(captureTitle(), for: .normal)
        captureButton.addTarget(LGTestHarness.self, action: #selector(LGTestHarness.toggleCapture(_:)), for: .touchUpInside)
        card.contentView.addSubview(captureButton)

        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: card.frame.width - 84, y: 118, width: 70, height: 36)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(LGTestHarness.self, action: #selector(LGTestHarness.close), for: .touchUpInside)
        card.contentView.addSubview(closeButton)

        newWindow.isHidden = false
        window = newWindow
    }

    private static func captureTitle() -> String {
        return LiquidGlassView.captureMethod == .backdrop ? "Capture: backdrop" : "Capture: rootView"
    }

    @objc static func toggleCapture(_ sender: UIButton) {
        LiquidGlassView.captureMethod = (LiquidGlassView.captureMethod == .backdrop) ? .rootView : .backdrop
        sender.setTitle(captureTitle(), for: .normal)
    }

    @objc static func close() {
        window?.isHidden = true
        window = nil
    }
}

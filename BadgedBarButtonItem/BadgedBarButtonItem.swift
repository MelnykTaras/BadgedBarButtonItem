import UIKit

typealias TapAction = (() -> Void)

final class BadgedBarButtonItem {
    
    // MARK: - Constants: Public
    
    static let BadgedBarButtonItemDidUpdateBadgeStateNotification = "BadgedBarButtonItemDidUpdateBadgeStateNotification"
    
    // MARK: - Variables - Public
    
    var barButtonItem: UIBarButtonItem { return barButton }
    
    // MARK: - Constants: Private
    
    private static let badgeSide: CGFloat = 12
    private static let buttonSide: CGFloat = 28
    
    private let barButton: UIBarButtonItem!
    private let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSide, height: buttonSide))
    private let badgeView = UIView(frame: CGRect(x: 0, y: 0, width: badgeSide, height: badgeSide))
    private let badgeColor = UIColor(red: 0.96, green: 0.1, blue: 0.27, alpha: 1)
    
    // MARK: - Variables: Private
    
    private static var isBadgeHidden = true {
        didSet {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BadgedBarButtonItemDidUpdateBadgeStateNotification)))
        }
    }
    
    private var actionBlock: TapAction?
    
    // MARK: - Initialization
    
    init() {
        badgeView.layer.cornerRadius = badgeView.frame.width / 2
        badgeView.layer.masksToBounds = true
        badgeView.backgroundColor = badgeColor
        button.contentMode = .scaleAspectFill
        button.addSubview(badgeView)
        barButton = UIBarButtonItem(customView: button)
        
        let badgeOffset = BadgedBarButtonItem.badgeSide / 2
        badgeView.frame.origin.x = BadgedBarButtonItem.buttonSide - badgeOffset
        badgeView.frame.origin.y = -BadgedBarButtonItem.badgeSide / 3
        
        setBadgeHidden(BadgedBarButtonItem.isBadgeHidden)
        addBadgeObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialization from Interface Builder is not supported. Please, use init() instead")
    }
    
    // MARK: - Public Setters
    
    func setTapAction(_ block: @escaping TapAction) {
        let actions = button.actions(forTarget: self, forControlEvent: .touchUpInside)
        if actions == nil {
            button.addTarget(self, action: #selector(onTouchUpInside(_:)), for: .touchUpInside)
        }
        self.actionBlock = block
    }
    
    func setImage(_ image: UIImage?, scale: Bool = false, round: Bool = false) {
        var icon = image
        if scale {
            let size = CGSize(width: BadgedBarButtonItem.buttonSide, height: BadgedBarButtonItem.buttonSide)
            icon = image?.scaleImageToSize(newSize: size)
        }
        if round {
            icon = image?.roundedToRadius()
        }
        button.setImage(icon, for: .normal)
        button.sizeToFit()
    }
    
    func setBadgeHidden(_ hidden: Bool) {
        BadgedBarButtonItem.isBadgeHidden = hidden
        badgeView.isHidden = hidden
    }
    
    func setBadgeColor(_ color: UIColor) {
        badgeView.backgroundColor = color
    }
    
    // MARK: - Actions
    
    @objc private func onTouchUpInside(_ sender: UIButton) {
        actionBlock?()
    }
    
    // MARK: - Updating badge on all instances of the class
    
    private func addBadgeObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateBadgeState(_:)),
                                               name: Notification.Name(rawValue: BadgedBarButtonItem.BadgedBarButtonItemDidUpdateBadgeStateNotification),
                                               object: nil)
    }
    
    @objc func updateBadgeState(_ sender: Notification) {
        badgeView.isHidden = BadgedBarButtonItem.isBadgeHidden
    }
}

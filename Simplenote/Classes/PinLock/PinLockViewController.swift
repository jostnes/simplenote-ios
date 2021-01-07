import UIKit

// MARK: - PinLockViewController
//
class PinLockViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var progressView: PinLockProgressView!
    @IBOutlet private var keypadButtons: [UIButton] = []

    private var inputValues: [Int] = [] {
        didSet {
            progressView.progress = inputValues.count
            updateCancelButton()
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private
//
private extension PinLockViewController {
    func setup() {
        view.backgroundColor = .simplenoteLockScreenBackgroudColor
        setupTitleLabel()
        setupMessageLabel()
        setupCancelButton()
        setupProgressView()
        setupKeypadButtons()
    }

    func setupCancelButton() {
        cancelButton.setTitleColor(.white, for: .normal)
        updateCancelButton()
    }

    func setupProgressView() {
        progressView.length = Constants.pinLength
    }

    func setupKeypadButtons() {
        for button in keypadButtons {
            button.setBackgroundImage(UIColor.simplenoteLockScreenButtonColor.dynamicImageRepresentation(), for: .normal)
            button.setBackgroundImage(UIColor.simplenoteLockScreenHighlightedButtonColor.dynamicImageRepresentation(), for: .highlighted)
            button.addTarget(self, action: #selector(handleTapOnKeypadButton(_:)), for: .touchUpInside)
        }
    }

    func setupTitleLabel() {
        titleLabel.text = Localization.enterYourPasscode
    }

    func setupMessageLabel() {
        messageLabel.textColor = .simplenoteLockScreenMessageColor
    }

    func updateCancelButton() {
        cancelButton.setTitle(inputValues.isEmpty ? Localization.cancelButton : Localization.deleteButton,
                              for: .normal)
    }
}

// MARK: - Buttons
//
private extension PinLockViewController {
    @objc
    func handleTapOnKeypadButton(_ button: UIButton) {
        guard let index = keypadButtons.firstIndex(of: button),
              inputValues.count < Constants.pinLength else {
            return
        }

        inputValues.append(index)

    }

    @IBAction
    private func handleTapOnCancelButton() {
        guard !inputValues.isEmpty else {
            return
        }

        inputValues.removeLast()
    }
}

// MARK: - Localization
//
private enum Localization {
    static let enterYourPasscode = NSLocalizedString("Enter your passcode", comment: "Title on the PinLock screen asking to enter a passcode")
    static let deleteButton = NSLocalizedString("Delete", comment: "PinLock screen \"delete\" button")
    static let cancelButton = NSLocalizedString("Cancel", comment: "PinLock screen \"cancel\" button")
}

// MARK: - Constants
//
private enum Constants {
    static let pinLength: Int = 4
}
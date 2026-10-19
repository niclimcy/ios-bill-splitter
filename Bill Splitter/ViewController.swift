//
//  ViewController.swift
//  Bill Splitter
//
//  Created by Nicholas Lim on 15/10/26.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    // MARK: DATA
    private var hasServiceCharge = false
    private var hasGST = false
    private var numPeople = 1
    private var billModel = BillModel(
        billAmount: 0,
        gstEnabled: false,
        serviceEnabled: false,
        partySize: 1,
        roundingStrategy: .none
    )
    private let defaults = UserDefaults()

    private let mainView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Eat Split"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtotalField: UITextField = {
        let textField = UITextField()
        textField.text = CurrencyFormatter.shared.string(from: 0)
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .largeTitle)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.backgroundColor = .secondarySystemBackground
        textField.textAlignment = .center
        return textField
    }()

    private let serviceChargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Service charge (10%)"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let serviceChargeSwitch: UISwitch = {
        let toggle = UISwitch()
        return toggle
    }()

    private let serviceChargeView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let gstLabel: UILabel = {
        let label = UILabel()
        label.text = "GST (9%)"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let gstSwitch: UISwitch = {
        let toggle = UISwitch()
        return toggle
    }()

    private let gstView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let peopleLabel: UILabel = {
        let label = UILabel()
        label.text = "1 people"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let partySizeStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()

    private let partySizeView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let roundingStrategyButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.title = "Rounding: None"
        button.configuration = config
        button.menu = UIMenu(title: "", options: .displayInline)
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private let resultsContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .secondarySystemBackground
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let paynowLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let billAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtotal: "
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let serviceChargeAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Service (10%): "
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let gstAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "GST (9%): "
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total: "
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let partySizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Split Between 1: "
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let roundingStrategyLabel: UILabel = {
        let label = UILabel()
        label.text = "Rounded up by "
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let actionsView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let resetButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .systemRed
        config.buttonSize = .large
        config.background.cornerRadius = 16
        config.title = "Reset"
        button.configuration = config
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.background.cornerRadius = 16
        config.title = "Share"
        button.configuration = config
        return button
    }()

    private let settingsButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 16
        config.background.backgroundColor = .systemGray2
        config.title = "Settings"
        config.image = UIImage(systemName: "gear")
        button.configuration = config
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        updateRoundingMenu()
        updateUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mainView)

        // MARK: Main Stack View
        mainView.addArrangedSubview(headerLabel)
        mainView.addArrangedSubview(subtotalField)
        mainView.addArrangedSubview(serviceChargeView)
        mainView.addArrangedSubview(gstView)
        mainView.addArrangedSubview(partySizeView)
        mainView.addArrangedSubview(roundingStrategyButton)
        mainView.addArrangedSubview(resultsContainerView)
        mainView.addArrangedSubview(actionsView)

        // MARK: Text Field
        subtotalField.delegate = self
        subtotalField.addAction(
            UIAction { [weak self] action in
                guard let self,
                    let textField = action.sender as? UITextField
                else {
                    return
                }

                // Remove all non digits
                let digits = (textField.text ?? "").filter {
                    $0 >= "0" && $0 <= "9"
                }

                // Treat text field as typing in cents
                let cents = Decimal(string: digits) ?? 0
                let amount = cents / 100

                textField.text = CurrencyFormatter.shared.string(from: amount)
                self.billAmountChanged(to: amount)

                let end = textField.endOfDocument
                textField.selectedTextRange = textField.textRange(
                    from: end,
                    to: end
                )
            },
            for: .editingChanged
        )

        // MARK: Service Charge Stack View
        serviceChargeView.addArrangedSubview(serviceChargeLabel)
        serviceChargeView.addArrangedSubview(serviceChargeSwitch)
        serviceChargeSwitch.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.toggleServiceCharge()
            }),
            for: .touchUpInside
        )

        // MARK: GST Stack View
        gstView.addArrangedSubview(gstLabel)
        gstView.addArrangedSubview(gstSwitch)
        gstSwitch.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.toggleGST()
            }),
            for: .touchUpInside
        )

        // MARK: Party Size Stack View
        partySizeView.addArrangedSubview(peopleLabel)
        partySizeView.addArrangedSubview(partySizeStepper)
        partySizeStepper.addAction(
            UIAction(handler: { [weak self] action in
                guard let self,
                    let currentStepper = action.sender as? UIStepper
                else {
                    return
                }

                self.partySizeChanged(to: Int(currentStepper.value))
            }),
            for: .valueChanged
        )

        // MARK: Results Container Stack View
        resultsContainerView.addArrangedSubview(dateLabel)
        resultsContainerView.addArrangedSubview(paynowLabel)
        resultsContainerView.addArrangedSubview(billAmountLabel)
        resultsContainerView.addArrangedSubview(serviceChargeAmountLabel)
        resultsContainerView.addArrangedSubview(gstAmountLabel)
        resultsContainerView.addArrangedSubview(totalAmountLabel)
        resultsContainerView.addArrangedSubview(partySizeLabel)
        resultsContainerView.addArrangedSubview(roundingStrategyLabel)

        // MARK: Actions Stack View
        actionsView.addArrangedSubview(resetButton)
        actionsView.addArrangedSubview(shareButton)
        resetButton.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.reset()
            }),
            for: .touchUpInside
        )
        shareButton.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self,
                    let image = self.snapshotResultsCard()
                else {
                    return
                }

                let viewController = UIActivityViewController(
                    activityItems: [
                        ShareableImage(
                            image: image,
                            title:
                                "Our split today @ \(Date.now.formatted(date: .abbreviated, time: .omitted))"
                        )
                    ],
                    applicationActivities: nil
                )

                present(viewController, animated: true)
            }),
            for: .touchUpInside
        )

        // MARK: Settings button
        mainView.addArrangedSubview(settingsButton)
        settingsButton.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                
                let vc = SettingsViewController()
                vc.modalPresentationStyle = .pageSheet
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                }
                present(vc, animated: true)
            }),
            for: .touchUpInside
        )
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),
            mainView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),
            mainView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
        ])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func updateUI() {
        billAmountLabel.text =
            "Subtotal: \(CurrencyFormatter.shared.string(from: billModel.billAmount))"
        serviceChargeAmountLabel.text =
            "Service (10%): \(CurrencyFormatter.shared.string(from: billModel.serviceChargeAmount))"
        gstAmountLabel.text =
            "GST (9%): \(CurrencyFormatter.shared.string(from: billModel.gstAmount))"
        totalAmountLabel.text =
            "Total: \(CurrencyFormatter.shared.string(from: billModel.totalAmount))"
        partySizeLabel.text =
            "Split Between \(billModel.partySize): \(CurrencyFormatter.shared.string(from: billModel.displayPerPerson))"

        switch billModel.roundingStrategy {
        case .none:
            roundingStrategyLabel.isHidden = true
        default:
            roundingStrategyLabel.isHidden = false
            let roundedBy =
                billModel.perPersonAmount - billModel.displayPerPerson
            if roundedBy > 0 {
                roundingStrategyLabel.text =
                    "Rounded down by \(CurrencyFormatter.shared.string(from: roundedBy))."
            } else {
                roundingStrategyLabel.text =
                    "Rounded up by \(CurrencyFormatter.shared.string(from: roundedBy.magnitude))."
            }
        }
    }

    private func updateRoundingMenu() {
        let options: [(title: String, strategy: RoundingStrategy)] = [
            ("None", .none),
            ("Nearest dollar", .roundToNearestDollar),
            ("Up to next dollar", .roundUp),
        ]

        let actions = options.map { option in
            UIAction(
                title: option.title,
                state: billModel.roundingStrategy == option.strategy
                    ? .on : .off
            ) { [weak self] _ in
                self?.roundingStrategyChanged(to: option.strategy)
            }
        }

        roundingStrategyButton.menu = UIMenu(children: actions)

        if let selected = options.first(where: {
            $0.strategy == billModel.roundingStrategy
        }) {
            roundingStrategyButton.configuration?.title =
                "Rounding: \(selected.title)"
        }
    }

    private func billAmountChanged(to billAmount: Decimal) {
        billModel.billAmount = billAmount
        updateUI()
    }

    private func toggleServiceCharge() {
        billModel.serviceEnabled.toggle()
        updateUI()
    }

    private func toggleGST() {
        billModel.gstEnabled.toggle()
        updateUI()
    }

    private func partySizeChanged(to partySize: Int) {
        billModel.partySize = partySize
        peopleLabel.text = "\(partySize) people"
        updateUI()
    }

    private func roundingStrategyChanged(to strategy: RoundingStrategy) {
        billModel.roundingStrategy = strategy
        updateRoundingMenu()
        updateUI()
    }

    private func snapshotResultsCard() -> UIImage? {
        dateLabel.text = Date.now.formatted(date: .long, time: .standard)
        dateLabel.isHidden = false
        let paynow = defaults.string(forKey: "paynow") ?? ""
        if !paynow.isEmpty {
            paynowLabel.text = "O$P$: \(paynow)"
            paynowLabel.isHidden = false
        }

        defer {
            dateLabel.isHidden = true
            dateLabel.text = ""
            paynowLabel.isHidden = true
            paynowLabel.text = ""
            view.layoutIfNeeded()
        }

        view.layoutIfNeeded()

        return UIGraphicsImageRenderer(bounds: resultsContainerView.bounds)
            .image { context in
                resultsContainerView.drawHierarchy(
                    in: resultsContainerView.bounds,
                    afterScreenUpdates: true
                )
            }
    }

    private func reset() {
        billModel.partySize = 1
        billModel.billAmount = 0
        billModel.gstEnabled = false
        billModel.serviceEnabled = false
        billModel.roundingStrategy = .none
        subtotalField.text = CurrencyFormatter.shared.string(from: 0)

        updateRoundingMenu()
        updateUI()
    }
}

#Preview {
    ViewController()
}

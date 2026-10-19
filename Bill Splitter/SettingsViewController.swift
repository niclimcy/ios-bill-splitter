//
//  SettingsViewController.swift
//  Bill Splitter
//
//  Created by Nicholas Lim on 15/10/26.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
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
        label.text = "Settings"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let paynowLabel: UILabel = {
        let label = UILabel()
        label.text = "Paynow"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let paynowField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = .preferredFont(forTextStyle: .body)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()

    private let paynowView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mainView)

        mainView.addArrangedSubview(headerLabel)
        mainView.addArrangedSubview(paynowView)

        // MARK: Paynow view
        paynowView.addArrangedSubview(paynowLabel)
        paynowView.addArrangedSubview(paynowField)
        paynowField.delegate = self
        paynowField.text = defaults.string(forKey: "paynow") ?? ""
        paynowField.addAction(
            UIAction(handler: { [weak self] action in
                guard let self,
                    let textField = action.sender as? UITextField
                else {
                    return
                }

                defaults.set(textField.text, forKey: "paynow")

            }),
            for: .editingChanged
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
                constant: 32
            ),
        ])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

#Preview {
    SettingsViewController()
}

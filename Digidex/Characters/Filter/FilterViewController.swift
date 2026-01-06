//
//  FilterViewController.swift
//  RickAndMorty
//

import UIKit

class FilterViewController: UIViewController {

    var delegate: ReceivedFilterData?

    @IBOutlet weak var statusTextField: UITextField!   
    @IBOutlet weak var speciesTextField: UITextField!  
    @IBOutlet weak var genderTextField: UITextField!   
    @IBOutlet weak var applyButton: UIButton!

    private let levelField = UITextField()
    private let fieldField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        statusTextField.placeholder = "Name (optional)"
        speciesTextField.placeholder = "Type (optional)"
        genderTextField.placeholder = "Attribute (optional)"

        setupExtraFields()
    }

    private func setupExtraFields() {
        levelField.borderStyle = .roundedRect
        fieldField.borderStyle = .roundedRect
        levelField.placeholder = "Level (optional)"
        fieldField.placeholder = "Field (optional)"
        levelField.translatesAutoresizingMaskIntoConstraints = false
        fieldField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(levelField)
        view.addSubview(fieldField)

        NSLayoutConstraint.activate([
            levelField.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: 12),
            levelField.leadingAnchor.constraint(equalTo: genderTextField.leadingAnchor),
            levelField.trailingAnchor.constraint(equalTo: genderTextField.trailingAnchor),

            fieldField.topAnchor.constraint(equalTo: levelField.bottomAnchor, constant: 12),
            fieldField.leadingAnchor.constraint(equalTo: levelField.leadingAnchor),
            fieldField.trailingAnchor.constraint(equalTo: levelField.trailingAnchor),

            applyButton.topAnchor.constraint(greaterThanOrEqualTo: fieldField.bottomAnchor, constant: 16)
        ])
    }

    @IBAction func applyTapped(_ sender: UIButton) {
        delegate?.filterData(
            name: statusTextField.text ?? "",
            type: speciesTextField.text ?? "",
            attribute: genderTextField.text ?? "",
            level: levelField.text ?? "",
            field: fieldField.text ?? ""
        )
        dismiss(animated: true)
    }
}

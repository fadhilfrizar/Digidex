//
//  DetailCharacterController.swift
//  RickAndMorty
//

import UIKit

class DetailCharacterController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!

    var digimonID: Int = -1
    var viewModel: CharactersViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"

        nameLabel.text = "-"
        infoTextView.text = ""

        loadDetail()
    }

    private func loadDetail() {
        guard digimonID != -1 else { return }

        viewModel?.fetchDetail(id: digimonID) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                switch result {
                case .success(let d):
                    self.title = d.name
                    self.nameLabel.text = d.name
                    self.imageView.loadImage(from: d.image)

                    func join(_ arr: [String]) -> String { arr.isEmpty ? "-" : arr.joined(separator: ", ") }

                    self.infoTextView.text =
                    """
                    Attribute: \(join(d.attributes))
                    Level: \(join(d.levels))
                    Type: \(join(d.types))
                    Fields: \(join(d.fields))
                    """

                case .failure(let err):
                    self.infoTextView.text = err.localizedDescription
                }
            }
        }
    }
}

//
//  CharactersListController.swift
//  RickAndMorty
//

import UIKit
import FittedSheets

private let reuseIdentifier = "characterCell"

protocol ReceivedFilterData {
    func filterData(name: String, type: String, attribute: String, level: String, field: String)
}

class CharactersListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var viewModel: CharactersViewModel?

    var digimons: [DigimonResult] = []
    var filtered: [DigimonResult] = []
    var searchActive = false

    var refreshControl = UIRefreshControl()

    var currentPage = 0
    var isLoading = false

    // filters
    var query: String = ""
    var type: String = ""
    var attribute: String = ""
    var level: String = ""
    var field: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        self.navigationItem.title = "Digimon"

        viewModel?.onCharactersLoad = { [weak self] items in
            guard let self else { return }

            // Client-side filtering fallback for type/field if list payload doesn’t support it
            let postFiltered = items.filter { d in
                let typeOK = self.type.isEmpty ? true : d.types.contains(where: { $0.lowercased() == self.type.lowercased() })
                let fieldOK = self.field.isEmpty ? true : d.fields.contains(where: { $0.lowercased() == self.field.lowercased() })
                return typeOK && fieldOK
            }

            self.digimons.append(contentsOf: postFiltered)

            // If search active, also update filtered
            self.filtered = self.digimons
            self.collectionView.reloadData()
            self.isLoading = false
        }

        viewModel?.onCharactersError = { [weak self] error in
            self?.handle(error) { [weak self] in
                self?.fetchDigimon(page: self?.currentPage ?? 0)
            }
        }

        viewModel?.onCharactersLoading = { [weak self] isLoading in
            if isLoading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
    }

    private func fetchDigimon(page: Int) {
        viewModel?.fetchCharacters(
            pages: page,
            query: query,
            type: type,
            attribute: attribute,
            level: level,
            field: field
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.digimons.isEmpty {
            fetchDigimon(page: currentPage)
        }
    }

    @objc private func refresh(_ sender: Any) {
        currentPage = 0
        digimons.removeAll()
        filtered.removeAll()
        fetchDigimon(page: currentPage)
    }

    @objc func filterCharacter(_ sender: UIButton) {
        let vc = FilterViewController(nibName: "FilterViewController", bundle: nil)
        vc.delegate = self
        let sheetController = SheetViewController(controller: vc, sizes: [.percent(0.75), .fullscreen])
        self.present(sheetController, animated: true)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchActive ? filtered.count : digimons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterCell

        let item = searchActive ? filtered[indexPath.row] : digimons[indexPath.row]
        let vm = CharactersItemViewModel(characters: item)
        cell.configure(vm)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchActive ? filtered[indexPath.row] : digimons[indexPath.row]

        let vc = DetailCharacterController(nibName: "DetailCharacterController", bundle: nil)
        vc.digimonID = item.id
        vc.viewModel = viewModel
        show(vc, sender: self)
    }

    // Infinite scroll, unlimited
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let last = digimons.count - 1
        if indexPath.row == last {
            guard !isLoading else { return }
            isLoading = true
            currentPage += 1
            fetchDigimon(page: currentPage)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.view.frame.width / 2 - 16, height: 250)
    }
}

extension CharactersListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        if text.isEmpty {
            searchActive = false
            query = ""
            filtered = digimons
        } else {
            query = text
            searchActive = true
            // local filter for instant feedback (server call happens on refresh / paging)
            filtered = digimons.filter { $0.name.range(of: text, options: [.caseInsensitive]) != nil }
        }

        collectionView.reloadData()
    }
}

extension CharactersListController: ReceivedFilterData {
    func filterData(name: String, type: String, attribute: String, level: String, field: String) {
        self.query = name
        self.type = type
        self.attribute = attribute
        self.level = level
        self.field = field

        // reset list
        currentPage = 0
        digimons.removeAll()
        filtered.removeAll()
        fetchDigimon(page: currentPage)
    }
}

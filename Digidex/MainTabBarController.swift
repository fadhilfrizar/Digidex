//
//  MainTabBarController.swift
//  RickAndMorty
//

import UIKit

class MainTabBarController: UITabBarController {

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    private lazy var baseURL = URL(string: "https://digi-api.com/api/v1")!

    var pages: Int = 0 
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.setupViewController()
    }

    private func setupViewController() {
        viewControllers = [
            makeNavWithLargeTitle(for: makeCharacterList(), title: "Digimon", icon: "square.grid.2x2.fill")
        ]
    }

    private func makeNavWithLargeTitle(for vc: UIViewController, title: String, icon: String) -> UIViewController {
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.navigationItem.hidesSearchBarWhenScrolling = false

        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        nav.tabBarItem.title = title
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }

    private func makeCharacterList() -> CharactersListController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)

        let vc = CharactersListController(collectionViewLayout: layout)
        vc.title = "Digimon"

        let image = UIImage(systemName: "slider.horizontal.3", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: vc, action: #selector(vc.filterCharacter))

        let searchController = UISearchController(searchResultsController: nil)
        vc.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = vc

        vc.viewModel = CharactersViewModel(
            service: MainQueueDispatchDecorator(
                decoratee: CharacterServiceAPI(
                    url: CharacterEndpoint.get(page: pages, pageSize: 8).url(baseURL: baseURL),
                    client: httpClient
                )
            )
        )

        return vc
    }
}

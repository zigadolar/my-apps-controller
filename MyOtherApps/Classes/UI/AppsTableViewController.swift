//
//  AppsTableViewController.swift
//  MyOtherApps
//
//  Created by Dolar, Ziga on 7/23/19.
//

import UIKit

import StoreKit

public protocol AppsViewControllerDelegate: AnyObject {
    func appsViewController(_ viewController: UIViewController, didSelect app: App)
}

public final class AppsTableViewController: UITableViewController {

    public weak var delegate: AppsViewControllerDelegate?

    public var shouldFilterCurrentApp: Bool = true

    private var apps: [App] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?._appSets = nil
                self?.tableView.reloadData()
            }
        }
    }

    private var utility: AppsUtility!

    private var _appSets: [AppsSet]?
    var appSets: [AppsSet] {
        if _appSets == nil {
            let appCategories: [String: [App]] = apps.reduce(into: [:]) { result, app in
                let category = app.type.description

                var appsArray = result[category] ?? []
                appsArray.append(app)

                result[category] = appsArray
            }

            _appSets = appCategories.map { AppsSet(name: $0.key, apps: $0.value) }.sorted { $0.name < $1.name }
        }

        return _appSets ?? []
    }

    public static func load(with itunesId: String) -> AppsTableViewController? {
        return load(with: AppsUtility(with: itunesId))
    }

    public static func load(with lookupUrl: URL, responseParsingHandler: @escaping ((Data) -> [App])) -> AppsTableViewController? {
        return load(with: AppsUtility(with: lookupUrl, responseParsingHandler: responseParsingHandler))
    }

    private static func load(with utility: AppsUtility) -> AppsTableViewController? {
        let storyboard = UIStoryboard(name: "AppsUtility", bundle: Bundle.resourceBundle(for: self.classForCoder()))
        guard let controller = storyboard.instantiateViewController(withIdentifier: "AppsTableViewController") as? AppsTableViewController else {
                return nil
        }

        controller.utility = utility

        return controller
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: .zero)
        navigationItem.title = "My Other Apps"

        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(closeButtonTapped(_:)))
        
        navigationItem.rightBarButtonItem = closeButtonItem
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        utility.fetch { [weak self] apps in
            guard let self = self else {
                return
            }

            if self.shouldFilterCurrentApp {
                let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
                self.apps =  apps.filter { $0.bundleIdentifier.lowercased() != bundleId?.lowercased() }
            } else {
                self.apps = apps
            }
        }
    }

    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return appSets.count
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return appSets[section].name
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appSets[section].apps.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AppsTableViewCell", for: indexPath) as? AppsTableViewCell {

            let app = appSets[indexPath.section].apps[indexPath.row]
            cell.configure(with: app)

            return cell
        }

        return UITableViewCell()
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let app = appSets[indexPath.section].apps[indexPath.row]

        let controller = SKStoreProductViewController()
        controller.delegate = self
        controller.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: app.identifier)])

        delegate?.appsViewController(self, didSelect: app)

        present(controller, animated: true)
    }
}

extension AppsTableViewController: SKStoreProductViewControllerDelegate {
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true)
    }
}

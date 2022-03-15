//
//  AlbumViewController.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 27/02/2021.
//
import UIKit
class AlbumViewController: BaseViewController, UISearchBarDelegate {
    // MARK: - Connections
    @IBOutlet weak var albumTableView: UITableView!
    // MARK: - Variables
    var viewModel: UserViewModal?
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    var dropDownButton: DropDownBtn?
    var xOfrightNav: CGFloat = 0
    var isSearching = false
    var isAscending: AlbumSortState = .ascending
    var sections: [AlbumSectionModel] = [] {
        didSet {
            if sections.count == 0 {
                self.albumTableView.setEmptyMessage("Album is not available", with: UIImage(named: "not-found"))
            } else {
                self.albumTableView.backgroundView = nil
            }
        }
    }
    var sectionsBackup: [AlbumSectionModel] = []
    // MARK: - Views Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        fetchAlbums()
    }
    // MARK: - IBactions
    @objc func searchButtonTapped() {
        isSearching = !isSearching
        guard isSearching == true else {
            hideSearchBar()
            return
        }
        dismissDropDown()
        self.showSearchBar()
    }
    @objc func filterButtonTapped() {
        hideSearchBar()
        // closing `DropDown` if already showing
        if  dropDownButton != nil {
            dismissDropDown()
            return
        }
        prepareDropdown()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.sections = self.sectionsBackup
            albumTableView.reloadWithAnimation()
            return
        }
        self.viewModel?.searchInAlbum(searchText, albums: self.sectionsBackup) { [weak self] albums in
            self?.sections = albums
            self?.albumTableView.reloadWithAnimation()
        }
    }
}
// MARK: - Custom functions
extension AlbumViewController {
    fileprivate func setupNavBar() {
        self.extendedLayoutIncludesOpaqueBars = true
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchButton = UIBarButtonItem(image: searchImage,
                                           style: .plain,
                                           target: self,
                                           action: #selector(searchButtonTapped))
        let filterImage = UIImage(systemName: "line.horizontal.3.decrease.circle")
        let filterButton = UIBarButtonItem(image: filterImage,
                                           style: .plain,
                                           target: self,
                                           action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItems = [filterButton, searchButton]
    }
    
    
    /// preparing necessary views 
    func setupViews() {
        self.title = "Albums"
        viewModel = UserViewModal()
        self.albumTableView.register(UINib(nibName: Constants.Cells.albumCellIdentifier, bundle: nil),
                                     forCellReuseIdentifier: Constants.Cells.albumCellIdentifier)
        xOfrightNav = self.view.frame.size.width - 110
        self.searchBar = UISearchBar(frame: CGRect(x: xOfrightNav, y: 0, width: 30, height: 44))
        self.searchBar.placeholder = "Search album"
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    /// Setting up Search bar with frame to animte it
    fileprivate func showSearchBar() {
        UIView.animate(withDuration: 0.5) {
            self.searchBar.frame = CGRect(x: 0, y: 0, width: 300, height: 20)
            self.searchBar.transform = .identity
            self.searchBar.alpha = 1
        }
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: true)
        self.searchBar.becomeFirstResponder()
    }
    fileprivate func hideSearchBar() {
        UIView.animate(withDuration: 0.5) {
            self.searchBar.transform = CGAffineTransform(translationX: self.xOfrightNav, y: 0)
            self.searchBar.alpha = 0
        }completion: { _ in
            self.searchBar.frame =  CGRect(x: self.xOfrightNav, y: 0, width: 30, height: 20)
            self.navigationItem.titleView = nil
            self.searchBar.resignFirstResponder()
        }
    }
    /// Preparing DropDown menu to sort based on album ids
    func prepareDropdown() {
        dropDownButton = DropDownBtn()
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(dropDownButton!)
        dropDownButton?.translatesAutoresizingMaskIntoConstraints = false
        dropDownButton?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        dropDownButton?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        dropDownButton?.widthAnchor.constraint(equalToConstant: 170).isActive = true
        dropDownButton?.heightAnchor.constraint(equalToConstant: 0).isActive = true
        dropDownButton?.layer.shadowPath = UIBezierPath(rect: dropDownButton!.bounds).cgPath
        dropDownButton?.dropView.delegate = self
        dropDownButton?.showDropDownMenu()
        dropDownButton?.backgroundColor = UIColor.red
    }
    
    /// Request to fetch Albums to populate in tbaleview
    func fetchAlbums() {
        guard Reachability.isConnectedToNetwork else {
            self.albumTableView.setEmptyMessage("Please connect to internet", with: UIImage(named: "noWifi"))
            return
        }
        self.showProgress()
        viewModel?.getAlbums(with: Constants.Apis.albumUrl, completion: { [weak self] (albums: [AlbumModel]) in
            self?.viewModel?.prepareDataSource(albums: albums, completion: { [weak self] (sections) in
                self?.hideProgress()
                self?.sections = sections
                self?.sectionsBackup = sections
                self?.albumTableView.reloadWithAnimation()
            })
        })
    }
    func dismissDropDown() {
        self.dropDownButton?.dismissDropDown()
        self.dropDownButton?.removeFromSuperview()
        self.dropDownButton = nil
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideSearchBar()
    }
}
// MARK: - TableView Delegates
extension AlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        header.titleLabel.text = "Albums # \(sections[section].id)"
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.albumCellIdentifier) as? AlbumTableViewCell else { return UITableViewCell() }
        let album = sections[indexPath.section].items[indexPath.row]
        cell.populate(with: album)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = sections[indexPath.section].items[indexPath.row]
    }
}
// MARK: - Section Header Delegate
extension AlbumViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        albumTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
// MARK: - Sorting Drow
extension AlbumViewController: dropDownDelegate {
    func dropDownPressed(string: String, sortyBy: AlbumSortState) {
        dismissDropDown()
        guard isAscending != sortyBy else {return }
        isAscending = sortyBy
        sections.reverse()
        if !isSearching {
            self.sectionsBackup = self.sections
        }
        self.albumTableView.reloadWithAnimation()
    }
}


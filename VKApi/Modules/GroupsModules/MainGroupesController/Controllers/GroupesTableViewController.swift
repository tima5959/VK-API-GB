//
//  GroupesTableViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class GroupesTableViewController: UITableViewController {
    
    // Значение nil, говорит что результаты поиска будут отображены на самом Контроллере
    // Если мы хотим показывать результаты на другом контроллере, то вместо nil нужно установить другой контроллер
    let searchController = UISearchController(searchResultsController: nil)
    
    private let storageManager = RealmService()
    private let networkService = NetworkService()
    private var notificationToken: NotificationToken?
    private var model: Results<Groups>?
    private var groups: [Groups] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self,
                                  action: #selector(refreshFunc),
                                  for: .allEvents)
        tableView.refreshControl = refreshControll
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 1 Информирует о любых тектовых изменениях
        searchController.searchResultsUpdater = self
        
        // 2 Скрывает вью для отображения другого контроллера с результатами
        // В нашем случае результаты отображает сам вьюконтроллер
        // Поэтому значение установлено false, чтобы не скрывать наш контроллер
        searchController.obscuresBackgroundDuringPresentation = false
        
        // 3 Здесь мы устанавливаем плейсхолдер текстфилду
        searchController.searchBar.placeholder = "Search Users"
        
        // 4 New for iOS 11, you add the searchBar to the navigationItem. This is necessary because Interface Builder is not yet compatible with UISearchController.
        // 4 Новое в iOS 11 мы добавляем searchBar в панельНавигации. Этого еще нет в сторибордах
        navigationItem.searchController = searchController
        
        // 5 Значение truе гарантирует, что панель поиска не останется на экране, если пользователь переходит к другому вьюКонтроллеру, пока активен UISearchController.
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNotificationToken()
        
        networkService.getLoadGroups(handler: { [weak self] community in
            self?.groups = community
            self?.tableView.reloadData()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    func setNotificationToken() {
        model = try? storageManager.fetchByRealm(items: Groups.self)
        notificationToken = model?.observe { changes in
            switch changes {
            case .initial(_):
                self.storageManager.fetchGroups()
                self.tableView.reloadData()
            case .update(_, _, _, _):
                self.storageManager.fetchGroups()
                self.tableView.reloadData()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source
    @objc func refreshFunc() {
        networkService.getLoadGroups(handler: { [weak self] community in
            self?.groups = community
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            self?.tableView.refreshControl?.endRefreshing()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupMainCell", for: indexPath) as! GroupesTableViewCell
        
        let group = groups[indexPath.row]
        cell.groupNamedLabel.text = group.name
//        cell.imageViewOutlet.image = networkService.setPhoto(atIndexPath: indexPath, byUrl: group.avatarURL)
        cell.imageViewOutlet.kf.setImage(with: URL(string: group.avatarURL), options: [
            .transition(.fade(0.5))
        ])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
       
        }
    }
}

extension GroupesTableViewController: UISearchResultsUpdating {
    // isSearchBarEmpty возвращает true, если текст, введенный в строке поиска, пуст; в противном случае возвращается false.
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Вычисляемое свойство, определяющее, фильтруете ли вы в настоящее время результаты или нет
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // filterContentFor(_ searchText: String) фильтрует группы на основе searchText и помещает результаты в фильтр filteredGroups
    func filterContentFor(_ searchText: String) {
        networkService.findGroups(searchText) { [weak self] communities in
            self?.groups = communities
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        tableView.reloadData()
    }
    
    // Теперь всякий раз, когда пользователь добавляет или удаляет текст в строке поиска, UISearchController будет информировать класс FriendsTableViewController об изменении посредством вызова updateSearchResults(for:), который, в свою очередь, вызывает filterContentFor(_ searchText:).
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentFor(searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.isUserInteractionEnabled = false
    }
    
    
}

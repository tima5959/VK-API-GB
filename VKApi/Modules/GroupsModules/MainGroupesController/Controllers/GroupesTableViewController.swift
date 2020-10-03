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
    private var filteredGroups = [Groups]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Группы"
        
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
        searchController.searchBar.placeholder = "Поиск групп"
        
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
    
    // Установил наблюдателя за моделью в базе данных
    // В случае изменения база данных сама обновит таблицу
    private func setNotificationToken() {
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
    
    // При оттягивании таблицы внизу будет повторно отправлен запрос
    @objc func refreshFunc() {
        networkService.getLoadGroups() { [weak self] community in
            self?.groups = community
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Table view data source
extension GroupesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGroups.count
        }
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupMainCell", for: indexPath) as! GroupesTableViewCell
        
        let groupModel: Groups
        
        if isFiltering {
            groupModel = filteredGroups[indexPath.row]
        } else {
            groupModel = groups[indexPath.row]
        }

        cell.groupNamedLabel.text = groupModel.name
        fetchAvatar(groupModel, cell)
        return cell
//        cell.imageViewOutlet.kf.setImage(with: URL(string: group.avatarURL), options: [
//            .transition(.fade(0.5))
//        ])
    }
    
    private func fetchAvatar(_ model: Groups,
                             _ cell: GroupesTableViewCell) {
        networkService.fetchAndCachedPhoto(
            from: model.avatarURL) { image in
            cell.imageViewOutlet.image = image
        } completionError: { error in
            cell.imageViewOutlet.image = UIImage(named: "")
        }
    }
}


// MARK: - UISerchBar
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
        filteredGroups = groups.filter { group -> Bool in
            return group
                .name
                .lowercased()
                .contains(searchText.lowercased())
        }
//        networkService.findGroups(searchText) { [weak self] communities in
//            self?.groups = communities
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
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

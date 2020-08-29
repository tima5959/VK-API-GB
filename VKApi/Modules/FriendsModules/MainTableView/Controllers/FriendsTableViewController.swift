//
//  FriendsTableViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    let networkManager = NetworkService()
    let storageManager = RealmService()
    
    private let searchController = UISearchController(searchResultsController: nil)
    // Значение nil, говорит что результаты поиска будут отображены на самом Контроллере
    // Если мы хотим показывать результаты на другом контроллере, то вместо nil нужно установить другой контроллер
    
    private var notificationToken: NotificationToken?
    
    private let cellIdentifire = "cell"
    private let segueIdentifire = "detailFriendsTableViewSegue"
    
    private let realm = try! Realm()
    private var friends = [Friend]()
    private var users: Results<Friend>?
    private var filteredUsers: Results<Friend>?
    
    private var sortedFirstLetters: [String] = []
    private var sections: [[Friend]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNotificationToken()
        
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
    }
    
    @IBAction func addFriend(_ sender: UIBarButtonItem) {
        addAndEditFirends(title: "Add",
                          message: "Add new friend",
                          placeholder: "Name") {
        }
    }
    
    private func setFirstLetters() {
        // Проверяю Realm<Result>
        guard let users = self.users else { return }
        // Фильтрую друзей по имени и проверяю на nil
        let filteredFriends = users.filter { !$0.firstName.isEmpty }
        // Добавляю в массив типа [Friend] отфильтрованных по имени друзей
        self.friends = Array(filteredFriends)
        // Передаю в функцию модели Friends массив отфильтрованных по имени друзей
        // Чтобы получить первую букву их имени
        let firstLetters = friends.map { $0.titleFirstLetter }
        // Убираю повторяющиеся буквы
        let uniqueFirstLetters = Array(Set(firstLetters))
        // Сортирую буквы
        sortedFirstLetters = uniqueFirstLetters.sorted()
        // Добавляю в [[sections]] буквы
        // Возвращаю [Friend] отфильрованный по этим буквам
        // Возвращаю [Friend] отсортированный от А до Я || от A до Z
        sections = sortedFirstLetters.map { firstLetter in
            return friends.filter { $0.titleFirstLetter == firstLetter }.sorted { $0.firstName < $1.firstName }
        }
        self.tableView.reloadData()
    }
    
    private func setNotificationToken() {
        users = try? storageManager.fetchByRealm(items: Friend.self)
        setFirstLetters()
        notificationToken = users?.observe { changes in
            switch changes {
            case .initial(_):
                self.storageManager.fetchFriends()
                self.setFirstLetters()
            case .update(_, _, _, _):
                self.storageManager.fetchFriends()
                self.setFirstLetters()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FriendsTableViewCell else { return UITableViewCell() }
        
        let model = sections[indexPath.section][indexPath.row]
        
        cell.nameLabel.text = model.firstName + " " + model.lastName
        cell.avatarImageView.image = networkManager.setPhoto(atIndexPath: indexPath,
                                                             byUrl: model.avatarURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Sections
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sortedFirstLetters[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sortedFirstLetters
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
        }
    }
    
    // MARK: - Navigation
    // При использовании сторибордов, необходимо подготовить переход (передача данных)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "detailFriendsTableViewSegue" else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        if let friend = users?[indexPath.row] {
            let friendsDetailVC = segue.destination as! FriendsDetailCollectionViewController
            friendsDetailVC.navigationController?.title = friend.firstName + " " + friend.lastName
            friendsDetailVC.ownerID = friend.id
            friendsDetailVC.users.append(friend)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.indexPathForSelectedRow {
            performSegue(withIdentifier: "detailFriendsTableViewSegue", sender: nil)
        }
    }
}

// MARK: - Alert Controller
extension FriendsTableViewController {
    func addAndEditFirends(title: String,
                           message: String,
                           placeholder: String,
                           completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        alert.addTextField { taskName in
            alertTextField = taskName
            alertTextField.layoutIfNeeded()
            alertTextField.autocorrectionType = .default
            alertTextField.autocapitalizationType = .sentences
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive,
                                         handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.view.layoutIfNeeded()
        present(alert, animated: true)
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension FriendsTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // isSearchBarEmpty возвращает true, если текст, введенный в строке поиска, пуст; в противном случае возвращается false.
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Вычисляемое свойство, определяющее, фильтруете ли вы в настоящее время результаты или нет
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    // filterContentFor(_ searchText: String) фильтрует пользователей на основе searchText и помещает результаты в фильтр filteredUsers
    func filterContentFor(_ searchText: String) {
        filteredUsers = realm.objects(Friend.self).filter("firstName")
        
        //        filteredUsers = friends.filter { users -> Bool in
        //            return users.firstName.contains(searchText.lowercased())
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

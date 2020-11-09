//
//  FriendsTableViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class FriendsTableViewController: UITableViewController {
    
    let networkService = NetworkService()
    let storageManager = RealmService()
    
    private let searchController = UISearchController(searchResultsController: nil)
    // Значение nil, говорит что результаты поиска будут отображены на самом Контроллере
    // Если мы хотим показывать результаты на другом контроллере, то вместо nil нужно установить другой контроллер
    
    private var notificationToken: NotificationToken?
    
    private let cellIdentifire = "cell"
    private let segueIdentifire = "detailFriendsTableViewSegue"
    
    private let realm = try! Realm()
    private var friends = [Friend]()
    private var filteredFriends = [Friend]()
    private var realmResultFriend: Results<Friend>!
    
//    private var sortedFirstLettersString: [String] = []
//    private var sortedFirstLettersAndFriends: [[Friend]] = [[]]

    private var groupedFriends = [Character: [Friend]]()
    private var sortedFirstLetters: [Character] {
        get {
            groupedFriends.keys.sorted()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Друзья"
        
        setNotificationToken()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 1 Информирует о любых тектовых изменениях
        searchController.searchResultsUpdater = self
        
        // 2 Скрывает вью для отображения другого контроллера с результатами
        // В нашем случае результаты отображает сам вьюконтроллер
        // Поэтому значение установлено false, чтобы не скрывать наш контроллер
        searchController.obscuresBackgroundDuringPresentation = false
        
        // 3 Здесь мы устанавливаем плейсхолдер текстфилду
        searchController.searchBar.placeholder = "Поиск друзей"
        
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
    
    private func sortingFriendsByName(_ searchText: String?,
                                      _ friends: [Friend]) -> [Character: [Friend]] {
        let friend: [Friend]
        // Проверяю на нил приходящий текст
        // И если текст имеется то фильтрую массив друзей по имени которое содержит приходящий текст
        if let text = searchText, searchText != "" {
            friend = friends.filter { $0.firstName.lowercased().contains(text) || $0.lastName.lowercased().contains(text) }
        } else {
            friend = friends
        }
        
        // Перевожу массив друзей в словарь где ключ = Первая буква имен, значение = друзья по именем начинающимся на эту букву
        // За это отвечает метод словара grouping
        // .mapValues сортирует имена внутри групп от меньшего к большему
        let friendsDict = Dictionary.init(grouping: friend) {
            $0.firstName.lowercased().first ?? "#"
        }.mapValues {
            $0.sorted {
                $0.firstName.lowercased() < $1.firstName.lowercased()
            }
        }
        return friendsDict
    }

    private func setFriends() {
        // Проверяю Realm<Result>
        guard let users = self.realmResultFriend else { return }
        // Фильтрую друзей по имени и проверяю на nil
        let filteredFriends = users.filter { !$0.firstName.isEmpty }
        // Добавляю в массив типа [Friend] отфильтрованных по имени друзей
        friends = Array(filteredFriends)
        
        groupedFriends = sortingFriendsByName(nil, friends)
        tableView.reloadData()
    }
    
    private func setNotificationToken() {
        realmResultFriend = try? storageManager.fetchByRealm(items: Friend.self)
        setFriends()
        notificationToken = realmResultFriend?.observe { changes in
            switch changes {
            case .initial(_):
                self.storageManager.fetchFriends()
                self.setFriends()
            case .update(_, _, _, _):
                self.storageManager.fetchFriends()
                self.setFriends()
            case .error(let error):
                print(error.localizedDescription)
                
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    // При использовании сторибордов, необходимо подготовить переход (передача данных)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailFriendsTableViewSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let friendsDetailVC = segue.destination as! FriendsDetailCollectionViewController
                // Здесь нам нужно понять на какого друга нажал пользователь
                // Для этого мы вычисляем секцию ячейка который была нажата
                // Так как за секции отвечают ключи словаря друзей, то мы обращаемся к словарю groupedFriends а затем берем его ключи groupedFriends[sortedFirstLetters] и получаем индекс нажатой секции groupedFriends[sortedFirstLetters[indexPath.section]]
                let model = groupedFriends[sortedFirstLetters[indexPath.section]]
                // Теперь мы можем узнать на какого друга нажал пользователь
                // Для этого у полученной секции model мы спрашиваем индекс нажатой ячейки model?[indexPath.row]
                guard let user = model?[indexPath.row] else { return }
                
                friendsDetailVC.navigationController?.title = user.firstName + " " + user.lastName
                // Передаю id друга для получения всех его фотографий
                friendsDetailVC.ownerID = user.id
                // Добавляю в массив друзей выделенного пользователем друга
                friendsDetailVC.users.append(user)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.indexPathForSelectedRow != nil) {
            performSegue(withIdentifier: "detailFriendsTableViewSegue", sender: nil)
        }
    }
}

// MARK: - TableViewDataSource
extension FriendsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {

        return sortedFirstLetters.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Беру словарь и получаю индекс выбранного ключа и получаю количество значений в этом словаре
        // То есть получаю индекс секции и количество друзей в этой секции
        return groupedFriends[sortedFirstLetters[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FriendsTableViewCell else { return UITableViewCell() }
        // Получаю ключ словаря по номеру секции
        let key = sortedFirstLetters[indexPath.section]
        // Получаю значения по ключу полученому выше
        let friends = groupedFriends[key]
        
        guard let friend = friends?[indexPath.row] else { return cell }
        
        cell.nameLabel.text = friend.firstName + " " + friend.lastName
        fetchAvatar(friend, cell)
        
        return cell
//        networkService.fetchAndCachedPhoto(
//            from: model.avatarURL) { image in
//            cell.avatarImageView.image = image
//        } completionError: { error in
//            cell.avatarImageView.image = UIImage(named: "")
//        }
        
//        cell.avatarImageView.kf.setImage(with: URL(string: model.avatarURL), options: [.transition(.fade(0.5))])
    }
    
    private func fetchAvatar(_ model: Friend,
                             _ cell: FriendsTableViewCell) {
        networkService.fetchAndCachedPhoto(
            from: model.avatarURL) { image in
            cell.avatarImageView.image = image
        } completionError: { error in
            cell.avatarImageView.image = UIImage(named: "")
        }
    }
}

extension FriendsTableViewController {
    // MARK: - Sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedFirstLetters[section].uppercased()
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return String(sortedFirstLetters).map { String($0.uppercased()) }
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
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // Вычисляемое свойство, определяющее, пустой ли серчбар или нет
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    func filterContentFor(_ searchText: String) {
//        filteredFriends = friends.filter { friends -> Bool in
//            return friends
//                .firstName
//                .lowercased()
//                .contains(searchText.lowercased())
//        }
        
        groupedFriends = sortingFriendsByName(searchText, friends)
        
        tableView.reloadData()
    }
    
    // Теперь всякий раз, когда пользователь добавляет или удаляет текст в строке поиска, UISearchController будет информировать класс FriendsTableViewController об изменении посредством вызова updateSearchResults(for:), который, в свою очередь, вызывает filterContentFor(_ searchText:).
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentFor(searchBar.text!.lowercased())
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
                                         style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.view.layoutIfNeeded()
        present(alert, animated: true)
        tableView.reloadData()
    }
}


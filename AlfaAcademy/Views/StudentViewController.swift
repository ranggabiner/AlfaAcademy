//
//  StudentViewController.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import UIKit

class StudentViewController: UIViewController {
    private var viewModel = StudentViewModel()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 80
        table.separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
        return table
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupRefreshControl()
        Task {
            await fetchStudents()
        }
    }
    
    private func setupUI() {
        title = "Students"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout",
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(logoutTapped))
    }
    
    @objc private func logoutTapped() {
        UserDefaultsHelper.logout()
        
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        
        // Get current window from window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        } else {
            // Fallback to modal presentation
            present(loginVC, animated: true)
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        Task {
            await fetchStudents()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func fetchStudents() async {
        await MainActor.run { loadingIndicator.startAnimating() }
        
        do {
            await viewModel.fetchStudents()
            await MainActor.run {
                loadingIndicator.stopAnimating()
                tableView.reloadData()
            }
        } catch {
            await MainActor.run {
                loadingIndicator.stopAnimating()
                showError(message: error.localizedDescription)
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension StudentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.identifier, for: indexPath) as? StudentCell else {
            return UITableViewCell()
        }
        let student = viewModel.students[indexPath.row]
        cell.configure(with: student)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection if needed
    }
}

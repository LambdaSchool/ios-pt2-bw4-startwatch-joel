//
//  StartWatchViewController.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/27/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import UIKit

class StartWatchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var banner: UIView!
    @IBOutlet private weak var lblElapsedTime: UILabel!
    @IBOutlet private weak var lblTaskName: UILabel!
    @IBOutlet private weak var lblTaskEmoji: UILabel!
    @IBOutlet private var favorites: [UIView]!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var btnStop: UIImageView!
    
    // MARK: - Properties
    
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateViews() {
        guard self.isViewLoaded else { return }
    }
    
    // MARK: - Actions
    @IBAction func bannerTapped(_ sender: Any) {
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
    }
    
    @IBAction func plusTapped(_ sender: Any) {
    }
    
    @IBAction func editTapped(_ sender: Any) {
    }
    
    @IBAction func stopTapped(_ sender: Any) {
    }
    
    @IBAction func backArrowTapped(_ sender: Any) {
    }
    
    @IBAction func quickTapped(_ sender: Any) {
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension StartWatchViewController: UITableViewDelegate {
    
}

extension StartWatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

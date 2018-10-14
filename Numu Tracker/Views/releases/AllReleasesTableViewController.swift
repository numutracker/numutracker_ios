//
//  AllReleasesTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/29/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import Crashlytics

let defaults = UserDefaults.standard

class AllReleasesTableViewController: UITableViewController {

    @IBOutlet weak var importFromAMButton: NumuUIButton!
    @IBOutlet weak var importFromAMSpinner: UIActivityIndicatorView!
    @IBAction func importFromAMAction(_ sender: Any) {
        importFromAMSpinner.startAnimating()
        let importAMOperation = ImportAppleMusicOperation()
        let queue = OperationQueue()
        importAMOperation.qualityOfService = .userInteractive
        importAMOperation.completionBlock = {
            DispatchQueue.main.async {
                self.importFromAMSpinner.stopAnimating()
            }
        }
        queue.addOperation(importAMOperation)
    }

    var releases: [ReleaseItem] = []
    var viewName: String = ""
    var releaseData: ReleaseData! {
        didSet {
            if releaseData.totalPages == "0" {
                DispatchQueue.main.async(execute: {
                    self.tableView.tableFooterView = UIView()
                    if self.slideType == 3 {
                        self.tableView.tableHeaderView = self.otherNoResultsFooterView
                        self.otherNoResultsLabel.text = "Over time this view will fill up with any releases" +
                            " added to the system after you've joined. These releases may be old, they may be new," +
                            " they just weren't in Numu Tracker before now."
                    } else if self.slideType == 2 {
                        self.tableView.tableHeaderView = self.otherNoResultsFooterView
                        self.otherNoResultsLabel.text = "No upcoming releases"
                    } else {
                        self.tableView.tableHeaderView = self.noResultsFooterView
                    }
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.tableView.tableHeaderView = nil
                })
            }
        }
    }
    var isLoading: Bool = false
    var viewType: Int = 1
    var slideType: Int = 0

    @IBOutlet weak var otherNoResultsLabel: UILabel!
    @IBOutlet var otherNoResultsFooterView: UIView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var noResultsFooterView: UIView!
    @IBOutlet weak var noResultsLabel: UILabel!

    @IBOutlet weak var releasesSegmentedControl: UISegmentedControl!

    @IBAction func changeSlide(_ sender: UISegmentedControl) {
        let segment = sender.selectedSegmentIndex
        self.slideType = segment
        self.tableView.tableFooterView = self.footerView
        releases.removeAll()
        tableView.reloadData()
        self.loadFirstReleases()
    }

    func loadFirstReleases() {
        if defaults.logged {
            self.isLoading = true
            NumuClient.shared.getReleases(view: self.viewType, slide: self.slideType) {[weak self](releaseData) in
                self?.releaseData = releaseData
                DispatchQueue.main.async(execute: {
                    if let results = self?.releaseData?.results {
                        self?.releases = results
                    }
                    self?.isLoading = false
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = UIView()
                    self?.refreshControl?.endRefreshing()
                })
            }

            switch (self.viewType, self.slideType) {
            case (0, 0):
                self.viewName = "All Unlistened"
            case (0, 1):
                self.viewName = "All Released"
            case (0, 2):
                self.viewName = "All Upcoming"
            case (0, 3):
                self.viewName = "Error"
            case (1, 0):
                self.viewName = "Your Unlistened"
            case (1, 1):
                self.viewName = "Your Released"
            case (1, 2):
                self.viewName = "Your Upcoming"
            case (1, 3):
                self.viewName = "Your Fresh"
            default:
                self.viewName = "Error"
            }

            Answers.logCustomEvent(withName: self.viewName, customAttributes: nil)
        }
    }

    func loadMoreReleases() {
        self.isLoading = true
        let currentPage = Int(self.releaseData.currentPage)!
        let nextPage = currentPage+1
        let offset = releases.count
        let limit = 50

        NumuClient.shared.getReleases(
            view: self.viewType,
            slide: self.slideType,
            page: nextPage,
            limit: limit,
            offset: offset) {[weak self](releaseData) in
            self?.releaseData = releaseData
            DispatchQueue.main.async(execute: {
                self?.releases = (self?.releases)! + (self?.releaseData?.results)!
                self?.isLoading = false
                self?.tableView.reloadData()
                self?.tableView.tableFooterView = UIView()
            })
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        viewType = 1
        self.title = "Your Releases"

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actOnLoggedInNotification),
                                               name: .LoggedIn,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actOnLoggedOutNotification),
                                               name: .LoggedOut,
                                               object: nil)

        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        self.tableView.tableFooterView = self.footerView
        
        importFromAMButton.backgroundColor = .clear
        importFromAMButton.layer.cornerRadius = 5
        importFromAMButton.layer.borderWidth = 1
        importFromAMButton.layer.borderColor = UIColor.gray.cgColor
        
        var newFrame = noResultsFooterView.frame
        var height: CGFloat = self.tableView.bounds.height
        height -= UIApplication.shared.statusBarFrame.size.height
        height -= (self.navigationController?.navigationBar.frame.size.height)!
        height -= (self.tabBarController?.tabBar.frame.size.height)!
        newFrame.size.height = height
        noResultsFooterView.frame = newFrame
        otherNoResultsFooterView.frame = newFrame
        footerView.frame = newFrame
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.releases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ReleaseTableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "releaseInfoCell",
            for: indexPath) as! ReleaseTableViewCell

        let releaseInfo = releases[indexPath.row]
        cell.configure(releaseInfo: releaseInfo)

        // Image loading.
        cell.artIndicator.startAnimating()
        cell.thumbUrl = releaseInfo.thumbUrl // For recycled cells' late image loads.
        
        cell.artImageView.kf.setImage(
            with: cell.thumbUrl,
            options: [.transition(.fade(0.2))])

        let rowsToLoadFromBottom = 20

        if !self.isLoading && indexPath.row >= (releases.count - rowsToLoadFromBottom) {
            let currentPage = Int(releaseData.currentPage)!
            let totalPages = Int(releaseData.totalPages)!
            if currentPage < totalPages {
                self.tableView.tableFooterView = self.footerView
                self.loadMoreReleases()
            }
        }

        return cell
    }

    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        releases.removeAll()
        tableView.reloadData()
        self.loadFirstReleases()
    }

    override func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let releaseInfo = self.releases[indexPath.row]

        let listened = UITableViewRowAction(style: .normal, title: "Listened") { _, index in
            
            releaseInfo.toggleListenStatus { (success) in
                DispatchQueue.main.async(execute: {
                    if success == "1" {
                        // remove or add unread marker back in
                        let cell = self.tableView.cellForRow(at: index) as! ReleaseTableViewCell
                        if self.releases[index.row].listenStatus == "0" {
                            self.releases[index.row].listenStatus = "1"
                            cell.listenedIndicatorView.isHidden = true
                            Answers.logCustomEvent(
                                withName: "Listened",
                                customAttributes: ["Release ID": releaseInfo.releaseId])
                        } else {
                            self.releases[index.row].listenStatus = "0"
                            cell.listenedIndicatorView.isHidden = false
                             Answers.logCustomEvent(
                                withName: "Unlistened",
                                customAttributes: ["Release ID": releaseInfo.releaseId])
                        }
                        tableView.setEditing(false, animated: true)
                    }
                })
            }
        }

        if releaseInfo.listenStatus == "1" {
            listened.title = "Didn't Listen"
        }
        listened.backgroundColor = .background

        return [listened]
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Touched View Cell...")
        let releaseDetails = ReleaseDetailsViewController()
        releaseDetails.providesPresentationContextTransitionStyle = true
        releaseDetails.definesPresentationContext = true
        releaseDetails.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        releaseDetails.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        if let appDelegate = UIApplication.shared.delegate,
            let appWindow = appDelegate.window!,
            let rootViewController = appWindow.rootViewController {
            rootViewController.present(releaseDetails, animated: true, completion: nil)
            releaseDetails.configure(release: self.releases[indexPath.row])
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
    }

    @objc func actOnLoggedInNotification() {
        releases.removeAll()
        tableView.reloadData()
        self.tableView.tableFooterView = self.footerView
        DispatchQueue.global(qos: .background).async(execute: {
            self.loadFirstReleases()
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.tableView.tableFooterView = UIView()
            })
        })
    }

    @objc func actOnLoggedOutNotification() {
        releases.removeAll()
        tableView.reloadData()
        DispatchQueue.global(qos: .background).async(execute: {
            self.loadFirstReleases()
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
    }
}

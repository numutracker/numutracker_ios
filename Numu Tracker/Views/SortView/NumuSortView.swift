//
//  NumuSortView.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/6/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

protocol SortViewDelegate {
    func sortOptionTapped(name: String)
}

class NumuSortView: UIViewController {
    
    var sortDelegate: SortViewDelegate!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var sortOptionsView: UIView!
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sortByReleaseAction(_ sender: Any) {
        sortDelegate.sortOptionTapped(name: "date")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sortByArtistLastFirstAction(_ sender: Any) {
        sortDelegate.sortOptionTapped(name: "name")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sortByArtistFirstLastAction(_ sender: Any) {
        sortDelegate.sortOptionTapped(name: "name_first")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    func setupView() {
        cancelView.layer.cornerRadius = 15
        cancelView.layer.shadowColor = UIColor.black.cgColor
        cancelView.layer.shadowOpacity = 0.2
        cancelView.layer.shadowOffset = CGSize.zero
        cancelView.layer.shadowRadius = 20
        
        sortOptionsView.layer.cornerRadius = 15
        sortOptionsView.layer.shadowColor = UIColor.black.cgColor
        sortOptionsView.layer.shadowOpacity = 0.2
        sortOptionsView.layer.shadowOffset = CGSize.zero
        sortOptionsView.layer.shadowRadius = 20
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    func animateView() {
        sortOptionsView.alpha = 0
        self.sortOptionsView.frame.origin.y += 50
        cancelView.alpha = 0
        self.cancelView.frame.origin.y += 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.sortOptionsView.alpha = 1.0
            self.sortOptionsView.frame.origin.y -= 50
            self.cancelView.alpha = 1.0
            self.cancelView.frame.origin.y -= 50
        })
    }

}

//
//  MovePlaylistViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/18/24.
//

import UIKit

class MovePlaylistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}

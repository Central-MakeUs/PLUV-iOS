//
//  TabBarViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let homeVC = HomeViewController()
    let myPageVC = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        homeVC.title = "홈"
        myPageVC.title = "마이페이지"
        
        homeVC.navigationItem.title = ""
        myPageVC.navigationItem.title = ""
        
        /// 아이콘 크기 조정
        let homeImage = UIImage(named: "home_icon")?.withRenderingMode(.alwaysOriginal)
        let myPageImage = UIImage(named: "mypage_icon")?.withRenderingMode(.alwaysOriginal)
        
        let resizedHomeImage = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { _ in
            homeImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        }
        let resizedMyPageImage = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { _ in
            myPageImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        }
        
        ///  선택 및 선택되지 않은 상태의 색상 지정
        homeVC.tabBarItem.image = resizedHomeImage
        homeVC.tabBarItem.selectedImage = resizedHomeImage
        myPageVC.tabBarItem.image = resizedMyPageImage
        myPageVC.tabBarItem.selectedImage = resizedMyPageImage
        
        homeVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray300], for: .normal)
        homeVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray800], for: .selected)
        homeVC.tabBarItem.image = resizedHomeImage.withTintColor(.gray300, renderingMode: .alwaysOriginal)
        homeVC.tabBarItem.selectedImage = resizedHomeImage.withTintColor(.gray800, renderingMode: .alwaysOriginal)
        
        myPageVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray300], for: .normal)
        myPageVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray800], for: .selected)
        myPageVC.tabBarItem.image = resizedMyPageImage.withTintColor(.gray300, renderingMode: .alwaysOriginal)
        myPageVC.tabBarItem.selectedImage = resizedMyPageImage.withTintColor(.gray800, renderingMode: .alwaysOriginal)
        
        /// 타이틀과 아이콘 사이 거리 조정
        homeVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 13)
        myPageVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 13)
        
        /// tabbar 상단과 이미지 사이 위치 조정
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        myPageVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationMyPage = UINavigationController(rootViewController: myPageVC)
        
        /// 스크롤 시 상단 View 안 보이게 조정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationHome.navigationBar.standardAppearance = appearance
        navigationHome.navigationBar.scrollEdgeAppearance = appearance
        
        navigationMyPage.navigationBar.standardAppearance = appearance
        navigationMyPage.navigationBar.scrollEdgeAppearance = appearance
        
        setViewControllers([navigationHome, navigationMyPage], animated: false)
    }
}


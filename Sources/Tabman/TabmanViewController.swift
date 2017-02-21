//
//  TabmanViewController.swift
//  Tabman
//
//  Created by Merrick Sapsford on 17/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit
import Pageboy

open class TabmanViewController: PageboyViewController, PageboyViewControllerDelegate {
    
    // MARK: Properties
    
    internal(set) public var tabBar: TabmanBar?
    
    public var tabBarStyle: TabmanBar.Style = .buttonBar {
        didSet {
            guard tabBarStyle != oldValue else {
                return
            }
            self.reloadTabBar(withStyle: tabBarStyle)
        }
    }
    public var tabBarLocation: TabmanBar.Location = .top {
        didSet {
            guard tabBarLocation != oldValue else {
                return
            }
            self.updateTabBar(withLocation: tabBarLocation)
        }
    }
    
    public var tabBarItems: [TabmanBarItem]? {
        didSet {
            self.tabBar?.reloadData()
        }
    }
    
    // MARK: Lifecycle
    
    open override func loadView() {
        super.loadView()
        
        self.delegate = self
        
        // add tab bar to view
        self.reloadTabBar(withStyle: self.tabBarStyle)
        self.updateTabBar(withLocation: self.tabBarLocation)
    }
    
    // MARK: PageboyViewControllerDelegate
    
    open func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                      willScrollToPageAtIndex index: Int,
                                      direction: PageboyViewController.NavigationDirection) {
        
    }
    
    open func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                      didScrollToPageWithIndex index: Int,
                                      direction: PageboyViewController.NavigationDirection) {
        self.tabBar?.position = CGFloat(index)
    }
    
    open func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                      didScrollToPosition position: CGPoint,
                                      direction: PageboyViewController.NavigationDirection) {
        self.tabBar?.position = pageboyViewController.navigationOrientation == .horizontal ? position.x : position.y
    }
    
}

internal extension TabmanViewController {
    
    func reloadTabBar(withStyle style: TabmanBar.Style) {
        guard let barType = style.rawType else {
            return
        }
        
        // re create the tab bar with a new style
        let bar = barType.init()
        bar.dataSource = self
        
        self.tabBar = bar
    }
    
    func updateTabBar(withLocation location: TabmanBar.Location) {
        guard let tabBar = self.tabBar else {
            return
        }
        
        tabBar.removeFromSuperview()
        self.view.addSubview(tabBar)

        // move tab bar to location
        switch location {
            
        case .top:
            tabBar.tabBarAutoPinToTop(topLayoutGuide: self.topLayoutGuide)
        case .bottom:
            tabBar.tabBarAutoPinToBotton(bottomLayoutGuide: self.bottomLayoutGuide)
        }
        
    }
}

extension TabmanViewController: TabmanBarDataSource {
    
    public func items(forTabBar tabBar: TabmanBar) -> [TabmanBarItem]? {
        return self.tabBarItems
    }
}
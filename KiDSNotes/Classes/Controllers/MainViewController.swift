//
//  MainViewController.swift
//  CalendarTest
//
//  Created by deus4 on 08/10/16.
//  Copyright © 2016 Deus4. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPageViewControllerDataSource {
     
     let calendar = Calendar.current
     
     let currentDisplayingMonth : NSDate? = nil
     var previosYear = 0
     var currentComponents : DateComponents? = nil
     fileprivate var pageViewController: UIPageViewController?
     override func viewDidLoad() {
          super.viewDidLoad()
            let contentScale = self.view.bounds.width / 375
            self.view.transform = CGAffineTransform(scaleX: contentScale, y: contentScale)
          createPageViewController()
          // Do any additional setup after loading the view.
     }
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
     }
     
     func getRange(date: NSDate, month: CFCalendarUnit) -> Int{
          let calendar = NSCalendar.current
          let range = calendar.range(of: .day, in: .month, for: date as Date)
          return range!.count
     }
     
     fileprivate func createPageViewController() {
          let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
          pageController.dataSource = self
          let date = NSDate()
          let currentComponents = calendar.dateComponents([.month, .year], from: date as Date)
          let firstController = getItemController(components: currentComponents)!
          let startingViewControllers: NSArray = [firstController]
          pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
          pageViewController = pageController
          addChildViewController(pageViewController!)
          self.view.addSubview(pageViewController!.view)
          pageViewController!.didMove(toParentViewController: self)
     }
     
     fileprivate func getItemController(components: DateComponents) -> CalendarViewController? {
          let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "CalendarController") as! CalendarViewController
          let date = calendar.date(from: components)
          pageItemController.date = date! as NSDate
          return pageItemController
          
     }
     // MARK: - UIPageViewControllerDataSource
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
          let vc = pageViewController.viewControllers?[0] as! CalendarViewController
          let currentDate = vc.date
          var components = calendar.dateComponents([.year, .month], from: currentDate as Date)
          components.month = components.month! - 1
          return getItemController(components: components)
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
          let vc = pageViewController.viewControllers?[0] as! CalendarViewController
          let currentDate = vc.date
          var components = calendar.dateComponents([.year, .month], from: currentDate as Date)
          components.month = components.month! + 1
          return getItemController(components: components)
     }
     

     
     
     
     
}

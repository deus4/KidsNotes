//
//  CalendarViewController.swift
//  CalendarTest
//
//  Created by deus4 on 07/10/16.
//  Copyright © 2016 Deus4. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    var startingIndex = 0
    var numberOfDaysInThisMonth = 0
    let monthNames = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    let imageNames = ["January", "February", "March", "Aprill", "May", "June", "July", "August", "September", "October", "November", "December"]
    var date = NSDate()
    var calendar = Calendar.current
    @IBOutlet weak var seasonImageView: UIImageView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var addNewNoteButtonOutlet: UIButton!
    
    
    @IBOutlet weak var selectedDayLabel: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let components = calendar.dateComponents([.year, .month], from: date as Date)
        calendar.firstWeekday = 2
        let year = components.year!
        let month =  components.month!
        self.seasonImageView.image = UIImage(named: imageNames[month - 1])
        let unformatedDay = (getDayOfWeek("\(year)-\(month)-01")!)
        startingIndex = unformatedDay
        monthYearLabel.text = "\(monthNames[month - 1])  \(year)"
        numberOfDaysInThisMonth = calendar.range(of: .day, in: .month, for: date as Date)!.count
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let weekDay = calendar.component(.weekday, from: todayDate)
            return weekDay
        } else {
            return nil
        }
    }
    func getTodayDate() -> String{
        var todayDateString = ""
        let todayDate = NSDate()
        let todayComponents = calendar.dateComponents([.month, .year, .day], from: todayDate as Date)
        let month = todayComponents.month!
        let year = todayComponents.year!
        let dayInt = todayComponents.day!
        let day = String(format: "%.2d", dayInt)
        todayDateString = "\(day) \(monthNames[month - 1])  \(year)"
        return todayDateString
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCell
        if !(cell.dayNumberLabel.text?.isEmpty)!{
        self.selectedDayLabel.text = ("\(cell.dayNumberLabel.text!) \(self.monthYearLabel.text!)")
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            cell.selectedView.alpha = 0.4
            })
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCell
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            cell.selectedView.alpha = 0
        })
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! DayCell
        setDayForCell(cell: cell, indexPath: indexPath)
        let checkString = "\(cell.dayNumberLabel.text!) \(self.monthYearLabel.text!)"
        if checkString == getTodayDate() {
            print("\(checkString) == \(getTodayDate())" )
            cell.todayDateView.isHidden = false
        }
        return cell
    }
    func setDayForCell(cell: DayCell, indexPath: IndexPath){
        var day = 0
        let indexConverted = indexPath.row + 1
        switch indexConverted {
        case (startingIndex)...(startingIndex + numberOfDaysInThisMonth - 1):
            day = indexConverted - startingIndex + 1
            cell.dayNumberLabel.text = String(format: "%.2d", day)
        default:
            cell.dayNumberLabel.text = ""
            cell.isUserInteractionEnabled = false
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }

}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! MarkTableViewCell
        cell.markDescriptionLabel.text = "\(indexPath.row)"
        
        return cell
    }
}

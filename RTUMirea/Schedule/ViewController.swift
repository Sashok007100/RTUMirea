//
//  ViewController.swift
//  RTUMirea
//
//  Created by Alexandr Artemov on 21/09/2019.
//  Copyright © 2019 Alexandr Artemov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var tableViewRTU: UITableView!
    
    var groupName = group()
    var rowCount : Int = 6 // Количество пар в день
    let startTime = ["9:00", "10:40", "13:10", "14:50", "16:30", "18:10"] // Время начала пар
    let endTime = ["10:30", "12:10", "14:40", "16:20", "18:00", "19:40"] // Время окончания пар
    
    let term = [ 0 : 1,
                 1 : 2,
                 2 : 3,
                 3 : 4]
    
    let institute = [ 0 : "Институт информационных технологий",
                      1 : "Физико-технологический институт",
                      2 : "Институт инновационных технологий и государственного управления",
                      3 : "Институт кибернетики",
                      4 : "Институт комплексной безопасности и специального приборостроения",
                      5 : "Институт радиотехнических и телекоммуникационных систем",
                      6 : "Институт тонких химических технологий",
                      7 : "Институт управления и стратегического развития организаций"]
    
    //var userData: [String: Any] = [:]
    
//    func collectGroup() {
//        let userdata: [String : Any]
//
//        userdata = ["term": 3,
//                    "institute": 0,
//                    "group": "\(groupName)"]
//
//        userData = userdata
//    }
    
    
    //var typeObject = [Int]()    // Массив в который добавляются типы предметов из json
    var teachers   = [String]() // Массив в которой добавляются имена преподавателей из json
    //var auditories = [String]() // Массив в который добавляются аудитории из json
    
    var monday = [String]()
    var mondayTypeObject = [Int]()
    var mondayAuditories = [String]()
    
    var tuesday = [String]()
    var tuesdayTypeObject = [Int]()
    var tuesdayAuditories = [String]()
    
    var wednesday = [String]()
    var wednesdayTypeObject = [Int]()
    var wednesdayAuditories = [String]()
    
    var thursday = [String]()
    var thursdayTypeObject = [Int]()
    var thursdayAuditories = [String]()
    
    var friday = [String]()
    var fridayTypeObject = [Int]()
    var fridayAuditories = [String]()
    
    var saturday = [String]()
    var saturdayTypeObject = [Int]()
    var saturdayAuditories = [String]()
    
    //var objectName = [String]()  // Массив в который добавлются название занятий из json
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewRTU.dataSource = self
        tableViewRTU.delegate = self
        
        responseSchedule()
    }

    func responseSchedule() {
        guard let url = URL(string: "http://mirea.feed4rz.ru/api/schedule/get") else { return }
        
        let userData: [String : Any] = ["term": 3,
                                        "institute": 0,
                                        "group": "ikbo-16-17"]

        request(url, method: .post, parameters: userData).validate(contentType: ["application/json"]).responseJSON { resp in

        guard let statusCode = resp.response?.statusCode else { return }
        print("statusCode: ", statusCode)


        if let data = resp.data, let utf8Text = String(data: data, encoding: .utf8) {
            do {
                let json = try JSON(data: data)
                
                for i in 0...5 {
                    for j in 0...5 {
                        if
                            let string   = json["response"]["schedule"]["days"][i][j]["odd"]["name"].string,  // Предмет
                            let type     = json["response"]["schedule"]["days"][i][j]["odd"]["type"].int,     // Тип предмета
                            let auditory = json["response"]["schedule"]["days"][i][j]["odd"]["room"].string { // Аудитория
                            //self.objectName.append(string)
                            
                            switch i {
                            case 0:
                                self.monday.append(string)
                                self.mondayTypeObject.append(type)
                                self.mondayAuditories.append(auditory)
                            case 1:
                                self.tuesday.append(string)
                                self.tuesdayTypeObject.append(type)
                                self.tuesdayAuditories.append(auditory)
                            case 2:
                                self.wednesday.append(string)
                                self.wednesdayTypeObject.append(type)
                                self.wednesdayAuditories.append(auditory)
                            case 3:
                                self.thursday.append(string)
                                self.thursdayTypeObject.append(type)
                                self.thursdayAuditories.append(auditory)
                            case 4:
                                self.friday.append(string)
                                self.fridayTypeObject.append(type)
                                self.fridayAuditories.append(auditory)
                            case 5:
                                self.saturday.append(string)
                                self.saturdayTypeObject.append(type)
                                self.saturdayAuditories.append(auditory)
                            default:
                                break
                            }
                            
//                            self.typeObject.append(type)
//                            self.auditories.append(auditory)
                        } else {
                            
                            switch i {
                            case 0:
                                self.monday.append("--")
                                self.mondayTypeObject.append(404)
                                self.mondayAuditories.append("--")
                            case 1:
                                self.tuesday.append("--")
                                self.tuesdayTypeObject.append(404)
                                self.tuesdayAuditories.append("--")
                            case 2:
                                self.wednesday.append("--")
                                self.wednesdayTypeObject.append(404)
                                self.wednesdayAuditories.append("--")
                            case 3:
                                self.thursday.append("--")
                                self.thursdayTypeObject.append(404)
                                self.thursdayAuditories.append("--")
                            case 4:
                                self.friday.append("--")
                                self.fridayTypeObject.append(404)
                                self.fridayAuditories.append("--")
                            case 5:
                                self.saturday.append("--")
                                self.saturdayTypeObject.append(404)
                                self.saturdayAuditories.append("--")
                            default:
                                break
                            }
                        }
                    }
                }
                self.tableViewRTU.reloadData()
                } catch {
                    print(error)
                }
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    // Заголовок секций (разделов)
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Понедельник"
        case 1:
            return "Вторник"
        case 2:
            return "Среда"
        case 3:
            return "Четверг"
        case 4:
            return "Пятница"
        case 5:
            return "Суббота"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewRTU.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MainTableViewCell
        
        // Label "Start"
        cell?.timeStartLabel.text = startTime[indexPath.row]
        // Label "End"
        cell?.timeEndLabel.text = endTime[indexPath.row]
        
        // Label "Object"
        switch indexPath.section {
        case 0:
            if !monday.isEmpty {
                cell?.objectLabel.text = monday[indexPath.row]
            }
        case 1:
            if !tuesday.isEmpty {
                cell?.objectLabel.text = tuesday[indexPath.row]
            }
        case 2:
            if !wednesday.isEmpty {
                cell?.objectLabel.text = wednesday[indexPath.row]
            }
        case 3:
            if !thursday.isEmpty {
                cell?.objectLabel.text = thursday[indexPath.row]
            }
        case 4:
            if !friday.isEmpty {
                cell?.objectLabel.text = friday[indexPath.row]
            }
        case 5:
            if !saturday.isEmpty {
                cell?.objectLabel.text = saturday[indexPath.row]
            }
        default:
            break
        }
        
        // Label "occupation type"
        switch indexPath.section {
        case 0:
            if !mondayTypeObject.isEmpty {
                switch mondayTypeObject[indexPath.row] {
                case 0:
                    cell?.occupationTypeLabel.text = "Лекция"
                case 1:
                    cell?.occupationTypeLabel.text = "Практика"
                case 2:
                    cell?.occupationTypeLabel.text = "Лаборатоорная"
                case 10:
                    cell?.occupationTypeLabel.text = "ПР + ЛК"
                case 12:
                    cell?.occupationTypeLabel.text = "ПР + ЛАБ"
                case 20:
                    cell?.occupationTypeLabel.text = "ЛАБ + ЛК"
                case 404:
                    cell?.occupationTypeLabel.text = "--"
                default:
                    cell?.occupationTypeLabel.text = "--"
                }
            }
        case 1:
            if !tuesdayTypeObject.isEmpty {
                switch tuesdayTypeObject[indexPath.row] {
                case 0:
                    cell?.occupationTypeLabel.text = "Лекция"
                case 1:
                    cell?.occupationTypeLabel.text = "Практика"
                case 2:
                    cell?.occupationTypeLabel.text = "Лаборатоорная"
                case 10:
                    cell?.occupationTypeLabel.text = "ПР + ЛК"
                case 12:
                    cell?.occupationTypeLabel.text = "ПР + ЛАБ"
                case 20:
                    cell?.occupationTypeLabel.text = "ЛАБ + ЛК"
                case 404:
                    cell?.occupationTypeLabel.text = "--"
                default:
                    cell?.occupationTypeLabel.text = "--"
                }
            }
        case 2:
            if !wednesdayTypeObject.isEmpty {
                switch wednesdayTypeObject[indexPath.row] {
                case 0:
                    cell?.occupationTypeLabel.text = "Лекция"
                case 1:
                    cell?.occupationTypeLabel.text = "Практика"
                case 2:
                    cell?.occupationTypeLabel.text = "Лаборатоорная"
                case 10:
                    cell?.occupationTypeLabel.text = "ПР + ЛК"
                case 12:
                    cell?.occupationTypeLabel.text = "ПР + ЛАБ"
                case 20:
                    cell?.occupationTypeLabel.text = "ЛАБ + ЛК"
                case 404:
                    cell?.occupationTypeLabel.text = "--"
                default:
                    cell?.occupationTypeLabel.text = "--"
                }
            }
        case 3:
            if !thursdayTypeObject.isEmpty {
                switch thursdayTypeObject[indexPath.row] {
                case 0:
                    cell?.occupationTypeLabel.text = "Лекция"
                case 1:
                    cell?.occupationTypeLabel.text = "Практика"
                case 2:
                    cell?.occupationTypeLabel.text = "Лаборатоорная"
                case 10:
                    cell?.occupationTypeLabel.text = "ПР + ЛК"
                case 12:
                    cell?.occupationTypeLabel.text = "ПР + ЛАБ"
                case 20:
                    cell?.occupationTypeLabel.text = "ЛАБ + ЛК"
                case 404:
                    cell?.occupationTypeLabel.text = "--"
                default:
                    cell?.occupationTypeLabel.text = "--"
                }
            }
        case 4:
            if !fridayTypeObject.isEmpty {
                switch fridayTypeObject[indexPath.row] {
                case 0:
                    cell?.occupationTypeLabel.text = "Лекция"
                case 1:
                    cell?.occupationTypeLabel.text = "Практика"
                case 2:
                    cell?.occupationTypeLabel.text = "Лаборатоорная"
                case 10:
                    cell?.occupationTypeLabel.text = "ПР + ЛК"
                case 12:
                    cell?.occupationTypeLabel.text = "ПР + ЛАБ"
                case 20:
                    cell?.occupationTypeLabel.text = "ЛАБ + ЛК"
                case 404:
                    cell?.occupationTypeLabel.text = "--"
                default:
                    cell?.occupationTypeLabel.text = "--"
                }
            }
        case 5:
            if !saturdayTypeObject.isEmpty {
                switch saturdayTypeObject[indexPath.row] {
                case 0:
                    cell?.occupationTypeLabel.text = "Лекция"
                case 1:
                    cell?.occupationTypeLabel.text = "Практика"
                case 2:
                    cell?.occupationTypeLabel.text = "Лаборатоорная"
                case 10:
                    cell?.occupationTypeLabel.text = "ПР + ЛК"
                case 12:
                    cell?.occupationTypeLabel.text = "ПР + ЛАБ"
                case 20:
                    cell?.occupationTypeLabel.text = "ЛАБ + ЛК"
                case 404:
                    cell?.occupationTypeLabel.text = "--"
                default:
                    cell?.occupationTypeLabel.text = "--"
                }
            }
        default:
            break
        }
        
        // Label "audience"
        switch indexPath.section {
        case 0:
            if !mondayAuditories.isEmpty {
                cell?.audienceLabel.text = mondayAuditories[indexPath.row]
            }
        case 1:
            if !tuesdayAuditories.isEmpty {
                cell?.audienceLabel.text = tuesdayAuditories[indexPath.row]
            }
        case 2:
            if !wednesdayAuditories.isEmpty {
                cell?.audienceLabel.text = wednesdayAuditories[indexPath.row]
            }
        case 3:
            if !thursdayAuditories.isEmpty {
                cell?.audienceLabel.text = thursdayAuditories[indexPath.row]
            }
        case 4:
            if !fridayAuditories.isEmpty {
                cell?.audienceLabel.text = fridayAuditories[indexPath.row]
            }
        case 5:
            if !saturdayAuditories.isEmpty {
                cell?.audienceLabel.text = saturdayAuditories[indexPath.row]
            }
        default:
            break
        }
        
        return cell!
    }
    
}


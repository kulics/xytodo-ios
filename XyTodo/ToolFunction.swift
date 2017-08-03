import Foundation
import UIKit
//通用方法工具
class ToolFunction
{
    //日期处理方法
    static func GetDateFromUTC(time: Int) -> String
    {
        var date = ""
        let dateTarget = Date(timeIntervalSince1970: TimeInterval(time))
        let dateNow = Date()
        
        let fYear = DateFormatter()
        fYear.dateFormat = "yyyy"
        let fDay = DateFormatter()
        fDay.dateFormat = "dd"
        
        let dYear = Int(fYear.string(from: dateNow))! - Int(fYear.string(from: dateTarget))!
        let dDay = Int(fDay.string(from: dateNow))! - Int(fDay.string(from: dateTarget))!
        
        let format = DateFormatter()
        if dYear > 0 //去年以前
        {
            format.dateFormat = "yyyy-MM-dd"
            date = format.string(from: dateTarget)
        }
        else if dDay > 1 //昨天以前
        {
            format.dateFormat = "MM-dd EEE"
            date = format.string(from: dateTarget)
        }
        else if dDay > 0 //昨天
        {
            format.dateFormat = "  EEE"
            date = NSLocalizedString("yesterday", comment: "") + format.string(from: dateTarget)
        }
        else if dDay == 0 //今天
        {
            format.dateFormat = "  EEE"
            date = NSLocalizedString("today", comment: "") + format.string(from: dateTarget)
        }
        else if dDay > -2 //明天
        {
            format.dateFormat = "  EEE"
            date = NSLocalizedString("tomorrow", comment: "") + format.string(from: dateTarget)
        }
        else if dYear > -2 //明天以后
        {
            format.dateFormat = "MM-dd  EEE"
            date = format.string(from: dateTarget)
        }
        else //明年以后
        {
            format.dateFormat = "yyyy-MM-dd"
            date = format.string(from: dateTarget)
        }
        
        return date
    }
    //换算是否当天
    static func ComputeDateToday(time: Int) -> Bool
    {
        let dateTarget = Date(timeIntervalSince1970: TimeInterval(time))
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        if fmt.string(from: dateTarget) == fmt.string(from: Date())
        {
            return true
        }
        else
        {
            return false
        }
    }
}





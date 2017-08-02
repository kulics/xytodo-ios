import Foundation

class DBHelper
{
    static let DATABASE_NAME = "com_naxy_xytodo.db";
    static let DATABASE_VERSION = 1;
    
    var db:SQLiteDB!
    
    init()
    {
        //获取数据库实例
        db = SQLiteDB.shared
        //打开数据库
        _ = db.openDB(copyFile: false)
        
        let localSettings = UserDefaults.standard
        var value = DBHelper.DATABASE_VERSION;
        //判断是否存在
        if localSettings.bool(forKey: "db_exist")
        {
            //有则读取
            value = localSettings.integer(forKey: "db_version")
            OnUpgrade(oldVersion: value, newVersion: DBHelper.DATABASE_VERSION)
        }
        else
        {
            //没有则创建
            OnCreate()
            localSettings.set(DBHelper.DATABASE_VERSION, forKey: "db_version")
            localSettings.set(true, forKey: "db_exist")
        }
        
    }
    
    //获取单个链接并返回
    func GetDBConnection() -> SQLiteDB
    {
        // 连接数据库，如果数据库文件不存在则创建一个空数据库。
        //var conn = new SQLiteConnection(DATABASE_NAME);
        return db
    }
    
    //数据库第一次被创建时onCreate会被调用
    func OnCreate()
    {
        _ = db.execute(sql: TableTask.TableCreate())
        _ = db.execute(sql: TableTaskSub.TableCreate())
    }
    
    //如果DATABASE_VERSION值被改为2,系统发现现有数据库版本不同,即会调用onUpgrade
    func OnUpgrade(oldVersion: Int,  newVersion: Int)
    {
//        var upgradeVersion = oldVersion
//        if (1 == upgradeVersion)
//        {
//        }
        
//        if (upgradeVersion != newVersion) {}
//        let localSettings = UserDefaults.standard
//        localSettings.set(DBHelper.DATABASE_VERSION, forKey: "db_version")
    }

    
}

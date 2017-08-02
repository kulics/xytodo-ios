import Foundation
//钥匙
class TableTaskSub: TableBase
{
    //表格名称
    static func TableName() -> String
    {
        return "task_sub"
    }
    //表格项目数组
    static func TableColumns() -> [String]
    {
        let columns = [
            ModelTaskSub.COL_ID,
            ModelTaskSub.COL_ID_TASK,
            ModelTaskSub.COL_CONTENT,
            ModelTaskSub.COL_STATUS
        ]
        return columns
    }
    //创建表格语句
    static func TableCreate() -> String
    {
        return "CREATE TABLE IF NOT EXISTS " + TableName() + " (" +
            ModelTaskSub.COL_ID + " INTEGER PRIMARY KEY, " +
            ModelTaskSub.COL_ID_TASK + " INTEGER, " +
            ModelTaskSub.COL_CONTENT + " TEXT, " +
            ModelTaskSub.COL_STATUS + " INTEGER " +
        ");"
    }
    //更新表格语句
    static func TableUpgrade() -> String
    {
        //暴力删除表格
        return "DROP TABLE IF EXISTS " + TableName()
    }
    //插入数据语句
    static func Insert() -> String
    {
        return "INSERT INTO " + TableName() + "(" +
            ModelTaskSub.COL_ID_TASK + ", " +
            ModelTaskSub.COL_CONTENT + ", " +
            ModelTask.COL_STATUS  + ")" + " VALUES(?,?,?);"
    }
    //删除数据语句
    static func Delete(id: Int) -> String
    {
        return "DELETE FROM " + TableName() + " WHERE " + ModelTaskSub.COL_ID + " = " + String(id) + "; "
    }
    //删除所有数据语句
    static func DeleteAll(id: Int) -> String
    {
        return "DELETE FROM " + TableName() + " WHERE " + ModelTaskSub.COL_ID_TASK + " = " + String(id) + "; "
    }
    //查询所有语句
    static func QueryAll() -> String
    {
        return "SELECT * FROM " + TableName() + "; "
    }
    //根据id查询语句
    static func QueryAllByID(id: Int) -> String
    {
        return "SELECT * FROM " + TableName() + " WHERE " + ModelTaskSub.COL_ID_TASK + " = " + String(id) + "; "
    }
    
}

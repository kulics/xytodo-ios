import Foundation
//任务
class TableTask: TableBase
{
    //表格名称
    static func TableName() -> String
    {
        return "task"
    }
    //表格项目数组
    static func TableColumns() -> [String]
    {
        let columns = [
            ModelTask.COL_ID,
            ModelTask.COL_CONTENT,
            ModelTask.COL_NOTE,
            ModelTask.COL_COLOR,
            ModelTask.COL_TIME_CREATE,
            ModelTask.COL_TIME_TARGET,
            ModelTask.COL_TIME_DONE,
            ModelTask.COL_TIME_SORT,
            ModelTask.COL_STATUS
        ]
        return columns
    }
    //创建表格语句
    static func TableCreate() -> String
    {
        return "CREATE TABLE IF NOT EXISTS " + TableName() + " (" +
            ModelTask.COL_ID + " INTEGER PRIMARY KEY, " +
            ModelTask.COL_CONTENT + " TEXT, " +
            ModelTask.COL_NOTE + " TEXT, " +
            ModelTask.COL_COLOR + " TEXT, " +
            ModelTask.COL_TIME_CREATE + " INTEGER, " +
            ModelTask.COL_TIME_TARGET + " INTEGER, " +
            ModelTask.COL_TIME_DONE + " INTEGER, " +
            ModelTask.COL_TIME_SORT + " INTEGER, " +
            ModelTask.COL_STATUS + " INTEGER " +
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
            ModelTask.COL_CONTENT + ", " +
            ModelTask.COL_NOTE + ", " +
            ModelTask.COL_COLOR + ", " +
            ModelTask.COL_TIME_CREATE + ", " +
            ModelTask.COL_TIME_TARGET + ", " +
            ModelTask.COL_TIME_DONE + ", " +
            ModelTask.COL_TIME_SORT + ", " +
            ModelTask.COL_STATUS  + ")" + " VALUES(?,?,?,?,?,?,?,?);"
    }
    //更新数据语句
    static func Update(id: Int) -> String
    {
        return "UPDATE " + TableName() + " SET " +
            ModelTask.COL_CONTENT + " = ?, " +
            ModelTask.COL_NOTE + " = ?, " +
            ModelTask.COL_COLOR + " = ?, " +
            ModelTask.COL_TIME_TARGET + " = ?, " +
            ModelTask.COL_TIME_DONE + " = ?, " +
            ModelTask.COL_TIME_SORT + " = ?, " +
            ModelTask.COL_STATUS + " = ? " +
            " WHERE " + ModelTask.COL_ID + " = " + String(id) + "; "
    }
    //更新状态语句
    static func UpdateCheck(id: Int) -> String
    {
        return "UPDATE " + TableName() + " SET " +
            ModelTask.COL_TIME_DONE + " = ?, " +
            ModelTask.COL_STATUS + " = ? " +
            " WHERE " + ModelTask.COL_ID + " = " + String(id) + "; "
    }
    //更新位置语句
    static func UpdatePosition(id: Int) -> String
    {
        return "UPDATE " + TableName() + " SET " +
            ModelTask.COL_TIME_SORT + " = ? " +
            " WHERE " + ModelTask.COL_ID + " = " + String(id) + "; "
    }
    //删除数据语句
    static func Delete(id: Int) -> String
    {
        return "DELETE FROM " + TableName() + " WHERE " + ModelTask.COL_ID + " = " + String(id) + "; "
    }
    //查询所有语句
    static func QueryAll() -> String
    {
        return "SELECT * FROM " + TableName() + "; "
    }
    //根据时间查询所有语句
    static func QueryAllByTime(param: String) -> String
    {
        var p = ""
        switch param
        {
            case "today":
                break
            case "all":
                break
            case "todo":
                p = " WHERE status = 0 "
            case "done":
                p = " WHERE status = 1 "
            default:
                break
        }
        return "SELECT * FROM " + TableName() + p + " ORDER BY " + ModelTask.COL_TIME_SORT + " DESC; "
    }
    //根据id查询语句
    static func QueryByID(id: Int) -> String
    {
        return "SELECT * FROM " + TableName() + " WHERE " + ModelTask.COL_ID + " = " + String(id) + "; "
    }
    
}

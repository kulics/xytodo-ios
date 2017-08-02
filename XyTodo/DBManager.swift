import Foundation
//数据库管理器
class DBManager
{
    var helper:DBHelper!
    
    init()
    {
        helper = DBHelper()
    }
    
    //清空数据库
    func DBClear()
    {
        let db = helper.GetDBConnection()
        
        _ = db.execute(sql:TableTask.TableUpgrade())
        _ = db.execute(sql:TableTask.TableCreate())
        
        _ = db.execute(sql:TableTaskSub.TableUpgrade())
        _ = db.execute(sql:TableTaskSub.TableCreate())
    }
    
    //获取所有任务
    func TaskGetAll(param: String) -> [ModelTask]
    {
        //创建保存数组
        var rList = [ModelTask]()
        //创建查询语句
        let data = helper.GetDBConnection().query(sql: TableTask.QueryAllByTime(param: param))
        
        for item in data
        {
            //创建临时数据
            let temp = ModelTask()
            //装载数据
            temp.id = item[ModelTask.COL_ID] as! Int
            temp.content = item[ModelTask.COL_CONTENT] as! String
            temp.note = item[ModelTask.COL_NOTE] as! String
            temp.color = item[ModelTask.COL_COLOR] as! String
            temp.timeCreate = item[ModelTask.COL_TIME_CREATE] as! Int
            temp.timeTarget = item[ModelTask.COL_TIME_TARGET] as! Int
            temp.timeDone = item[ModelTask.COL_TIME_DONE] as! Int
            temp.timeSort = item[ModelTask.COL_TIME_SORT] as! Int
            temp.status = item[ModelTask.COL_STATUS] as! Int
            //加入数组
            rList.append(temp)
        }
        //返回数据
        return rList
    }
    
    //获取任务
    func TaskGet(id: Int) -> ModelTask
    {
        let temp = ModelTask()
        
        let result = helper.GetDBConnection().query(sql: TableTask.QueryByID(id: id))
        
        let item = result[0]
        
        temp.id = item[ModelTask.COL_ID] as! Int
        temp.content = item[ModelTask.COL_CONTENT] as! String
        temp.note = item[ModelTask.COL_NOTE] as! String
        temp.color = item[ModelTask.COL_COLOR] as! String
        temp.timeCreate = item[ModelTask.COL_TIME_CREATE] as! Int
        temp.timeTarget = item[ModelTask.COL_TIME_TARGET] as! Int
        temp.timeDone = item[ModelTask.COL_TIME_DONE] as! Int
        temp.timeSort = item[ModelTask.COL_TIME_SORT] as! Int
        temp.status = item[ModelTask.COL_STATUS] as! Int
        
        return temp;
    }
    
    //添加任务
    func TaskAdd(model: ModelTask) -> Int
    {
        let db = helper.GetDBConnection()
        
        var params = [Any]()
        params.append(model.content)
        params.append(model.note)
        params.append(model.color)
        params.append(model.timeCreate)
        params.append(model.timeTarget)
        params.append(model.timeDone)
        params.append(model.timeSort)
        params.append(model.status)
        
        //使用最终插入的id来绑定
        let id =  db.execute(sql: TableTask.Insert(), parameters: params)
        //遍历添加自定义
        for item in model.sub
        {
            item.idTask = id
            TaskSubAdd(model: item)
        }
        return id
    }
    
    //更新任务状态
    func TaskCheck(model: ModelTask)
    {
        let db = helper.GetDBConnection()
        var params = [Any]()
        params.append(model.timeDone)
        params.append(model.status)

        _ = db.execute(sql: TableTask.UpdateCheck(id: model.id), parameters: params)
    }
    
    //更新位置
    func TaskPosition(model: ModelTask)
    {
        let db = helper.GetDBConnection()
        var params = [Any]()
        params.append(model.timeSort)
        
        _ = db.execute(sql: TableTask.UpdatePosition(id: model.id), parameters: params)
    }
    
    //更新任务
    func TaskUpdate(model: ModelTask) {
        let db = helper.GetDBConnection()
        var params = [Any]()
        params.append(model.content)
        params.append(model.note)
        params.append(model.color)
        params.append(model.timeTarget)
        params.append(model.timeDone)
        params.append(model.timeSort)
        params.append(model.status)
        
        _ = db.execute(sql: TableTask.Update(id: model.id), parameters: params)
        
        //先删除后添加
        _ = db.execute(sql: TableTaskSub.Delete(id: model.id))
        //遍历添加自定义
        for item in model.sub
        {
            item.idTask = model.id
            TaskSubAdd(model: item)
        }
    }
    
    //删除任务
    func TaskDelete(model: ModelTask)
    {
        let db = helper.GetDBConnection()
        _ = db.execute(sql: TableTask.Delete(id: model.id))
        _ = db.execute(sql: TableTaskSub.Delete(id: model.id))
    }
    
    //获取子任务
    func TaskSubGet(id_task: Int) -> [ModelTaskSub]
    {
        //创建保存数组
        var rList = [ModelTaskSub]()
        //创建查询语句
        let data = helper.GetDBConnection().query(sql: TableTaskSub.QueryAllByID(id: id_task))
        
        for item in data
        {
            //创建临时数据
            let temp = ModelTaskSub()
            //装载数据
            temp.id = item[ModelTaskSub.COL_ID] as! Int
            temp.idTask = item[ModelTaskSub.COL_ID_TASK] as! Int
            temp.content = item[ModelTaskSub.COL_CONTENT] as! String
            temp.status = item[ModelTaskSub.COL_STATUS] as! Int
            //加入数组
            rList.append(temp)
        }
        //返回数据
        return rList
    }
    
    //添加子任务
    func TaskSubAdd(model: ModelTaskSub)
    {
        let db = helper.GetDBConnection()
        
        var params = [Any]()
        params.append(model.idTask)
        params.append(model.content)
        params.append(model.status)
        
        _ = db.execute(sql: TableTaskSub.Insert(), parameters: params)
    }
}

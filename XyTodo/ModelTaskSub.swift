import Foundation

//子任务模型
class ModelTaskSub: ModelBase
{
    static let COL_ID = "id"
    static let COL_ID_TASK = "id_task"
    static let COL_CONTENT = "content"
    static let COL_STATUS = "status"
    
    var id = 0
    var idTask = 0
    var content = ""
    var status = 0
}

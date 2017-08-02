import Foundation

//任务模型
class ModelTask: ModelBase
{
    static let COL_ID = "id"
    static let COL_CONTENT = "content"
    static let COL_NOTE = "note"
    static let COL_COLOR = "color"
    static let COL_TIME_CREATE = "time_create"
    static let COL_TIME_TARGET = "time_target"
    static let COL_TIME_DONE = "time_done"
    static let COL_TIME_SORT = "time_sort"
    static let COL_STATUS = "status"
    
    var id = 0
    var content = ""
    var note = ""
    var color = ""
    var timeCreate = 0
    var timeTarget = 0
    var timeDone = 0
    var timeSort = 0
    var status = 0
    var sub = [ModelTaskSub]()
}

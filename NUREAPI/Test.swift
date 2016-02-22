import Foundation

let apiRoot = NSURL(string: "http://cist.nure.ua/ias/app/tt/")!
print(apiRoot)
let apiGroupJson = apiRoot.URLByAppendingPathComponent("P_API_GROUP_JSON")
print(apiGroupJson)
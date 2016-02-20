# SwiftyNURE #
### OS X framework for operating with NURE CIST API. Written on Swift. ###
Guides coming soon.

### Example ###

```
#!swift

let today = NSDate()
let nextWeek = today.dateByAddingTimeInterval(7 * 24 * 60 * 60)
let provider = TimetableProvider.Remote(forGroupID: groupID, fromDate: today, toDate: nextWeek) { timetable in
    print(timetable)
    // Operate with Timetable
}
provider.error = { error in
    print(error)
    // Handle the error
}
provider.execute()
```
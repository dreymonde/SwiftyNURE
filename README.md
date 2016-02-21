# SwiftyNURE #
### Swift-фреймворк для OS X. ###
Guides coming soon.

### Инструкции ###
Основа каркаса - поставщики (Providers). Все поставщики имплементируют протокол Receivable.

```swift
let universityProvider = UniversityProvider.Remote() { nure in
	let groups = nure.groups // [Group]
	let teachers = nure.teachers // [Teacher.Extended]
}
universityProvider.error = { error in
	print(error)
}
universityProvider.execute()
```
Обработка ошибок опциональна, но поставщика обязательно нужно "запустить". Если отказаться от отработчика ошибок, можно слегка упростить код:

```swift
let universityProvider = UniversityProvider.Remote() { nure in
	let groups = nure.groups // [Group]
	let teachers = nure.teachers // [Teacher.Extended]
}.execute()
```
University - объект, содержащий в себе массив учителей (Teacher.Extended) и групп (Group).

```swift
let id = teacher.id // Int
let fullName = teacher.fullName // String
let shortName = teacher.shortName // String
let facultyShortName = teacher.faculty.short // String
let facultyFullName = teacher.faculty.full // String
let departmentShortName = teacher.department.short // String
let departmentFullName = teacher.department.full // String

let groupId = group.id // Int
let name = group.name // String
```
Для получения расписания существует поставщик расписания (TimetableProvider):

```swift
// Расписания от сегодня до конца следующей недели
let date = NSDate.today()
let nextWeek = today.dateByAddingTimeInterval(7 * 24 * 60 * 60)
let timetableProvider = TimetableProvider.Remote(forGroupId: group.id, fromDate: today, toDate: nextWeek) { timetable in
	// Operate with timetable
}
timetableProvider.error = { error in
	print(error)
}
timetableProvider.execute()

// Расписание на весь семестр
let timetableProvider = TimetableProvider.Remote(forGroupId: group.id) { timetable in
	// Operate with timetable
}
timetableProvider.error = { error in
	print(error)
}
timetableProvider.execute()
```
Timetable - коллекция объектов типа Eventable.

```swift
public protocol Eventable {
    
    var subject: Subject { get }
    var teachers: [Teacher] { get }
    var auditory: String { get }
    var groups: [Group] { get }
    var type: EventType { get }
    var number: Int { get }
    
    var startDate: NSDate { get }
    var endDate: NSDate { get }
    
}
```
### Оперирование информацией ###
Университет может быть закодирован в NSData и обратно:

```swift
// To NSData
let binary = university.toData() // NSData?

// From NSData
if let university = University(withData: binary) {
	print(university.groups)
}
```
Поддержка этой возможности для Timetable появится в ближайшем релизе.

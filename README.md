![SwiftyNURE](/SwiftyNURELogo.jpg)
# SwiftyNURE #

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Максимально простой Swift-фреймворк для общения с cist.nure.ua.

На данный момент работает только с OS X. В ближайшее время планируется адаптация для iOS/watchOS/tvOS, а также выпуск сборки под Linux.

### Требования ###
- OS X 10.10+
- Xcode 7

### Интеграция ###
Вы можете легко интегрировать SwiftyNURE с вашим проектом с помощью [Carthage](https://github.com/Carthage/Carthage). Просто добавьте в ваш Cartfile:
```
github "dreymonde/SwiftyNURE"
```

### Дорожная карта ###
- [ ] Убрать зависимость от SwiftyJSON
- [ ] Добавить поддержку iOS, watchOS, tvOS
- [ ] Добавить поддержку Linux

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
Обработка ошибок опциональна, но поставщика обязательно нужно "запустить". Если отказаться от обработчика ошибок, можно слегка упростить код:

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
Также существуют поставщики групп (RemoteGroupsProvider) и предодавателей (TeachersProvider.Remote), которые, по факту, "запакованы" в UniversityProvider. Их отличительной особенностью является возможность фильтрованного запроса:
```swift
let provider = TeachersProvider.Remote(matching: "Каук") { teachers in
    print(teachers)
}.execute()
```
Группы фильтруются по названию, преподаватели - по имени, кафедре (как по полному, так и сокращённому названию) и факультету (аналогично).

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
Это же работает и для Timetable:
```swift
// To NSData
let data = timetable.toData() // NSData?

// From NSData
if let timetable = Timetable(withData: data) {
    print(timetable.events(forDay: NSDate()))
}
```
Эти возможности заданы протоколом DataObject, который имплементируют практически все типы SwiftyNURE.
```swift
public protocol DataEncodable {
    var toData: NSData? { get }
}
public protocol DataDecodable {
    init?(withData data: NSData)
}
public protocol DataObject: DataEncodable, DataDecodable {  }
```
"Под капотом" все эти объекты имплементируют протокол JSONObject: JSONEncodable, JSONDecodable, который наследует DataObject и автоматически конвертирует JSON в NSData. Для работы с JSON используется фреймворк SwitfyJSON. Добавив его в свой проект, вы сможете напрямую обращаться к методам протокола:
```swift
let universityJson = university.toJSON // JSON
let kaukJson = teacher.toJSON // JSON
let timetable = Timetable(withJSON: timetableJson) // Timetable?
```
> Внимание! JSON-объекты, получаемые в результате использования свойства .toJSON, **не** являются идентичными тем, которые получаются в результате запросов к серверам CIST.

Учтите, что структуры Teacher и Teacher.Extended, имплементирующие протокол TeacherType, различаются. Teacher не содержит в себе информации о кафедре и факультете. Teacher тип можно в стретить в объектах Event, Teacher.Extended - в University.

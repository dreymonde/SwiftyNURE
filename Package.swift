import PackageDescription

let package = Package(
    name: "SwiftyNURE", dependencies: [
        .Package(url: "https://github.com/dreymonde/EezehRequests.git", majorVersion: 0, minor: 2)
    ]
)
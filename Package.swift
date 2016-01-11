import PackageDescription

let package = Package(
    name: "NSV",
	dependencies: [
		.Package(url: "../CPNG", majorVersion: 1)
	]
)

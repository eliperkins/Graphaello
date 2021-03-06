// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Graphaello",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "graphaello", targets: ["Graphaello"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", .upToNextMajor(from: "0.27.0")),
        .package(url: "https://github.com/nerdsupremacist/CLIKit.git", .branch("master")),
        .package(url: "https://github.com/nerdsupremacist/Ogma.git", .branch("master")),
        .package(url: "https://github.com/nerdsupremacist/Stencil.git", .upToNextMajor(from: "0.13.2")),
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "7.5.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", .upToNextMajor(from: "0.42.0")),
        .package(url: "https://github.com/apple/swift-syntax.git", .upToNextMajor(from: "0.50100.0")),
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(name: "Graphaello", dependencies: [
          "SourceKittenFramework",
          "CLIKit",
          "Ogma",
          "Stencil",
          "XcodeProj",
          "PathKit",
          "SwiftFormat",
          "SwiftSyntax",
        ]),
    ]
)

# DataKit

[![Run DataKit macOS Tests](https://github.com/valdal14/DataKit/actions/workflows/ci.yml/badge.svg)](https://github.com/valdal14/DataKit/actions/workflows/ci.yml)

DataKit is a lightweight Swift package designed to provide reusable and efficient implementations of fundamental data structures. Built with Swift's concurrency model in mind, these data structures are implemented as **actors** to ensure thread-safety and easy integration into concurrent applications. DataKit focuses on clarity, performance, and seamless integration across your Swift projects.

## 📖 Table of Contents

* [✨ Features](#-features)
* [🚀 Implemented Data Structures](#-implemented-data-structures)
* [📦 Installation](#-installation)
    * [Swift Package Manager](#swift-package-manager)
* [📚 Usage](#-usage)
    * [DataKitLinkedList](#datakitlinkedlist)
    * [DataKitStack](#datakitstack)
    * [DataKitQueue](#datakitqueue)
    * [DataKitHashTable](#datakithashtable)
* [🤝 Contributing](#-contributing)
* [📄 License](#-license)

## ✨ Features

* **Core Data Structures:** Provides essential implementations like Linked Lists, Stacks, Queues, and Hash Tables.
* **Concurrency Safe:** All data structures are implemented as `actor`s, providing built-in thread-safety and simplifying concurrent access.
* **Pure Swift:** Built entirely in Swift, ensuring seamless compatibility and idiomatic usage within Swift applications.
* **Efficiency:** Implementations are optimized for common operations, balancing performance with readability.
* **Type Safety:** Leverages custom protocols (`DataKitCompatible`, `DataKitHashable`) to enforce specific behaviors and compatibility for stored types.
* **Clear & Concise:** Code is written with clarity in mind, making it excellent for educational purposes or quick integration.

## 🚀 Implemented Data Structures

Currently, DataKit includes robust implementations for the following data structures:

* **`actor DataKitLinkedList<T: DataKitCompatible>`**: A versatile, thread-safe doubly linked list.
* **`actor DataKitStack<T: DataKitCompatible>`**: A thread-safe Last-In, First-Out (LIFO) collection.
* **`actor DataKitQueue<T: DataKitCompatible>`**: A thread-safe First-In, First-Out (FIFO) collection.
* **`actor DataKitHashTable<T: DataKitHashable>`**: An efficient, thread-safe key-value store, built using `DataKitHashTableFactory`.

## 📦 Installation

DataKit is distributed as a Swift Package and can be easily added to your Xcode project or Swift package.

### Swift Package Manager

To integrate DataKit into your Xcode project using Swift Package Manager:

1.  In Xcode, select `File` > `Add Packages...`.
2.  In the search bar, enter the DataKit repository URL: `https://github.com/valdal14/DataKit.git`
3.  Choose the desired version (e.g., `Up to Next Major Version`) and click `Add Package`.

Alternatively, add it to your `Package.swift` dependencies:

```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(url: "[https://github.com/valdal14/DataKit.git](https://github.com/valdal14/DataKit.git)", from: "1.0.0") // Use your desired version
    ],
    targets: [
        .target(
            name: "YourProjectTarget",
            dependencies: ["DataKit"]
        )
    ]
)
```

## 📚 Usage

### TODO...

## 🤝 Contributing

We welcome and appreciate contributions to DataKit! If you're interested in helping improve this project, please consider the following:

* **Reporting Bugs:**
    * If you find any issues, please open a new issue on the GitHub repository.
* **Suggesting Features:**
    * Have an idea for a new data structure or an enhancement? Open an issue to discuss it.
* **Submitting Pull Requests:**
    * Fork the repository and create your branch from `main`.
    * Ensure your code adheres to Swift's style guidelines.
    * Write comprehensive tests for any new features or bug fixes.
    * Ensure all existing tests pass.
    * Submit your pull request with a clear description of your changes.

## 📄 License

This project is licensed under the **MIT License**.

For the full text of the license, please see the [LICENSE](LICENSE) file in the root of this repository.

# DataKit

[![Run DataKit macOS Tests](https://github.com/valdal14/DataKit/actions/workflows/ci.yml/badge.svg)](https://github.com/valdal14/DataKit/actions/workflows/ci.yml)

DataKit is a lightweight Swift **framework** designed to provide reusable and efficient implementations of fundamental data structures. Built with Swift's concurrency model in mind, these data structures are implemented as **actors** to ensure thread-safety and easy integration into concurrent applications. DataKit focuses on clarity, performance, and seamless integration across your Swift projects.

## 📖 Table of Contents

* [✨ Features](#-features)
* [🚀 Implemented Data Structures](#-implemented-data-structures)
* [📥 Installation](#-installation)
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


## 📥 Installation

To integrate DataKit into your Xcode project as a framework, follow these steps:

### 1. Clone the Repository

First, clone the DataKit repository to your local machine:

```bash
git clone [https://github.com/valdal14/DataKit.git](https://github.com/valdal14/DataKit.git)
```

### 2. Build the Framework

Open the DataKit Xcode project and build the framework target:

1.  Open `DataKit/DataKit.xcodeproj` in Xcode.
2.  In the Xcode project navigator, select the `DataKit` target under `Targets`.
3.  Choose your desired build scheme (e.g., `DataKit iOS` or `DataKit macOS` depending on your target platform) and build the project (`Product` > `Build`).
4.  Once the build is successful, navigate to the `Products` folder in the project navigator (it might be hidden; expand it if necessary).
5.  Right-click on `DataKit.framework` and select `Show in Finder`. This will open the directory containing the built framework.

### 3. Add Framework to Your Project

Now, add the `DataKit.framework` file to your application or framework target:

1.  Open your own Xcode project.
2.  In your project navigator, select your project.
3.  Select your application or framework target under `Targets`.
4.  Go to the `General` tab.
5.  Scroll down to the `Frameworks, Libraries, and Embedded Content` section.
6.  Click the `+` button to add new frameworks.
7.  Select `Add Other...` then `Add Files...`.
8.  Navigate to where you found `DataKit.framework` in Finder (from step 2.5) and select it.
9.  In the dialog that appears, choose `Do Not Embed` for a dynamic framework that your app links to (recommended for frameworks), or `Embed & Sign` if you're building an application and want the framework directly bundled.
10. Ensure that `DataKit.framework` is listed under `Frameworks, Libraries, and Embedded Content`.

You should now be able to `import DataKit` in your Swift files!

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

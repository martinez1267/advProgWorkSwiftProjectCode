//TaskView.swift
public protocol View{

associatedtype Body: View
@ViewBuilder var body: Self.Body { get }

struct TaskView: View {
let title: String
	var body: some View {
		Text("Take out the trash")
		.background(Color.yellow)
		.padding(.vertical, 50)
		.font(.title3)
		}
}

struct TaskCell_Previews: PreviewProvider {
	static var previews: some View {
		TaskView(title: "Take out the trash")
	}
}



//Task.swift

import Foundation
struct Task: Equatable, Identifiable {
	let id: UUID
	let title: String

	init(title: String) {
		self.id = UUID()
		self.title = title
	}
}






//TaskStore.swift
import Foundation
class TaskStore: ObservableObject {
	@Published private(set) var tasks: [Task] = [] {
	didSet {
		#warning("Remove this when I'm done with it")
		print("There are now \(tasks.count): \(tasks)")
		}
	}

func add(_ task: Task) {
	tasks.append(task)
}
func remove(_ task: Task) {
	guard let index = tasks.firstIndex(of: task) else { return }
	tasks.remove(at: index)
}
}

#if DEBUG
extension TaskStore {
	static var sample: TaskStore = {
		let tasks = [
			Task(title: "Add features"),
			Task(title: "Fix bugs"),
			Task(title: "Ship it")
			]
		let store = TaskStore()
		store.tasks = tasks
		return store
	}()
}
#endif




//TaskListView.swift
import SwiftUI
struct TaskListView: View {
@ObservedObject var taskStore: TaskStore
var taskStore: TaskStore
var body: some View
	List {
			TaskView(title: "Take out the trash"),
			TaskView(title: "Do the dishes"),
			TaskView(title: "Learn Swift")
	}
}
}

struct TaskListView_Previews: PreviewProvider {
	static var previews: some View {
		TaskListView(taskStore: .sample)
	}
}

struct TaskListView: View {
	var body: some View {
		List {
				ForEach(taskStore.task) { task in
						TaskView(title: task.title)
						}.onDelete { indexSet in
							indexSet.forEach { index in
								let task = taskStore.task[index]
								taskStore.remove(task)
								}
							}
					}
				}
}



//tahDoodleApp.swift
@main
struct TahDoodleApp: App{
	var body: some Scene{
		WindowGroup {
			ContentView(taskStore: .sample)
			}
		}
}


//contentView.swift
import SwiftUI
struct ContentView: View {
	
	let taskStore: TaskStore
	@state private var newTaskTitle = ""

private var newTaskView: some View {
	HStack {
	TextField("Something to do", text: $newTaskTitle)
	Button("Add Task") {
		
		let task = Task(title: newTaskTitle)
		taskStore.add(task)
		newTaskTitle = ""
	}.disabled(newTaskTitle.isEmpty)
	}.padding()
}


	var body: some View {
	VStack {
		newTaskView
		TaskListView(taskStore: taskStore)
		}
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
			ContentView(taskStore: .sample)
		}
	}
}

}
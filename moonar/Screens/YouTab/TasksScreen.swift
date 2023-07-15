//
//  TasksScreen.swift
//  moonar
//
//  Created by Владислав Калиниченко on 27.05.2022.
//

import SwiftUI

struct FullTask: View {
	let text: String
	let id: Int
	@EnvironmentObject var boolState: TaskViewModel
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 7)
				.foregroundColor(Color.white)
				.frame(minHeight: 50)
				.padding(.horizontal, 10)
				.padding(.vertical, 10)
			HStack {
				VStack(spacing: 0) {
					Spacer()
					Button(action: {
						boolState.tickTask(id: id)
					}) {
						Image(systemName: boolState.fetchedEntitiesAsBooleans[id] ? "checkmark.circle.fill" : "checkmark.circle")
							.padding(.leading, 30)
							.padding(.trailing, 10)
							.scaleEffect(1.5)
							.foregroundColor(Color.white)
					}
					Spacer()
				}
				VStack(spacing: 0) {
					Text(text)
						.foregroundColor(Color.white)
						.padding([.vertical, .trailing], 25)
						.font(.title3.weight(.medium))
						.multilineTextAlignment(.leading)
				}
			}
		}
	}
}

struct TasksScreen: View {
	let name: String
	@EnvironmentObject var taskList: TaskViewModel
	@State var SelectionControl = SelectionValues.todo

    var body: some View {
		ZStack {
			Background(color: Color.black)
			
			VStack {
				Picker("To do", selection: $SelectionControl) {
					Text("To do").tag(SelectionValues.todo)
					Text("Done").tag(SelectionValues.done)
				}
				.pickerStyle(.segmented)
				
				switch(SelectionControl) {
					case .todo:
						ScrollView() {
							ForEach(taskList.fetchedEntitiesAsStrings.indices, id: \.self) { i in
								if taskList.fetchedEntitiesAsBooleans[i] == false {
									FullTask(text: taskList.fetchedEntitiesAsStrings[i], id: i)
								}
							}

							Color(.clear)
								.frame(height: 300)
						}
					case .done:
						ScrollView() {
							ForEach(taskList.fetchedEntitiesAsStrings.indices, id: \.self) { i in
								if taskList.fetchedEntitiesAsBooleans[i] == true {
									FullTask(text: taskList.fetchedEntitiesAsStrings[i], id: i)
								}
							}

							Color(.clear)
								.frame(height: 300)
						}
				}
			}
		}
		.navigationTitle(name)
		.navigationBarTitleDisplayMode(.inline)
    }
}

struct TasksScreen_Previews: PreviewProvider {
    static var previews: some View {
		TasksScreen(name: "Tasks for you")
    }
}

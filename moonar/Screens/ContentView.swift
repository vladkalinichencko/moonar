//
//  ContentView.swift
//  moonar
//
//  Created by Владислав Калиниченко on 18.06.2022.
//

import SwiftUI

struct ContentView: View {
	@State var isLaunchingAppSecondTime = NSUbiquitousKeyValueStore.default.bool(forKey: UbiquitousKeys[0])
	@StateObject var boolState: BoolStates = BoolStates()
	@StateObject var textThoughtDB = TextThoughtViewModel(entityName: "TextThought")
	@StateObject var audioThoughtDB = AudioThoughtViewModel(entityName: "AudioThought")
	@StateObject var taskDB = TaskViewModel(entityName: "MoonarTask")
	@StateObject var AdviceDB = AdviceViewModel(entityName: "MoonarAdvice")
	@StateObject var audioController = AudioViewModel()
	@StateObject var moonarActions = MoonarViewModel()
	@StateObject var storeController = Subscription()

    var body: some View {
		if !isLaunchingAppSecondTime {
			OnboardingScreen(isLaunchingAppSecondTime: $isLaunchingAppSecondTime)
				.onAppear() {
					NSUbiquitousKeyValueStore.default.set(isLaunchingAppSecondTime, forKey: UbiquitousKeys[0])
					NSUbiquitousKeyValueStore.default.synchronize()
				}
				.environmentObject(storeController)
		}
		else {
			TabScreen()
				.environmentObject(textThoughtDB)
				.environmentObject(audioThoughtDB)
				.environmentObject(taskDB)
				.environmentObject(AdviceDB)
				.environmentObject(boolState)
				.environmentObject(audioController)
				.environmentObject(moonarActions)
				.environmentObject(storeController)
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

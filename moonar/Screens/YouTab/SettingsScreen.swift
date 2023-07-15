//
//  SettingsScreen.swift
//  moonar
//
//  Created by Владислав Калиниченко on 20.05.2022.
//

import SwiftUI

struct SettingsScreen: View {
	@State private var userName = NSUbiquitousKeyValueStore.default.string(forKey: UbiquitousKeys[1]) ?? ""
	@State private var userGender = NSUbiquitousKeyValueStore.default.string(forKey: UbiquitousKeys[2]) ?? ""
	@State private var userDate = NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[3]) as? Date ?? Date()
	@State private var userDiseases = NSUbiquitousKeyValueStore.default.array(forKey: UbiquitousKeys[4]) as? [Bool] ?? userDiseaseBools
	@State var wakeUpTime = NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[5]) as? Date ?? Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
	@State var goBedTime = NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[6]) as? Date ?? Calendar.current.date(from: DateComponents(hour: 20, minute: 0))!
	
	@State var showSheet = false
	@State var showAlert = false
	@State private var isShowingSubscriptionFinalOfferSheet = false
	@State private var isShowingResourcesSheet = false
	
	@Binding var emotionColor: Color
	
	@EnvironmentObject var textEntityToDelete: TextThoughtViewModel
	@EnvironmentObject var audioEntityToDelete: AudioThoughtViewModel
	@EnvironmentObject var adviceEntityToDelete: AdviceViewModel
	@EnvironmentObject var taskEntityToDelete: TaskViewModel
	@EnvironmentObject var audioController: AudioViewModel
	@EnvironmentObject var boolStates: BoolStates
	@EnvironmentObject var storeController: Subscription
	@EnvironmentObject var moonarActions: MoonarViewModel
	
    var body: some View {
		ZStack {
			Background(color: Color.black)
			
			ScrollView {
				VStack(alignment: .leading, spacing: 0) {
					Text("Your account")
						.foregroundColor(Color.white)
						.font(.title.weight(.heavy))
						.padding(.top, 10)
					
					VStack(alignment: .leading, spacing: 20) {
						TextField("Please enter your name", text: $userName)
							.onSubmit {
								NSUbiquitousKeyValueStore.default.set(userName, forKey: UbiquitousKeys[1])
								NSUbiquitousKeyValueStore.default.synchronize()
							}
						
						HStack {
							Text("Select your gender")
							
							Spacer()
							
							Picker("Select your gender", selection: $userGender) {
								ForEach(StringGenderOptions, id: \.self) { text in
									Text(text)
								}
							}
							.pickerStyle(.menu)
							.onChange(of: userGender, perform: { _ in
								NSUbiquitousKeyValueStore.default.set(userGender, forKey: UbiquitousKeys[2])
								NSUbiquitousKeyValueStore.default.synchronize()
							})
						}
						
						DatePicker("Select your birthdate", selection: $userDate, in: ...Date(), displayedComponents: .date)
							.onChange(of: userDate, perform: { _ in
								NSUbiquitousKeyValueStore.default.set(userDate, forKey: UbiquitousKeys[3])
								NSUbiquitousKeyValueStore.default.synchronize()
							})
						
						Button(action: {
							showSheet.toggle()
						}) {
							Text("Choose your symptoms")
						}
						.sheet(isPresented: $showSheet, content: {
							AnyView(
								PickUpFormSheet(
									pickUpList: symptomOptions,
									sheetPickedUpValues: $userDiseases,
									color: .constant(Color.white),
									textColor: .constant(Color.black),
									action: {
										NSUbiquitousKeyValueStore.default.set(userDiseases, forKey: UbiquitousKeys[4])
										NSUbiquitousKeyValueStore.default.synchronize()
									}
								)
							)
						})
					}
					.padding(20)
					.overlay(
						RoundedRectangle(cornerRadius: 15)
							.stroke(Color.white, lineWidth: 7)
							.foregroundColor(Color.clear)
					)
					.padding(.vertical)
					
					Text("Your timetable")
						.foregroundColor(Color.white)
						.font(.title.weight(.heavy))
						.padding(.top, 40)
					
					VStack(alignment: .leading, spacing: 20) {
						DatePicker("When do you wake up?", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
							.onChange(of: wakeUpTime, perform: { _ in
								NSUbiquitousKeyValueStore.default.set(wakeUpTime, forKey: UbiquitousKeys[5])
								NSUbiquitousKeyValueStore.default.synchronize()
							})
						DatePicker("When do you go to bed?", selection: $goBedTime, displayedComponents: .hourAndMinute)
							.onChange(of: goBedTime, perform: { _ in
								NSUbiquitousKeyValueStore.default.set(goBedTime, forKey: UbiquitousKeys[6])
								NSUbiquitousKeyValueStore.default.synchronize()
							})
					}
					.onDisappear() {
						moonarActions.removeRequests()
						
						moonarActions.scheduleNotification(title: "Good morning!", text: "How do you feel?", date: (NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[5]) as? NSDate ?? Calendar.current.date(from: DateComponents(hour: 9, minute: 0))! as NSDate))
						
						moonarActions.scheduleNotification(title: "Before you fall asleep...", text: "Tell me about your day", date: (NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[6]) as? NSDate ?? Calendar.current.date(from: DateComponents(hour: 20, minute: 0))! as NSDate))
					}
					.padding(20)
					.overlay(
						RoundedRectangle(cornerRadius: 15)
							.stroke(Color.white, lineWidth: 7)
							.foregroundColor(Color.clear)
					)
					.padding(.vertical)
					
					if !storeController.isUserSubscribed {
						Text("Subscription")
							.foregroundColor(Color.white)
							.font(.title.weight(.heavy))
							.padding(.top, 40)
					
						VStack(alignment: .leading, spacing: 20) {
								Text("Your trial period ends in \(storeController.trialDaysRemained()) days")
								
								HStack {
									Button(action: {
										isShowingSubscriptionFinalOfferSheet = true
									}) {
										Text("Subscribe")
											.fontWeight(.bold)
											.gradientForeground(gradient: greenGradient)
									}
									.sheet(isPresented: $isShowingSubscriptionFinalOfferSheet, content: {
										AnyView(
											SubscriptionFinalOfferSheet(daysRemained: 7)
										)
									})
									
									Spacer()
								}
							
//							else {
//								HStack {
//									Text("Your subscription expires in \(storeController.nextWithdrawalDaysRemained) days")
//
//									Spacer()
//								}
//							}
						}
						.padding(20)
						.overlay(
							RoundedRectangle(cornerRadius: 15)
								.stroke(Color.white, lineWidth: 7)
								.foregroundColor(Color.clear)
						)
						.padding(.vertical)
					}
					
					Text("Other")
						.foregroundColor(Color.white)
						.font(.title.weight(.heavy))
						.padding(.top, 40)
					
					HStack {
						VStack(alignment: .leading, spacing: 20) {
							Link("Our Instagram community", destination: URL(string: "https://www.instagram.com/moonar.app/")!)
								.fontWeight(.bold)
								.foregroundColor(Color.white)
							
							Link("Privacy Policy", destination: URL(string: "https://sites.google.com/view/moonar-privacy-policy/")!)
								.foregroundColor(Color.white)
							
							Link("Terms of Use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
								.foregroundColor(Color.white)
							
							Button(action: {
								isShowingResourcesSheet.toggle()
							}) {
								Text("Resources")
									.foregroundColor(Color.white)
							}
							.sheet(isPresented: $isShowingResourcesSheet, content: {
								AnyView(
									ResourcesSheet()
								)
							})
							
							Button(action: {
									showAlert = true
							}) {
								Text("Delete all app's data")
									.foregroundColor(Color.red)
							}
							.alert("This will delete all data and settings you or moonar generated, as well as your personal information", isPresented: $showAlert) {
								Button("Erase", role: .destructive) {
									for emotionKey in EmotionsUbiquitousKeys {
										NSUbiquitousKeyValueStore.default.removeObject(forKey: emotionKey)
									}
									
									for valueKey in UbiquitousKeys {
										if valueKey != "Is launching app first time" &&
											valueKey != "First subscription offer date" &&
											valueKey != "Subscription sheet showed second time" {
											NSUbiquitousKeyValueStore.default.removeObject(forKey: valueKey)
											
											print(NSUbiquitousKeyValueStore.default.string(forKey: valueKey) as Any)
										}
									}
									
									textEntityToDelete.deleteEntity()
									audioEntityToDelete.deleteEntity()
									adviceEntityToDelete.deleteEntity()
									taskEntityToDelete.deleteEntity()
									
									audioController.deleteAudioFiles()
									
									exit(0)
								}
								Button("Cancel", role: .cancel) {}
							}
						}
						Spacer()
					}
					.padding(20)
					.overlay(
						RoundedRectangle(cornerRadius: 15)
							.stroke(Color.white, lineWidth: 7)
							.foregroundColor(Color.clear)
					)
					.padding(.vertical)
					
					Color(.clear)
						.frame(height: 100)
				}
				.padding(20)
			}
		}
		.accentColor(emotionColor)
		.navigationTitle("Settings")
		.navigationBarTitleDisplayMode(.large)
		.onAppear() {
			userName = NSUbiquitousKeyValueStore.default.string(forKey: UbiquitousKeys[1]) ?? ""
			userGender = NSUbiquitousKeyValueStore.default.string(forKey: UbiquitousKeys[2]) ?? ""
			userDate = NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[3]) as? Date ?? Date()
			userDiseases = NSUbiquitousKeyValueStore.default.array(forKey: UbiquitousKeys[4]) as? [Bool] ?? userDiseaseBools
			wakeUpTime = NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[5]) as? Date ?? Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
			goBedTime = NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[6]) as? Date ?? Calendar.current.date(from: DateComponents(hour: 20, minute: 0))!
		}
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
		SettingsScreen(emotionColor: .constant(redColor))
			.preferredColorScheme(.dark)
    }
}

//
//  SourceOfTruth.swift
//  moonar
//
//  Created by Владислав Калиниченко on 20.06.2022.
//

import Foundation
import CoreData
import AVFoundation
import NaturalLanguage
import UserNotifications
import Speech
import StoreKit

class TextThoughtViewModel: ObservableObject {
	let container: NSPersistentContainer
	let entityName: String
	@Published var fetchedEntities: [TextThought] = []
	@Published var fetchedEntitiesAsStrings: [String] = []

	init(entityName: String) {
		self.entityName = entityName
		container = NSPersistentCloudKitContainer(name: "MoonarDataModel")
		container.loadPersistentStores { (description, error) in
			if let error = error {
				print(error)
			}
			else {
				print(description)
			}
		}
		
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		
		fetchEntities()
	}
	
	func createName(session: String, stage: Int) -> String {
		fetchEntities()
		let SequenceNumber = String(fetchedEntitiesAsStrings.count + 1)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy:MM:dd"
		
		let timeFormatter = DateFormatter()
		timeFormatter.dateFormat = "HH:mm"
		
		let currentDate = Date()
		
		let Date = dateFormatter.string(from: currentDate)
		let Time = timeFormatter.string(from: currentDate)
		let Session = session
		let Stage = String(stage)
		
		return SequenceNumber + "-" + Date + "-" + Time + "-" + Session + "-" + Stage + "-"
	}

	func fetchEntities() {
		let request = NSFetchRequest<TextThought>(entityName: entityName)

		do {
			fetchedEntities = try container.viewContext.fetch(request)
		}
		catch let error {
			print(error)
		}
		
		fetchedEntitiesAsStrings = []
		
		for entity in fetchedEntities {
			if let newEntity = entity.value(forKey: "text") {
				fetchedEntitiesAsStrings.append(newEntity as! String)
			}
		}
	}

	func saveModel() {
		do {
			try container.viewContext.save()
			fetchEntities()
		}
		catch let error {
			print(error)
		}
	}

	func deleteEntity() {
		fetchEntities()
		for entity in fetchedEntities {
			container.viewContext.delete(entity)
		}
		saveModel()
	}

	func addTextThought(thought: String, session: String, stage: Int) {
		let newTextThought = TextThought(context: container.viewContext)
		newTextThought.text = createName(session: session, stage: stage) + thought
		saveModel()
	}
}

class AudioThoughtViewModel: ObservableObject {
	let container: NSPersistentContainer
	let entityName: String
	@Published var fetchedEntities: [AudioThought] = []
	@Published var fetchedEntitiesAsStrings: [String] = []
	
	init(entityName: String) {
		self.entityName = entityName
		container = NSPersistentCloudKitContainer(name: "MoonarDataModel")
		container.loadPersistentStores { (description, error) in
			if let error = error {
				print(error)
			}
			else {
				print(description)
			}
		}
		
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		
		fetchEntities()
	}
	
	func fetchEntities() {
		let request = NSFetchRequest<AudioThought>(entityName: entityName)
		
		do {
			fetchedEntities = try container.viewContext.fetch(request)
		}
		catch let error {
			print(error)
		}
		
		fetchedEntitiesAsStrings = []
		
		for entity in fetchedEntities {
			if let newEntity = entity.value(forKey: "text") {
				fetchedEntitiesAsStrings.append(newEntity as! String)
			}
		}
	}
	
	func saveModel() {
		do {
			try container.viewContext.save()
			fetchEntities()
		}
		catch let error {
			print(error)
		}
	}
	
	func deleteEntity() {
		fetchEntities()
		for entity in fetchedEntities {
			container.viewContext.delete(entity)
		}
		saveModel()
	}
	
	func addAudioThoughtPath(path: String) {
		let newAudioThoughtPath = AudioThought(context: container.viewContext)
		newAudioThoughtPath.text = path
		saveModel()
	}
}

class TaskViewModel: ObservableObject {
	let container: NSPersistentContainer
	let entityName: String
	@Published var fetchedEntities: [MoonarTask] = []
	@Published var fetchedEntitiesAsStrings: [String] = []
	@Published var fetchedEntitiesAsBooleans: [Bool] = []
	
	init(entityName: String) {
		self.entityName = entityName
		container = NSPersistentCloudKitContainer(name: "MoonarDataModel")
		container.loadPersistentStores { (description, error) in
			if let error = error {
				print(error)
			}
			else {
				print(description)
			}
		}
		
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		
		fetchEntities()
	}
	
	func fetchEntities() {
		let request = NSFetchRequest<MoonarTask>(entityName: entityName)
		
		do {
			fetchedEntities = try container.viewContext.fetch(request)
		}
		catch let error {
			print(error)
		}
		
		fetchedEntitiesAsStrings = []
		fetchedEntitiesAsBooleans = []
		
		for entity in fetchedEntities {
			if let newEntity = entity.value(forKey: "text") {
				fetchedEntitiesAsStrings.append(newEntity as! String)
			}
			
			if let newEntity = entity.value(forKey: "isTicked") {
				fetchedEntitiesAsBooleans.append(newEntity as! Bool)
			}
		}
	}
	
	func saveModel() {
		do {
			try container.viewContext.save()
			fetchEntities()
		}
		catch let error {
			print(error)
		}
	}
	
	func deleteEntity() {
		fetchEntities()
		for entity in fetchedEntities {
			container.viewContext.delete(entity)
		}
		saveModel()
	}
	
	func addTask(task: String) {
		let newTask = MoonarTask(context: container.viewContext)
		newTask.text = task
		newTask.isTicked = false
		saveModel()
	}
	
	func tickTask(id: Int) {
		fetchedEntities[id].isTicked.toggle()
		saveModel()
	}
}

class AdviceViewModel: ObservableObject {
	let container: NSPersistentContainer
	let entityName: String
	@Published var fetchedEntities: [MoonarAdvice] = []
	@Published var fetchedEntitiesAsStrings: [String] = []
	
	init(entityName: String) {
		self.entityName = entityName
		container = NSPersistentCloudKitContainer(name: "MoonarDataModel")
		container.loadPersistentStores { (description, error) in
			if let error = error {
				print(error)
			}
			else {
				print(description)
			}
		}
		
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		
		fetchEntities()
	}
	
	func fetchEntities() {
		let request = NSFetchRequest<MoonarAdvice>(entityName: entityName)
		
		do {
			fetchedEntities = try container.viewContext.fetch(request)
		}
		catch let error {
			print(error)
		}
		
		fetchedEntitiesAsStrings = []
		
		for entity in fetchedEntities {
			if let newEntity = entity.value(forKey: "text") {
				fetchedEntitiesAsStrings.append(newEntity as! String)
			}
		}
	}
	
	func saveModel() {
		do {
			try container.viewContext.save()
			fetchEntities()
		}
		catch let error {
			print(error)
		}
	}
	
	func deleteEntity() {
		fetchEntities()
		for entity in fetchedEntities {
			container.viewContext.delete(entity)
		}
		saveModel()
	}
	
	func addAdvice(advice: String) {
		let newAdvice = MoonarAdvice(context: container.viewContext)
		newAdvice.text = advice
		saveModel()
	}
}

var recorder: AVAudioRecorder?
var player: AVAudioPlayer?

class AudioViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
	@Published var transcribedText = ""
	
	var audioFileSystem = AudioThoughtViewModel(entityName: "AudioThought")
	var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	var recognitionTask: SFSpeechRecognitionTask?
	var audioFileName = ""
	let audioEngine = AVAudioEngine()
	let settings = [
		AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
		AVSampleRateKey: 12000,
		AVNumberOfChannelsKey: 1,
		AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
	]
	
	func path(fileName: String) -> URL {
		if let path = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent(fileName + ".m4a") {
			return path
		}
		else {
			return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName + ".m4a")
		}
	}
	
	func deleteAudioFiles() {
		for fileName in audioFileSystem.fetchedEntitiesAsStrings {
			do {
				try FileManager.default.removeItem(at: path(fileName: fileName))
			}
			catch let error {
				print(error)
			}
		}
	}
	
	func createName(session: String, stage: Int) -> String {
		audioFileSystem.fetchEntities()
		let SequenceNumber = String(audioFileSystem.fetchedEntitiesAsStrings.count + 1)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy:MM:dd"
		
		let timeFormatter = DateFormatter()
		timeFormatter.dateFormat = "HH:mm"
		
		let currentDate = Date()
		
		let Date = dateFormatter.string(from: currentDate)
		let Time = timeFormatter.string(from: currentDate)
		let Session = session
		let Stage = String(stage)
		
		return SequenceNumber + "-" + Date + "-" + Time + "-" + Session + "-" + Stage
	}
	
	func requestRecordAuthorization() {
		AVAudioSession.sharedInstance().requestRecordPermission { granted in
			if !granted {
				print("User denied to provide mic access((")
			}
		}
	}
	
	func requestSpeechTranscriptionAuthorization() {
		SFSpeechRecognizer.requestAuthorization { authStatus in
			switch authStatus {
				case .authorized:
					print("Wow, user nailed it!")
				case .denied:
					print("Speech recognition authorization denied")
				case .restricted:
					print("Not available on this device")
				case .notDetermined:
					print("Not determined")
				@unknown default:
					print("Some error I don't the fuck know what's it about(((")
			}
		}
	}
	
	func audioThoughtSpeechTranscription(name: String) {
		requestSpeechTranscriptionAuthorization()
		
		var omit = 0
		let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
		let inputNode = audioEngine.inputNode
		
		recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
		guard let recognitionRequest = recognitionRequest
		else {
			fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
		}
		recognitionRequest.shouldReportPartialResults = true
		recognitionRequest.requiresOnDeviceRecognition = false
		
		recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
			if omit % 5 == 0 {
				var isFinal = false
				
				if let result = result {
					isFinal = result.isFinal
					
					print("SPEECH RECOGNITION RESULT:", result.bestTranscription.formattedString)
					print("SPEECH RECOGNITION ITERATION:", omit)
					
					self.transcribedText = result.bestTranscription.formattedString
					
					print("TRANSCRIBED TEXT:", self.transcribedText)
				}
				
				if error != nil || isFinal {
					self.audioEngine.stop()
					inputNode.removeTap(onBus: 0)
					
					self.recognitionRequest = nil
					self.recognitionTask = nil
				}
			}
			omit += 1
		}
		
		let recordingFormat = inputNode.outputFormat(forBus: 0)
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
			self.recognitionRequest?.append(buffer)
		}
	}
	
	func startRecordingAudio(session: String, stage: Int) {
		requestRecordAuthorization()
		audioFileName = createName(session: session, stage: stage)
		
		let recordingSession = AVAudioSession.sharedInstance()
		do {
			try recordingSession.setCategory(.record, mode: .spokenAudio, options: [.duckOthers, .defaultToSpeaker])
			try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
		}
		catch {
			print("Failed to set up recording session")
		}
		
		audioThoughtSpeechTranscription(name: audioFileName)
		
		audioEngine.prepare()
		do {
			try audioEngine.start()
		}
		catch {
			print("Audio engine didn't start")
		}
				
		do {
			try recorder = AVAudioRecorder(url: path(fileName: audioFileName), settings: settings)
			recorder!.record()
		}
		catch let error {
			print(error)
		}
	}
	
	func resumeRecordingAudio() {
		recorder!.record()
	}
	
	func abortRecordingAudio() {
		if audioEngine.isRunning {
			audioEngine.stop()
			audioEngine.inputNode.removeTap(onBus: 0)
			recognitionRequest?.endAudio()
		}
		
		recorder!.stop()
		recorder!.deleteRecording()
	}
	
	func pauseRecordingAudio() {
		recorder!.pause()
	}
	
	func stopRecordingAudio() -> String {
		if audioEngine.isRunning {
			audioEngine.stop()
			audioEngine.inputNode.removeTap(onBus: 0)
			recognitionRequest?.endAudio()
		}
		
		recorder!.stop()

		return audioFileName
	}
	
	func playbackAudio(name: String) -> Double {
		let path = path(fileName: name)
		
		let playingSession = AVAudioSession.sharedInstance()
		
		do {
			try playingSession.setCategory(.playAndRecord, options: [.defaultToSpeaker])
			try playingSession.setMode(.spokenAudio)
			try playingSession.setActive(true)
		}
		catch {
			print("Failed to set up recording session")
		}
		
		do {
			try player = AVAudioPlayer(contentsOf: path)
			player!.play()
			player!.delegate = self
		}
		catch let error {
			print(error)
		}
		
		guard let player = player else {
			return 0
		}
		
		return Double(player.duration)
	}
	
	func pauseAudioPlayback() {
		player!.pause()
	}
	
	func resumeAudioPlayback() {
		player!.play()
	}
	
	func stopAudioPlayback(name: String) {
		let path = path(fileName: name)
		
		do {
			try player = AVAudioPlayer(contentsOf: path)
			player!.stop()
		}
		catch let error {
			print(error)
		}
	}
	
	func isPlaying() -> Bool {
		return player!.isPlaying
	}
	
	func currentTime() -> Double {
		guard let player = player else {
			return 0
		}
		
		return Double(player.currentTime)
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
	}
}

class MoonarViewModel: ObservableObject {
	@Published var emotionScore: Double = 0
	
	var audioController = AudioViewModel()
	
	func emotionClassification(text: String) -> EmotionalStates {
		
		print("EMOTION CLASSIFICATION INPUT:", text)
		
		var numericScore: Double = 0
		let tagger = NLTagger(tagSchemes: [.tokenType, .sentimentScore])
		tagger.string = text
		
		print("EMOTION CLASSIFICATION tagger:", tagger)
		print("EMOTION CLASSIFICATION tagger.string:", tagger.string ?? "")
		
		tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .paragraph, scheme: .sentimentScore, options: []) { sentiment, _ in
			
			print("EMOTION CLASSIFICATION sentiment:", sentiment ?? "")
			
			if let sentimentScore = sentiment {
				numericScore = Double(sentimentScore.rawValue)  ?? 0
			}
			
			return true
		}
		
		print("EMOTION CLASSIFICATION OUTPUT:", numericScore)
		
		emotionScore = numericScore
		
		print("EMOTION SCORE:", emotionScore)
		
		if numericScore <= -0.9 {
			return .bad
		}
		else if numericScore <= -0.5 {
			return .worried
		}
		else if numericScore <= 0.3 {
			return .calm
		}
		else {
			return .happy
		}
	}
	
	func requestNotificationAuthorization() {
		UNUserNotificationCenter.current().requestAuthorization(
			options: [.sound, .alert],
			completionHandler: {
			(authStatus, error) in
				if let error = error {
					print(error)
				}
			}
		)
	}
	
	func removeRequests() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
	}
	
	func scheduleNotification(title: String, text: String, date: NSDate) {
		requestNotificationAuthorization()
		
		let newDate = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
		let newDateComponents = Calendar.current.dateComponents([.hour, .minute], from: newDate)
				
		let content = UNMutableNotificationContent()
		content.title = title
		content.body = text
		content.sound = .default
		let trigger = UNCalendarNotificationTrigger(dateMatching: newDateComponents, repeats: true)
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().add(request)
	}
	
	func addTask(task: Tasks) {
		let taskText = task.rawValue
		let tasks = TaskViewModel(entityName: "MoonarTask")
		
		tasks.addTask(task: taskText)
	}
	
	func addTextThought(text: String, session: String, stage: Int) {
		let textThoughts = TextThoughtViewModel(entityName: "TextThought")
		
		textThoughts.addTextThought(thought: text, session: session, stage: stage)
	}
	
	func addAudioThought(name: String) {
		let audioThoughts = AudioThoughtViewModel(entityName: "AudioThought")
		
		audioThoughts.addAudioThoughtPath(path: name)
	}
	
	func addAdvice(advice: String) {
		let moonarAdvice = AdviceViewModel(entityName: "MoonarAdvice")
		
		if !moonarAdvice.fetchedEntitiesAsStrings.contains(advice) {
			moonarAdvice.addAdvice(advice: advice)
		}
	}
}

class Subscription: ObservableObject {
	@Published var subscriptionTypes: [Product] = []
	@Published var isUserSubscribed: Bool = true
	@Published var expirationDate = Date()
	@Published var trialPeriod = Date()
	
//	@Published var nextWithdrawalDaysRemained: Int = 0

	var updateListenerTask: Task<Void, Error>? = nil

	enum StoreError: Error {
		case failedVerification
	}

	init() {
		subscriptionTypes = []

		updateListenerTask = listenForTransactions()

		Task {
			await requestProducts()
			await updateCustomerStatus()
		}
	}
	
	deinit {
		updateListenerTask?.cancel()
	}
	
	func restorePurchases() {
		Task {
			try? await AppStore.sync()
		}
	}

	@MainActor
	func requestProducts() async {
		do {
			subscriptionTypes = try await Product.products(for: ProductIdentifiers)
		}
		catch {
			print("Failed product request from the App Store server: \(error)")
		}
	}

	@MainActor
	func updateCustomerStatus() async {
		var purchasedSubscription: Product? = nil

		for await result in Transaction.currentEntitlements {
			do {
				let transaction = try checkVerified(result: result)

				if let subscription = subscriptionTypes.first(where: { $0.id == transaction.productID }) {
					purchasedSubscription = subscription
				}
			}
			catch {
				print("Something went wrong(")
			}
		}

		if purchasedSubscription != nil {
			isUserSubscribed = true
		}
		else {
			isUserSubscribed = false
		}
	}

	func listenForTransactions() -> Task<Void, Error> {
		return Task.detached {
			for await result in StoreKit.Transaction.updates {
				do {
					let transaction = try self.checkVerified(result: result)

					await self.updateCustomerStatus()

					await transaction.finish()
				} catch {
					print("Transaction failed verification")
				}
			}
		}
	}

	func purchase(productID: String) async throws -> StoreKit.Transaction? {
		let product = try await Product.products(for: [productID])[0]
		
//		try print(product, await Product.products(for: [productID]), await Product.products(for: [productID])[0])
		
		let result = try await product.purchase()
		
		switch result {
			case .success(let verification):
				let transaction = try checkVerified(result: verification)
				await transaction.finish()

				return transaction
			case .userCancelled, .pending:
				return nil
			default:
				return nil
		}
	}

	func checkVerified<T>(result: VerificationResult<T>) throws -> T {
		switch result {
			case .unverified:
				throw StoreError.failedVerification
			case .verified(let safe):
				return safe
		}
	}

	func trialDaysRemained() -> Int {
		let firstOfferDate = NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[7]) as? Date ?? Date()
		let currentDate = Date()

		return 7 - Int((Calendar.current.dateComponents([.day], from: firstOfferDate, to: currentDate).day) ?? 0)
	}
}

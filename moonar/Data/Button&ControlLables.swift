//
//  File.swift
//  moonar
//
//  Created by Владислав Калиниченко on 14.04.2022.
//

import Foundation
import SwiftUI

struct textOption: Identifiable {
	var id = UUID()
	var isMain: Bool
	var text: String
}

let isHavingSymptomsOptions = [
	textOption(isMain: true, text: "Yes, I do"),
	textOption(isMain: false, text: "No, I don't")
]

let genderOptions = [
	textOption(isMain: true, text: "Male"),
	textOption(isMain: true, text: "Female"),
	textOption(isMain: true, text: "Non-Binary")
]

let StringGenderOptions = [
	"Male",
	"Female",
	"Non-Binary"
]

let agreementOptions = [
	textOption(isMain: true, text: "Yes"),
	textOption(isMain: false, text: "No")
]

let tolerantAgreementOptions = [
	textOption(isMain: true, text: "Yes"),
	textOption(isMain: true, text: "No")
]

let agreementToTellOptions = [
	textOption(isMain: true, text: "No, tell me"),
	textOption(isMain: false, text: "Already know")
]

let tryOptions = [
	textOption(isMain: true, text: "OK, I'll try"),
	textOption(isMain: false, text: "Didn't quite get it")
]

let subscribeOptions = [
	textOption(isMain: true, text: "Subscribe now!"),
	textOption(isMain: false, text: "Continue 7-day trial")
]

let startOptions = [
	textOption(isMain: true, text: "Tell about problem"),
	textOption(isMain: true, text: "Record thoughts")
]

enum Tasks: String, CaseIterable {
	case socialNormViolation = "Here is a task for you. Try to do something not very appropriate in society like singing a song out loud on the street with other people around) This would let you overcome shame interacting with people and make you more open."
	case autoSuggestion = "I'd like to recommend you to tell yourself some rational states that could cheer you up or help you to cope with your problems. Just wake up in the morning and tell «I'm beautiful coz Alex told me that last week» for instance) Repeat this every day."
	case paradoxicalIntention = "Try to live the situation bothering you in reverse. For example, if you have problems with sleep, don't try to fall asleep and just relax. This will probably help you."
	case backToPast = "I want you to dive deeply in your past today and try to recall moments where you felt bad. Estimate these events dispassionately and find some objective factors that made you feel so. This should help you better understand your state."
	case lookFromOtherSides = "Consider looking at one situation that bothering you right now from several sides, from any perspective."
	case doJournaling = "Record your thoughts on anything you've been thinking during one day. Return to this recordings after 3 days, listen to them and maybe you change your attitude to some of them."
	case readAboutABC = "Find out more information about ABC model in psychology on the Internet."
	case drawFear = "Pick up your fear and draw how do you perceive it. Look at this picture several times throughout the week and You'll notice how you become more familiar with this fear."
//	case exposure = "Do the thing that you are afraid of. Divide the action you need to into small not that horrible parts and complete one after another."
	case researchSupportingFacts = "If you struggle supporting your thoughts with facts, conduct a small research on your problem."
	case peopleDontCare = "One day unnoticeably observe all people around you and find out whether they want to observe and talk about you or not."
}

let piecesOfAdvice = [
	"If you ever find yourself in the wrong story, leave.",
	"Don’t take your thoughts so seriously. Thoughts are not facts. And they are not threats. They are, well, just thoughts.",
	"Whatever you are facing – it’s not about you.",
	"Learn a means of relaxation. This should include looking in the mirror and seeing your face relax, your jaw relax, and your shoulders relax.",
	"Let yourself off the hook. Beating yourself up for needing help is just a double whammy – already feeling bad and then being mad at yourself for feeling bad makes things feel worse.",
	"Practice self-care. Whatever makes you feel better and feels kind to you is helpful for pushing back on the usual mental health culprits.",
	"Feel your feelings. While you may not want to act on every feeling you have, try to experience each one fully in the privacy of your own heart.",
	"Take your own advice. We are way better at coming to solutions when it is for someone we care about.",
	"Do your best to remain a willing, accepting, and teachable person. You won’t be perfect at it, but should focus on progress rather than perfection.",
	"Practice being self-compassionate. You won’t experience a transformation overnight, but being committed to thinking, feeling, and doing things differently will allow for a different result.",
	"Attitude is a little thing that makes a big difference.",
	"Happiness is the only thing that multiplies when you share it.",
	"It’s a helluva start, being able to recognise what makes you happy.",
	"I’ve always believed that you can think positively just as well as you can think negatively.",
	"Sanity and happiness are an impossible combination.",
	"Happiness in intelligent people is the rarest thing I know.",
	"For success, attitude is equally as important as ability.",
	"If you deliberately plan on being less than you are capable of being, then I warn you that you’ll be unhappy for the rest of your life.",
	"Even a happy life cannot be without a measure of darkness, and the word happy would lose its meaning if it were not balanced by sadness.",
	"Happiness is not out there for us to find. The reason that it’s not our there is that it’s inside us.",
	"People are so made, that we can only derive intense enjoyment from a contrast and only very little from a state of things.",
	"Once you start making the effort to ‘wake yourself up’ — that is, be more mindful in your activities — you suddenly start appreciating life a lot more.",
	"Compassion to be one of the few things we can practice that will bring immediate and long-term happiness to our lives.",
	"Ability is what you’re capable of doing. Motivation determines what you do. Attitude determines how well you do it.",
	"Everyone wants to live on top of the mountain, but all the happiness and growth occurs while you’re climbing it.",
	"The power of finding beauty in the humblest things makes home happy and life lovely.",
	"Action may not always bring happiness, but there is no happiness without action.",
	"You cannot control what happens to you, but you can control your attitude toward what happens to you, and in that, you will be mastering change rather than allowing it to master you.",
	"A pessimist is one who makes difficulties of his opportunities; an optimist is one who makes opportunities of his difficulties.",
	"To be stupid, and selfish, and to have good health are the three requirements for happiness.",
	"Thoughts play a powerful role in determining how people feel and how they act. If someone thinks positively about something, they’ll probably feel positively about it. Conversely, if they think negatively about something — whether or not that thought is supported by evidence – they will feel negatively."
]

enum SelectionValues: CaseIterable {
	case todo
	case done
}

let symptomOptions = [
	"Drug or alcohol use",
	"Social withdrawal or isolation",
	"Excessive worrying or fear",
	"Difficulty sleeping",
	"Low energy",
	"Depression or feelings of sadness",
	"Inability to interpret people’s emotions",
	"Intense irritability or anger",
	"Obsession with my physical appearance",
	"Problems concentrating and learning",
	"Sudden mood changes",
	"Loss of interest",
	"Major changes in eating habits",
	"Inability to cope with daily stress"
]



let controlLabels = [
	"Next",
	"Yes, let's move on!",
	"I'm ready",
	"OK, I want to tell you something",
	"Yeah, I got it",
	"I'm feeling like this",
	"OK"
]

let moonarPhrases = [
	"Hi, I'm moonar – your pocket psychologist.",
	"My creators made me for people who want to increase their mental wellbeing.",
	"Although I'm not as smart as people, I'll do my best to help you become better and happier.",
	"But first, what's your name?",
	"Okay, so I'd like to know your gender.",
	"Alright, moving on to your age.",
	"A-a-and the last step.",
	"Do you have any problems, connected to your mental wellbeing?",
	"Wow, we are all set up.",
	"You can change this data in settings later."
]

let resourcesLinks = [
	[
		"psychologytools.com",
		"https://www.psychologytools.com/downloads/cbt-worksheets-and-therapy-resources/"
	],
	[
		"therapistaid.com",
		"https://www.therapistaid.com/therapy-worksheets/cbt/none"
	]
]

Class {
	#name : #SgObject,
	#superclass : #Object,
	#instVars : [
		'id',
		'sessionManager',
		'settings'
	],
	#category : #'SCypherGraph-Core'
}

{ #category : #private }
SgObject >> clientDo: aBlock [
	^ self sessionManager clientDo: aBlock at: self settings clientKindKey
]

{ #category : #factory }
SgObject >> createSessionManager [
	| sessionManagerClassName manager |
	sessionManagerClassName := self settings sessionManagerClassName asSymbol.
	manager := self createSessionManagerFrom: (self class environment at: sessionManagerClassName).
	manager settings: self settings.
	manager standBy: self settings standByClients. 
	^manager
]

{ #category : #factory }
SgObject >> createSessionManagerFrom: aSessionManagerClass [
	| sessionManagerCreationPolicy |
	sessionManagerCreationPolicy := self settings sessionManagerCreationPolicy.
	^ sessionManagerCreationPolicy = #useDefault
		ifTrue: [aSessionManagerClass default]
		ifFalse: [aSessionManagerClass new].
]

{ #category : #factory }
SgObject >> graphObjectClass [
	^ SgGraphObject
]

{ #category : #accessing }
SgObject >> id [
	^ id
]

{ #category : #accessing }
SgObject >> id: anObject [
	id := anObject
]

{ #category : #'actions-cypher' }
SgObject >> runCypher: cypherString [
	^self clientDo: [ :cli | cli runCypher: cypherString ]
]

{ #category : #'actions-cypher' }
SgObject >> runCypher: cypherString arguments: argsDict [
	^self clientDo: [ :cli | cli runCypher: cypherString arguments: argsDict]
]

{ #category : #'actions-cypher' }
SgObject >> runCyphers: cypherStrings [
	^self clientDo: [ :cli | cli runCyphers: cypherStrings ]
]

{ #category : #'actions-cypher' }
SgObject >> runCyphersBy: aStatementsAppenderBlock [
	^self clientDo: [ :cli | cli runCyphersBy: aStatementsAppenderBlock ]
]

{ #category : #accessing }
SgObject >> sessionManager [
	^ sessionManager ifNil: [ sessionManager := self createSessionManager ]
]

{ #category : #accessing }
SgObject >> sessionManager: anObject [
	sessionManager := anObject
]

{ #category : #accessing }
SgObject >> settings [
	^settings ifNil: [ settings := SgSettings default ]
]

{ #category : #accessing }
SgObject >> settings: anObject [
	settings := anObject
]

{ #category : #'actions-cypher' }
SgObject >> transactCypher: cypherString [
	^self clientDo: [ :cli | cli transactCypher: cypherString ]
]

{ #category : #'actions-cypher' }
SgObject >> transactCypher: cypherString arguments: argsDict [
	^self clientDo: [ :cli | cli transactCypher: cypherString arguments: argsDict]
]

{ #category : #'actions-cypher' }
SgObject >> transactCyphers: cypherStrings [
	^self clientDo: [ :cli | cli transactCyphers: cypherStrings ]
]

{ #category : #'actions-cypher' }
SgObject >> transactCyphersBy: aStatementsAppenderBlock [
	^self clientDo: [ :cli | cli transactCyphersBy: aStatementsAppenderBlock ]
]

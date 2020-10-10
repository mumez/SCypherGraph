Class {
	#name : #SgBasicTestCase,
	#superclass : #TestCase,
	#classInstVars : [
		'defaultSettings'
	],
	#category : #'SCypherGraph-Tests'
}

{ #category : #accessing }
SgBasicTestCase class >> defaultSettings [
	^defaultSettings ifNil: [ defaultSettings := SgSettings new]
]

{ #category : #'class initialization' }
SgBasicTestCase class >> initSettingsExample [
	<script>
	self defaultSettings password: 'neoneo'
]

{ #category : #'class initialization' }
SgBasicTestCase class >> initialize [
	defaultSettings := nil
]

{ #category : #private }
SgBasicTestCase >> dbDo: aBlock [
	| db |
	db := SgGraphDb kind: #testing.
	[ db settings: self settings.
	aBlock value: db ]
		ifCurtailed: [ db release ]
]

{ #category : #accessing }
SgBasicTestCase >> settings [
	^self class defaultSettings
]

{ #category : #testing }
SgBasicTestCase >> testAllLabels [
	self dbDo: [ :db |
		| labels |
		labels := db allLabels.
		self assert: (labels isNotEmpty).
		self assert: (labels asSortedCollection asArray = #('Movie' 'Person'))
	]
]

{ #category : #testing }
SgBasicTestCase >> testAllRelationshipTypes [
	self dbDo: [ :db |
		| types |
		types := db allRelationshipTypes.
		
		self assert: (types isNotEmpty).
		self assert: (types asSortedCollection asArray = #('ACTED_IN' 'DIRECTED' 'FOLLOWS' 'PRODUCED' 'REVIEWED' 'WROTE'))
	]
]

{ #category : #testing }
SgBasicTestCase >> testNodesLabeled [
	self dbDo: [ :db |
		| nodes |
		nodes := db nodesLabeled: 'Movie'.
		self assert: (nodes isNotEmpty).
		self assert: (nodes size = 38)
	]
]

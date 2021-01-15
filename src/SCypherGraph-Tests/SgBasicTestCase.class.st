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
SgBasicTestCase >> testCreateAndDeleteNode [
	| personLabel |
	personLabel := 'TestPerson'.
	self dbDo: [ :db |
		| existedNodes node retrievedNode |
		existedNodes := db nodesLabeled: personLabel.
		self assert: (existedNodes isEmpty).
		
		node := db createNodeLabeled: personLabel properties: {'name' -> 'john'. 'age' -> 23}.
		existedNodes := db nodesLabeled: personLabel.
		self assert: (existedNodes size = 1).
		retrievedNode := db nodeAt: node id.
		self assert: (retrievedNode id = node id).
		self assert: (node properties = {'name' -> 'john'. 'age' -> 23} asDictionary).
		self assert: (node properties = retrievedNode properties).
		
		node delete.
		retrievedNode := db nodeAt: node id.
		self assert: (retrievedNode isNil).
		
		existedNodes := db nodesLabeled: personLabel.
		self assert: (existedNodes isEmpty).
	]
]

{ #category : #testing }
SgBasicTestCase >> testCreateAndDeleteRelationship [
	| personLabel teachesType |
	personLabel := 'TestPerson2'.
	teachesType := 'TestTeaches'.
	self dbDo: [ :db |
		| existedNodes nodeA nodeB rels  rel |
		existedNodes := db nodesLabeled: personLabel.
		self assert: (existedNodes isEmpty).
		nodeA := db createNodeLabeled: personLabel properties: {'name' -> 'taro'. 'age' -> 33}.
		nodeB := db createNodeLabeled: personLabel properties: {'name' -> 'hanako'. 'age' -> 9 }.
		
		rels := nodeA outRelationshipsTyped: teachesType.
		self assert: (rels isEmpty).
		
		nodeA relateOneTo: nodeB typed: 'TestTeaches' properties: {'years'->3}.
		
		rels := nodeA outRelationshipsTyped: teachesType.
		self assert: (rels size = 1).
		rel := rels first.
		self assert: ((rel propertyAt: 'years' ) =  3).
		
		rel delete.
		
		rels := nodeA outRelationshipsTyped: teachesType.
		self assert: (rels isEmpty).
		
		nodeA delete.
		nodeB delete.
	]
]

{ #category : #testing }
SgBasicTestCase >> testGetSetNodeProperties [
	| personLabel |
	personLabel := 'TestPerson'.
	self dbDo: [ :db |
		| existedNodes node retrievedNode |
		existedNodes := db nodesLabeled: personLabel.
		self assert: (existedNodes isEmpty).
		
		node := db createNodeLabeled: personLabel properties: {'name' -> 'john'. 'age' -> 23}.
		existedNodes := db nodesLabeled: personLabel.
		self assert: (existedNodes size = 1).
		retrievedNode := db nodeAt: node id.
		self assert: (retrievedNode id = node id).
		self assert: (node properties = {'name' -> 'john'. 'age' -> 23} asDictionary).
		self assert: (node properties = retrievedNode properties).
		node properties: { 'address' -> 'none' }.
		node reload.
		
		retrievedNode := db nodeAt: node id.
		self assert: (retrievedNode id = node id).
		self assert: (node properties = {'address' -> 'none'} asDictionary).
		self assert: (node properties = retrievedNode properties).
		
		node mergeProperties: {'name' -> 'paul'. 'age' -> 24}.
		node reload.
		
		retrievedNode := db nodeAt: node id.
		self assert: (retrievedNode id = node id).
		self assert: (node properties = {'address' -> 'none'. 'name' -> 'paul'. 'age' -> 24} asDictionary).
		self assert: (node properties = retrievedNode properties).
		
		node delete.
		retrievedNode := db nodeAt: node id.
		self assert: (retrievedNode isNil).
		
		existedNodes := db nodesLabeled: personLabel.
		self assert: (existedNodes isEmpty).
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

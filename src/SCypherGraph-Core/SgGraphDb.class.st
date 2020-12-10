Class {
	#name : #SgGraphDb,
	#superclass : #SgObject,
	#category : #'SCypherGraph-Core'
}

{ #category : #'instance creation' }
SgGraphDb class >> default [
	^self kind: #default
]

{ #category : #'instance creation' }
SgGraphDb class >> kind: clientKindKey [
	| inst |
	inst := self new. 
	inst settings clientKindKey: clientKindKey.
	^ inst
]

{ #category : #'global operations' }
SgGraphDb >> allLabels [
	| result |
	result := self runCypher: 'MATCH (n)
WITH DISTINCT labels(n) as labels
UNWIND labels as label
RETURN distinct label
ORDER BY label'.
	^result firstFieldValues
]

{ #category : #'global operations' }
SgGraphDb >> allRelationshipTypes [
	| result |
	result := self runCypher: 'MATCH (n)-[r]-() RETURN distinct type(r)'.
	^ result firstFieldValues
]

{ #category : #'actions-relationships' }
SgGraphDb >> createInRelationshipTyped: typeOrTypes fromNodeId: startNodeId toNodeId: endNodeId properties: propertiesArray [
	| query |
	query := CyQuery
		matchPathWithNodeAt: startNodeId
		nodeAt: endNodeId
		createIn: [ :startNode :endNode :relIdentifier | 
			| rel |
			rel := relIdentifier rel: typeOrTypes props: propertiesArray.
			startNode <- rel - endNode ].
	^self firstOrNilOf: (self transactCypherResultWrapped: query).
	
]

{ #category : #'actions-node' }
SgGraphDb >> createNodeLabeled: labelOrLabels [
	^self createNodeLabeled: labelOrLabels properties: #()
]

{ #category : #'actions-node' }
SgGraphDb >> createNodeLabeled: labelOrLabels properties: props [
	| labels n node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	n := 'n' asCypherIdentifier.
	node := CyNode name: n labels: labels props: props. 
	query := CyQuery statements: {
		CyCreate of: node.
		CyReturn of: n.
	}.
	^self firstOrNilOf: (self transactCypherResultWrapped: query)
]

{ #category : #'actions-relationships' }
SgGraphDb >> createOutRelationshipTyped: typeOrTypes fromNodeId: startNodeId toNodeId: endNodeId properties: propertiesArray [
	| query |
	query := CyQuery
		matchPathWithNodeAt: startNodeId
		nodeAt: endNodeId
		createIn: [ :startNode :endNode :relIdentifier | 
			| rel |
			rel := relIdentifier rel: typeOrTypes props: propertiesArray.
			startNode - rel -> endNode ].
	^self firstOrNilOf: (self transactCypherResultWrapped: query).
	
]

{ #category : #'actions-relationships' }
SgGraphDb >> createRelationshipTyped: typeOrTypes fromNodeId: startNodeId toNodeId: endNodeId properties: propertiesArray [
	| query |
	query := CyQuery
		matchPathWithNodeAt: startNodeId
		nodeAt: endNodeId
		createIn: [ :startNode :endNode :relIdentifier | 
			| rel |
			rel := relIdentifier rel: typeOrTypes props: propertiesArray.
			startNode - rel - endNode ].
	^self firstOrNilOf: (self transactCypherResultWrapped: query).
	
]

{ #category : #'actions-node' }
SgGraphDb >> deleteNode: aNode [
	^self deleteNodeAt: aNode id
]

{ #category : #'actions-node' }
SgGraphDb >> deleteNodeAt: systemId [
	| n node query |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		delete: node.
	^self statusOfTransactCypher: query
]

{ #category : #'actions-node' }
SgGraphDb >> deleteNodesLabeled: labelOrLabels havingAll: assocArray [
	^self deleteNodesLabeled: labelOrLabels where: [:node | node havingAll: assocArray]
]

{ #category : #'actions-node' }
SgGraphDb >> deleteNodesLabeled: labelOrLabels where: whereClauseBuilder [
	| labels node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) delete: node.
	^self statusOfTransactCypher: query
]

{ #category : #'actions-relationships' }
SgGraphDb >> deleteRelationshipAt: systemId [
	| s e r rel query |
	s := 's' asCypherIdentifier.
	e := 'e' asCypherIdentifier.
	r := 'r' asCypherIdentifier.
	rel := CyRelationship start: s end: e name: r. 
	query := CyQuery match: rel where: (r getId equals: systemId) delete: r.
	^self statusOfTransactCypher: query
]

{ #category : #private }
SgGraphDb >> firstOrNilOf: aCollection [
	aCollection isEmpty ifTrue: [^nil].
	^ aCollection first
]

{ #category : #factory }
SgGraphDb >> graphObjectClass [
	^ SgGraphObject
]

{ #category : #'actions-relationships' }
SgGraphDb >> inRelationshipsTyped: typeOrTypes from: startNodeId havingAll: assocArray endNodeWithLabels: labels havingAll: endNodeProps [
	^self relationshipsTyped: typeOrTypes from: startNodeId havingAll: assocArray endNodeWithLabels: labels havingAll: endNodeProps usingPathIn: [:startNode :rel :endNode |
		startNode <- rel - endNode
	]
]

{ #category : #'actions-relationships' }
SgGraphDb >> mergeInRelationshipTyped: typeOrTypes fromNodeId: startNodeId toNodeId: endNodeId properties: propertiesArray [
	| query |
	query := CyQuery
		matchPathWithNodeAt: startNodeId
		nodeAt: endNodeId
		mergeIn: [ :startNode :endNode :relIdentifier | 
			| rel |
			rel := relIdentifier rel: typeOrTypes props: propertiesArray.
			startNode <- rel - endNode ].
	^self firstOrNilOf: (self transactCypherResultWrapped: query).
	
]

{ #category : #'actions-node' }
SgGraphDb >> mergeNodeLabeled: labelOrLabels [
	^self mergeNodeLabeled: labelOrLabels properties: #()
]

{ #category : #'actions-node' }
SgGraphDb >> mergeNodeLabeled: labelOrLabels properties: props [
	| labels n node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	n := 'n' asCypherIdentifier.
	node := CyNode name: n labels: labels props: props. 
	query := CyQuery statements: {
		CyMerge of: node.
		CyReturn of: n.
	}.
	^self firstOrNilOf: (self transactCypherResultWrapped: query)
]

{ #category : #'actions-relationships' }
SgGraphDb >> mergeOutRelationshipTyped: typeOrTypes fromNodeId: startNodeId toNodeId: endNodeId properties: propertiesArray [
	| query |
	query := CyQuery
		matchPathWithNodeAt: startNodeId
		nodeAt: endNodeId
		mergeIn: [ :startNode :endNode :relIdentifier | 
			| rel |
			rel := relIdentifier rel: typeOrTypes props: propertiesArray.
			startNode - rel -> endNode ].
	^self firstOrNilOf: (self transactCypherResultWrapped: query).
	
]

{ #category : #'actions-relationships' }
SgGraphDb >> mergeRelationshipTyped: typeOrTypes fromNodeId: startNodeId toNodeId: endNodeId properties: propertiesArray [
	| query |
	query := CyQuery
		matchPathWithNodeAt: startNodeId
		nodeAt: endNodeId
		mergeIn: [ :startNode :endNode :relIdentifier | 
			| rel |
			rel := relIdentifier rel: typeOrTypes props: propertiesArray.
			startNode - rel - endNode ].
	^self firstOrNilOf: (self transactCypherResultWrapped: query).
	
]

{ #category : #'actions-node' }
SgGraphDb >> nodeAt: systemId [
	| n node query |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		return: node.
	^self firstOrNilOf: (self runCypherResultWrapped: query)
]

{ #category : #'actions-node' }
SgGraphDb >> nodeAt: systemId mergeProperties: argsDict [
	| n node query arguments |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		set: (n addAll: 'values' asCypherParameter).
	arguments := { 'values' -> argsDict asDictionary } asDictionary.
	^self statusOfTransactCypher: query arguments: arguments
]

{ #category : #'actions-node' }
SgGraphDb >> nodeAt: systemId properties: argsDict [
	| n node query arguments |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		set: (n to: 'values' asCypherParameter).
	arguments := { 'values' -> argsDict asDictionary } asDictionary.
	^self statusOfTransactCypher: query arguments: arguments	
]

{ #category : #'actions-node' }
SgGraphDb >> nodeAt: systemId propertyAt: key put: value [
	| n node query |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		set: {(n @ key) to: value}.
	^self statusOfTransactCypher: query
]

{ #category : #'actions-node' }
SgGraphDb >> nodesLabeled: labelOrLabels [
	^self nodesLabeled: labelOrLabels havingAll: #()
]

{ #category : #'actions-node' }
SgGraphDb >> nodesLabeled: labelOrLabels havingAll: assocArray [
	^self nodesLabeled: labelOrLabels where: [:node | node havingAll: assocArray]
]

{ #category : #'actions-node' }
SgGraphDb >> nodesLabeled: labelOrLabels where: whereClauseBuilder [
	| labels node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node.
	^self runCypherResultWrapped: query
]

{ #category : #'actions-node' }
SgGraphDb >> nodesLabeled: labelOrLabels where: whereClauseBuilder orderBy: orderByClause skip: skip limit: limit [
	| labels node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node orderBy: orderByClause skip: skip limit: limit.
	^self runCypherResultWrapped: query
]

{ #category : #'actions-node' }
SgGraphDb >> nodesLabeled: labelOrLabels where: whereClauseBuilder skip: skip limit: limit [
	| labels node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node skip: skip limit: limit.
	^self runCypherResultWrapped: query
]

{ #category : #private }
SgGraphDb >> objectsFromCypherResults: rawRecords [
	^ rawRecords collect: [:each | self graphObjectClass on: each from: self]
]

{ #category : #'actions-relationships' }
SgGraphDb >> outRelationshipsTyped: typeOrTypes from: startNodeId havingAll: assocArray endNodeWithLabels: labels havingAll: endNodeProps [
	^self relationshipsTyped: typeOrTypes from: startNodeId havingAll: assocArray endNodeWithLabels: labels havingAll: endNodeProps usingPathIn: [:startNode :rel :endNode |
		startNode - rel -> endNode
	]
]

{ #category : #'actions-relationships' }
SgGraphDb >> relationshipAt: systemId [
	| s e r rel query |
	s := 's' asCypherIdentifier.
	e := 'e' asCypherIdentifier.
	r := 'r' asCypherIdentifier.
	rel := CyRelationship start: s end: e name: r. 
	query := CyQuery match: rel where: (r getId equals: systemId) return: r.
	^self firstOrNilOf: (self runCypherResultWrapped: query)
]

{ #category : #'actions-relationships' }
SgGraphDb >> relationshipAt: systemId mergeProperties: argsDict [
	| s e r rel query arguments |
	s := 's' asCypherIdentifier.
	e := 'e' asCypherIdentifier.
	r := 'r' asCypherIdentifier.
	rel := CyRelationship start: s end: e name: r. 
	query := CyQuery match: rel where: (r getId equals: systemId)
		set: (r addAll: 'values' asCypherParameter).	
	arguments := { 'values' -> argsDict asDictionary } asDictionary.
	^self statusOfTransactCypher: query arguments: arguments
]

{ #category : #'actions-relationships' }
SgGraphDb >> relationshipAt: systemId properties: argsDict [
	| s e r rel query arguments |
	s := 's' asCypherIdentifier.
	e := 'e' asCypherIdentifier.
	r := 'r' asCypherIdentifier.
	rel := CyRelationship start: s end: e name: r. 
	query := CyQuery match: rel where: (r getId equals: systemId)
		set: (r to: 'values' asCypherParameter).
	arguments := { 'values' -> argsDict asDictionary } asDictionary.
	^self statusOfTransactCypher: query arguments: arguments	
]

{ #category : #'actions-relationships' }
SgGraphDb >> relationshipAt: systemId propertyAt: key put: value [
	| s e r rel query |
	s := 's' asCypherIdentifier.
	e := 'e' asCypherIdentifier.
	r := 'r' asCypherIdentifier.
	rel := CyRelationship start: s end: e name: r. 
	query := CyQuery match: rel where: (r getId equals: systemId)
		set: {(r @ key) to: value}.
	^self statusOfTransactCypher: query
]

{ #category : #'actions-relationships' }
SgGraphDb >> relationshipsTyped: typeOrTypes from: startNodeId havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps usingPathIn: pathCreationBlock [
	| query returnedPath |
	query := CyQuery
		matchPathWithRelationshipsOfTypes: typeOrTypes
		havingAll: relProps
		fromNodeAt: startNodeId
		endNodeIn: [ :e | e node: labels props: endNodeProps ]
		pathIn: pathCreationBlock.
	returnedPath := self
		firstOrNilOf: (self runCypherResultWrapped: query).
	^ returnedPath ifNil: [#()] ifNotNil: [ :pa | self objectsFromCypherResults: pa relationships]
]

{ #category : #'initialize-release' }
SgGraphDb >> release [
	self sessionManager ifNotNil: [ :man | 
		man release.
		self sessionManager:nil.
	].
	super release
]

{ #category : #private }
SgGraphDb >> runCypherResultWrapped: cypherQuery [
	| rawRecords |
	rawRecords := (self runCypher: cypherQuery cypherString) firstFieldValues.
	^self objectsFromCypherResults: rawRecords
]

{ #category : #private }
SgGraphDb >> statusOfRunCypher: cypherQuery [
	^ (self runCypher: cypherQuery cypherString) status
]

{ #category : #private }
SgGraphDb >> statusOfTransactCypher: cypherQuery [
	^ (self transactCypher: cypherQuery cypherString) status
]

{ #category : #private }
SgGraphDb >> statusOfTransactCypher: cypherQuery arguments: argsDict [
	^ (self transactCypher: cypherQuery cypherString arguments: argsDict) status
]

{ #category : #private }
SgGraphDb >> transactCypherResultWrapped: cypherQuery [
	| rawRecords |
	rawRecords := (self transactCypher: cypherQuery cypherString) firstFieldValues.
	^self objectsFromCypherResults: rawRecords
]

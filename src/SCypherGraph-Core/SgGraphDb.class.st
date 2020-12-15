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

{ #category : #'actions-nodes' }
SgGraphDb >> createNodeLabeled: labelOrLabels [
	^self createNodeLabeled: labelOrLabels properties: #()
]

{ #category : #'actions-nodes' }
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

{ #category : #'actions-nodes' }
SgGraphDb >> deleteNode: aNode [
	^self deleteNodeAt: aNode id
]

{ #category : #'actions-nodes' }
SgGraphDb >> deleteNodeAt: systemId [
	| n node query |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		delete: node.
	^self statusOfTransactCypher: query
]

{ #category : #'actions-nodes' }
SgGraphDb >> deleteNodesLabeled: labelOrLabels havingAll: assocArray [
	^self deleteNodesLabeled: labelOrLabels where: [:node | node havingAll: assocArray]
]

{ #category : #'actions-nodes' }
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

{ #category : #'actions-paths' }
SgGraphDb >> matchPathWithRelationshipsOfTypes: typeOrTypes havingAll: relPropsArray fromNodeAt: startNodeId endNodeIn: endNodeBlock pathIn: pathCreationBlock whereIn: whereClauseBuilder [
	^ CyQuery
		matchPathWithRelationshipsOfTypes: typeOrTypes
		havingAll: relPropsArray
		fromNodeAt: startNodeId
		endNodeIn: endNodeBlock
		pathIn: pathCreationBlock
		whereIn: whereClauseBuilder.
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

{ #category : #'actions-nodes' }
SgGraphDb >> mergeNodeLabeled: labelOrLabels [
	^self mergeNodeLabeled: labelOrLabels properties: #()
]

{ #category : #'actions-nodes' }
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

{ #category : #'actions-nodes' }
SgGraphDb >> nodeAt: systemId [
	| n node query |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		return: node.
	^self firstOrNilOf: (self runCypherResultWrapped: query)
]

{ #category : #'actions-nodes' }
SgGraphDb >> nodeAt: systemId mergeProperties: argsDict [
	| n node query arguments |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		set: (n addAll: 'values' asCypherParameter).
	arguments := { 'values' -> argsDict asDictionary } asDictionary.
	^self statusOfTransactCypher: query arguments: arguments
]

{ #category : #'actions-nodes' }
SgGraphDb >> nodeAt: systemId properties: argsDict [
	| n node query arguments |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		set: (n to: 'values' asCypherParameter).
	arguments := { 'values' -> argsDict asDictionary } asDictionary.
	^self statusOfTransactCypher: query arguments: arguments	
]

{ #category : #'actions-nodes' }
SgGraphDb >> nodeAt: systemId propertyAt: key put: value [
	| n node query |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n. 
	query := CyQuery match: node where: (n getId equals: systemId)
		set: {(n @ key) to: value}.
	^self statusOfTransactCypher: query
]

{ #category : #'actions-nodes' }
SgGraphDb >> nodesLabeled: labelOrLabels [
	^self nodesLabeled: labelOrLabels havingAll: #()
]

{ #category : #'actions-nodes' }
SgGraphDb >> nodesLabeled: labelOrLabels havingAll: assocArray [
	^self nodesLabeled: labelOrLabels where: [:node | node havingAll: assocArray]
]

{ #category : #'actions-nodes' }
SgGraphDb >> nodesLabeled: labelOrLabels where: whereClauseBuilder [
	| labels node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node.
	^self runCypherResultWrapped: query
]

{ #category : #'actions-nodes' }
SgGraphDb >> nodesLabeled: labelOrLabels where: whereClauseBuilder orderBy: orderByClause skip: skip limit: limit [
	| labels node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node orderBy: orderByClause skip: skip limit: limit.
	^self runCypherResultWrapped: query
]

{ #category : #'actions-nodes' }
SgGraphDb >> nodesLabeled: labelOrLabels where: whereClauseBuilder skip: skip limit: limit [
	| labels node query |
	labels := labelOrLabels isArray ifTrue: [ labelOrLabels ] ifFalse: [ Array with: labelOrLabels ].
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node skip: skip limit: limit.
	^self runCypherResultWrapped: query
]

{ #category : #private }
SgGraphDb >> objectFromCypherResult: rawRecord [
	^ self graphObjectClass on: rawRecord from: self
]

{ #category : #private }
SgGraphDb >> objectsFromCypherResults: rawRecords [
	^ rawRecords collect: [:each | self objectFromCypherResult: each ]
]

{ #category : #'actions-paths' }
SgGraphDb >> oneHopPathsTyped: typeOrTypes direction: direction from: startNodeId havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps whereIn: whereClauseBuilder returning: returner [
	| pathBlock query returnedPaths |
	pathBlock := [ :startNode :rel :endNode | startNode - rel - endNode ].
	direction == #in ifTrue: [ pathBlock := [ :startNode :rel :endNode | startNode <- rel - endNode ]].
	direction == #out ifTrue: [ pathBlock := [ :startNode :rel :endNode | startNode - rel -> endNode ]].
	
	query := self
		matchPathWithRelationshipsOfTypes: typeOrTypes
		havingAll: relProps
		fromNodeAt: startNodeId
		endNodeIn: [ :e | e node: labels props: endNodeProps ]
		pathIn: pathBlock
		whereIn: whereClauseBuilder.
	returnedPaths := (self runCypherResultWrapped: query).
	^ returnedPaths collect: [ :path | self objectFromCypherResult: (returner value: path)]
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

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

{ #category : #'actions-node' }
SgGraphDb >> createNodeLabeled: label [
	^self createNodeWithLabels: (Array with: label) 
]

{ #category : #'actions-node' }
SgGraphDb >> createNodeLabeled: label properties: props [
	^self createNodeWithLabels: (Array with: label) properties: props
]

{ #category : #'actions-node' }
SgGraphDb >> createNodeWithLabels: labels [
	^self createNodeWithLabels: labels properties: #()
]

{ #category : #'actions-node' }
SgGraphDb >> createNodeWithLabels: labels properties: props [
	| n node query |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n labels: labels props: props. 
	query := CyQuery statements: {
		CyCreate of: node.
		CyReturn of: n.
	}.
	^self firstOrNilOf: (self transactCypherResultWrapped: query)
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
SgGraphDb >> deleteNodesLabeled: label havingAll: assocArray [
	^self deleteNodesWithLabels: label where: [:node | node havingAll: assocArray]
]

{ #category : #'actions-node' }
SgGraphDb >> deleteNodesWithLabels: labels where: whereClauseBuilder [
	| node query |
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) delete: node.
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

{ #category : #'actions-node' }
SgGraphDb >> mergeNodeLabeled: label [
	^self mergeNodeWithLabels: (Array with: label)
]

{ #category : #'actions-node' }
SgGraphDb >> mergeNodeLabeled: label properties: props [
	^self mergeNodeWithLabels: (Array with: label) properties: props
]

{ #category : #'actions-node' }
SgGraphDb >> mergeNodeWithLabels: labels [
	^self mergeNodeWithLabels: labels properties: #()
]

{ #category : #'actions-node' }
SgGraphDb >> mergeNodeWithLabels: labels properties: props [
	| n node query |
	n := 'n' asCypherIdentifier.
	node := CyNode name: n labels: labels props: props. 
	query := CyQuery statements: {
		CyMerge of: node.
		CyReturn of: n.
	}.
	^self firstOrNilOf: (self transactCypherResultWrapped: query)
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
SgGraphDb >> nodesLabeled: label [
	^self nodesLabeled: label havingAll: #()
]

{ #category : #'actions-node' }
SgGraphDb >> nodesLabeled: label havingAll: assocArray [
	^self nodesWithLabels: (Array with: label) where: [:node | node havingAll: assocArray]
]

{ #category : #'actions-node' }
SgGraphDb >> nodesWithLabels: labels [
	^self nodesWithLabels: labels havingAll: #()
]

{ #category : #'actions-node' }
SgGraphDb >> nodesWithLabels: labels havingAll: assocArray [
	^self nodesWithLabels: labels where: [:node | node havingAll: assocArray]
]

{ #category : #'actions-node' }
SgGraphDb >> nodesWithLabels: labels where: whereClauseBuilder [
	| node query |
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node.
	^self runCypherResultWrapped: query
]

{ #category : #'actions-node' }
SgGraphDb >> nodesWithLabels: labels where: whereClauseBuilder orderBy: orderByClause skip: skip limit: limit [
	| node query |
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node orderBy: orderByClause skip: skip limit: limit.
	^self runCypherResultWrapped: query
]

{ #category : #'actions-node' }
SgGraphDb >> nodesWithLabels: labels where: whereClauseBuilder skip: skip limit: limit [
	| node query |
	node := 'n' asCypherIdentifier.
	query := CyQuery match: (CyNode name: node labels: labels)
		 where: (whereClauseBuilder value: node) return: node skip: skip limit: limit.
	^self runCypherResultWrapped: query
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
	^ rawRecords collect: [:each | self graphObjectClass on: each from: self]
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
	^ rawRecords collect: [:each | self graphObjectClass on: each from: self]
]

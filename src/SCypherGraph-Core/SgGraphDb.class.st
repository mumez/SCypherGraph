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
SgGraphDb >> createNode: labels [
	^ self createNode: labels properties: #()
]

{ #category : #'actions-node' }
SgGraphDb >> createNode: labels properties: props [
	
]

{ #category : #factory }
SgGraphDb >> graphObjectClass [
	^ SgGraphObject
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
SgGraphDb >> transactCypherResultWrapped: cypherQuery [
	| rawRecords |
	rawRecords := (self transactCypher: cypherQuery cypherString) firstFieldValues.
	^ rawRecords collect: [:each | self graphObjectClass on: each from: self]
]

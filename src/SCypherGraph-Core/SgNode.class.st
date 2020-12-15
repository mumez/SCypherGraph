Class {
	#name : #SgNode,
	#superclass : #SgGraphObject,
	#instVars : [
		'path'
	],
	#category : #'SCypherGraph-Core'
}

{ #category : #deleting }
SgNode >> delete [
	^self db deleteNodeAt: self id
]

{ #category : #'accessing-paths' }
SgNode >> inOneHopPathsTyped: typeOrTypes havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps [
	^ self db
		oneHopPathsTyped: typeOrTypes
		direction: #in
		from: self id
		havingAll: relProps
		endNodeWithLabels: labels
		havingAll: endNodeProps
		whereIn: [:start :rel :end |] returning: [ :path | path ].
]

{ #category : #'accessing-paths' }
SgNode >> inOneHopPathsTyped: typeOrTypes where: where [
	^ self db
		oneHopPathsTyped: typeOrTypes
		direction: #in
		from: self id
		havingAll: {}
		endNodeWithLabels: {}
		havingAll: {}
		whereIn: where returning: [ :path | path ]
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationships [
	^ self inRelationshipsTyped: {}
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationshipsTyped: typeOrTypes [
	^ self inRelationshipsTyped: typeOrTypes havingAll: {} endNodeWithLabels: {} havingAll: {}
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationshipsTyped: typeOrTypes endNodeHaving: key value: value [
	^ self inRelationshipsTyped: typeOrTypes havingAll: {} endNodeWithLabels: {} havingAll: {key->value}
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationshipsTyped: typeOrTypes having: key value: value [
	^ self inRelationshipsTyped: typeOrTypes havingAll: {key->value} endNodeWithLabels: {} havingAll: {}
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationshipsTyped: typeOrTypes havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps [
	^ (self
		inOneHopPathsTyped: typeOrTypes
		havingAll: relProps
		endNodeWithLabels: labels
		havingAll: endNodeProps) collect: [ :each | each relationship ]
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationshipsTyped: typeOrTypes where: where [
	^ (self inOneHopPathsTyped: typeOrTypes where: where)
			collect: [ :each | each relationship ]
]

{ #category : #properties }
SgNode >> mergeProperties: propAssocs [
	^self db nodeAt: self id mergeProperties: propAssocs
]

{ #category : #'accessing-paths' }
SgNode >> outOneHopPathsTyped: typeOrTypes havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps [
	^ self db
		oneHopPathsTyped: typeOrTypes
		direction: #out
		from: self id
		havingAll: relProps
		endNodeWithLabels: labels
		havingAll: endNodeProps
		whereIn: [:start :rel :end |] returning: [ :path | path ].
]

{ #category : #'accessing-paths' }
SgNode >> outOneHopPathsTyped: typeOrTypes where: where [
	^ self db
		oneHopPathsTyped: typeOrTypes
		direction: #out
		from: self id
		havingAll: {}
		endNodeWithLabels: {}
		havingAll: {}
		whereIn: where returning: [ :path | path ]
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationships [
	^ self outRelationshipsTyped: {}
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsTyped: typeOrTypes [
	^ self outRelationshipsTyped: typeOrTypes havingAll: {} endNodeWithLabels: {} havingAll: {}
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsTyped: typeOrTypes endNodeHaving: key value: value [
	^ self outRelationshipsTyped: typeOrTypes havingAll: {} endNodeWithLabels: {} havingAll: {key->value}
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsTyped: typeOrTypes having: key value: value [
	^ self outRelationshipsTyped: typeOrTypes havingAll: {key->value} endNodeWithLabels: {} havingAll: {}
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsTyped: typeOrTypes havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps [
	^ (self
		outOneHopPathsTyped: typeOrTypes
		havingAll: relProps
		endNodeWithLabels: labels
		havingAll: endNodeProps) collect: [ :each | each relationship ]
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsTyped: typeOrTypes where: where [
	^ (self outOneHopPathsTyped: typeOrTypes where: where)
			collect: [ :each | each relationship ]
]

{ #category : #accessing }
SgNode >> path [
	^ path
]

{ #category : #accessing }
SgNode >> path: anObject [
	path := anObject
]

{ #category : #properties }
SgNode >> properties: propAssocs [
	^self db nodeAt: self id properties: propAssocs
]

{ #category : #properties }
SgNode >> propertyAt: key put: value [
	^self db nodeAt: self id propertyAt: key put: value
]

{ #category : #'actrions-relationships' }
SgNode >> relateOneTo: otherNode typed: types properties: propertiesArray [
	^ self db mergeOutRelationshipTyped: types fromNodeId: self id toNodeId: otherNode id properties: propertiesArray
]

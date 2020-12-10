Class {
	#name : #SgNode,
	#superclass : #SgGraphObject,
	#category : #'SCypherGraph-Core'
}

{ #category : #deleting }
SgNode >> delete [
	^self db deleteNodeAt: self id
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
	^self db 
		inRelationshipsTyped: typeOrTypes from: self id havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps
]

{ #category : #properties }
SgNode >> mergeProperties: propAssocs [
	^self db nodeAt: self id mergeProperties: propAssocs
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
	^self db 
		outRelationshipsTyped: typeOrTypes from: self id havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps
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
]

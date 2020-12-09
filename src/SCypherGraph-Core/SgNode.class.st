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
SgNode >> inRelationshipsOfType: relType [
	^ self inRelationshipsOfTypes: {relType} havingAll: {} endNodeWithLabels: {} havingAll: {}
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationshipsOfType: relType endNodeHaving: key value: value [
	^ self inRelationshipsOfTypes: {relType} havingAll: {} endNodeWithLabels: {} havingAll: {key->value}
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationshipsOfType: relType having: key value: value [
	^ self inRelationshipsOfTypes: {relType} havingAll: {key->value} endNodeWithLabels: {} havingAll: {}
]

{ #category : #'accessing-relationships' }
SgNode >> inRelationshipsOfTypes: relTypes havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps [
	^self db 
		inRelationshipsOfTypes: relTypes from: self id havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps
]

{ #category : #properties }
SgNode >> mergeProperties: propAssocs [
	^self db nodeAt: self id mergeProperties: propAssocs
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsOfType: relType [
	^ self outRelationshipsOfTypes: {relType} havingAll: {} endNodeWithLabels: {} havingAll: {}
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsOfType: relType endNodeHaving: key value: value [
	^ self outRelationshipsOfTypes: {relType} havingAll: {} endNodeWithLabels: {} havingAll: {key->value}
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsOfType: relType having: key value: value [
	^ self outRelationshipsOfTypes: {relType} havingAll: {key->value} endNodeWithLabels: {} havingAll: {}
]

{ #category : #'accessing-relationships' }
SgNode >> outRelationshipsOfTypes: relTypes havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps [
	^self db 
		outRelationshipsOfTypes: relTypes from: self id havingAll: relProps endNodeWithLabels: labels havingAll: endNodeProps
]

{ #category : #properties }
SgNode >> properties: propAssocs [
	^self db nodeAt: self id properties: propAssocs
]

{ #category : #properties }
SgNode >> propertyAt: key put: value [
	^self db nodeAt: self id propertyAt: key put: value
]

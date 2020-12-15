Class {
	#name : #SgRelationship,
	#superclass : #SgGraphObject,
	#instVars : [
		'path'
	],
	#category : #'SCypherGraph-Core'
}

{ #category : #deleting }
SgRelationship >> delete [
	^self db deleteRelationshipAt: self id
]

{ #category : #accessing }
SgRelationship >> endNode [
	^self path ifNotNil: [ :p | p endNode ]
]

{ #category : #properties }
SgRelationship >> mergeProperties: propAssocs [
	^self db relationshipAt: self id mergeProperties: propAssocs
]

{ #category : #accessing }
SgRelationship >> path [
	^ path
]

{ #category : #accessing }
SgRelationship >> path: anObject [
	path := anObject
]

{ #category : #properties }
SgRelationship >> properties: propAssocs [
	^self db relationshipAt: self id properties: propAssocs
]

{ #category : #properties }
SgRelationship >> propertyAt: key put: value [
	^self db relationshipAt: self id propertyAt: key put: value
]

{ #category : #accessing }
SgRelationship >> startNode [
	^self path ifNotNil: [ :p | p startNode ]
]

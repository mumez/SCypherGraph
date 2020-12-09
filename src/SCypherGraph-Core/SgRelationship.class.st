Class {
	#name : #SgRelationship,
	#superclass : #SgGraphObject,
	#category : #'SCypherGraph-Core'
}

{ #category : #deleting }
SgRelationship >> delete [
	^self db deleteNodeAt: self id
]

{ #category : #properties }
SgRelationship >> mergeProperties: propAssocs [
	^self db nodeAt: self id mergeProperties: propAssocs
]

{ #category : #properties }
SgRelationship >> properties: propAssocs [
	^self db nodeAt: self id properties: propAssocs
]

{ #category : #properties }
SgRelationship >> propertyAt: key put: value [
	^self db nodeAt: self id propertyAt: key put: value
]

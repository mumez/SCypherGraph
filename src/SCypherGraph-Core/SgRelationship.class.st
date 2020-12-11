Class {
	#name : #SgRelationship,
	#superclass : #SgGraphObject,
	#category : #'SCypherGraph-Core'
}

{ #category : #deleting }
SgRelationship >> delete [
	^self db deleteRelationshipAt: self id
]

{ #category : #properties }
SgRelationship >> mergeProperties: propAssocs [
	^self db relationshipAt: self id mergeProperties: propAssocs
]

{ #category : #properties }
SgRelationship >> properties: propAssocs [
	^self db relationshipAt: self id properties: propAssocs
]

{ #category : #properties }
SgRelationship >> propertyAt: key put: value [
	^self db relationshipAt: self id propertyAt: key put: value
]

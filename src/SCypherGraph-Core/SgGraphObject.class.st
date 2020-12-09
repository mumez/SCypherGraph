Class {
	#name : #SgGraphObject,
	#superclass : #SgObject,
	#instVars : [
		'rawGraphObject',
		'db'
	],
	#category : #'SCypherGraph-Core'
}

{ #category : #factory }
SgGraphObject class >> classFor: rawGraphObject [
	rawGraphObject isNode ifTrue: [ ^SgNode ].
	rawGraphObject isRelationship ifTrue: [ ^SgRelationship ].
	rawGraphObject isPath ifTrue: [ ^SgPath ].
	
	^self
]

{ #category : #'instance creation' }
SgGraphObject class >> on: rawGraphObject from: database [
	^(self classFor: rawGraphObject) new
		rawGraphObject: rawGraphObject;
		initWithDb: database;
		yourself
]

{ #category : #accessing }
SgGraphObject >> db [
	^ db
]

{ #category : #accessing }
SgGraphObject >> db: anObject [
	db := anObject
]

{ #category : #deleting }
SgGraphObject >> delete [
	^self db deleteNodeAt: self id
]

{ #category : #initialization }
SgGraphObject >> initWithDb: aDatabase [
	db := aDatabase.
	sessionManager := db sessionManager.
	settings := db settings.
	id := rawGraphObject id
]

{ #category : #properties }
SgGraphObject >> mergeProperties: propAssocs [
]

{ #category : #printing }
SgGraphObject >> printOn: aStream [
	self rawGraphObject printOn: aStream
]

{ #category : #properties }
SgGraphObject >> properties [
	^self rawGraphObject properties 
]

{ #category : #properties }
SgGraphObject >> properties: propAssocs [
]

{ #category : #properties }
SgGraphObject >> propertyAt: key [
	^self rawGraphObject properties at: key ifAbsent: [  ]
]

{ #category : #properties }
SgGraphObject >> propertyAt: key put: value [
]

{ #category : #accessing }
SgGraphObject >> rawGraphObject [
	^ rawGraphObject
]

{ #category : #accessing }
SgGraphObject >> rawGraphObject: anObject [
	rawGraphObject := anObject
]

{ #category : #loading }
SgGraphObject >> reload [
	| newGraphObject |
	newGraphObject := self db nodeAt: self id.
	self rawGraphObject: newGraphObject.
]

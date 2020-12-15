Class {
	#name : #SgPath,
	#superclass : #SgGraphObject,
	#category : #'SCypherGraph-Core'
}

{ #category : #accessing }
SgPath >> endNode [
	^self nodes last
]

{ #category : #accessing }
SgPath >> nodes [
	^ self rawGraphObject nodes
		collect: [ :each | (self graphObjectClass on: each from: self db) path: self ]
]

{ #category : #accessing }
SgPath >> relationship [
	^self relationships ifNotEmpty: [:rels | rels first]
]

{ #category : #accessing }
SgPath >> relationships [
	^ self rawGraphObject relationships
		collect: [ :each | (self graphObjectClass on: each from: self db) path: self ]
]

{ #category : #accessing }
SgPath >> startNode [
	^self nodes first
]

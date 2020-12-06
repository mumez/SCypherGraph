Class {
	#name : #SgPath,
	#superclass : #SgGraphObject,
	#category : #'SCypherGraph-Core'
}

{ #category : #accessing }
SgPath >> nodes [
	^self rawGraphObject nodes
]

{ #category : #accessing }
SgPath >> relationship [
	^self relationships ifNotEmpty: [:rels | rels first]
]

{ #category : #accessing }
SgPath >> relationships [
	^self rawGraphObject relationships
]

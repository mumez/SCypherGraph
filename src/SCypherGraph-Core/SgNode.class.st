Class {
	#name : #SgNode,
	#superclass : #SgGraphObject,
	#category : #'SCypherGraph-Core'
}

{ #category : #deleting }
SgNode >> delete [
	^self db deleteNodeAt: self id
]

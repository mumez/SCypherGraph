Class {
	#name : #SgSettings,
	#superclass : #SbSettings,
	#category : #'SCypherGraph-Core'
}

{ #category : #accessing }
SgSettings >> sessionManagerClassName [
	"SbClientSessionManager|SbFixedSessionManager"
	^ self at: #sessionManagerClassName ifAbsentPut: ['SbClientSessionManager']
]

{ #category : #accessing }
SgSettings >> sessionManagerClassName: aString [
	"SbClientSessionManager|SbFixedSessionManager"
	^ self at: #sessionManagerClassName put: aString
]

{ #category : #accessing }
SgSettings >> sessionManagerCreationPolicy [
	"#useDefault | #createNew"
	^ self at: #sessionManagerCreationPolicy ifAbsentPut: [#useDefault]
]

{ #category : #accessing }
SgSettings >> sessionManagerCreationPolicy: aSymbol [
	"#useDefault | #createNew"
	^ self at: #sessionManagerCreationPolicy put: aSymbol
]

{ #category : #accessing }
SgSettings >> standByClients [
	^ self at: #standByClients ifAbsentPut: [3]
]

{ #category : #accessing }
SgSettings >> standByClients: anInteger [
	^ self at: #standByClients put: anInteger
]

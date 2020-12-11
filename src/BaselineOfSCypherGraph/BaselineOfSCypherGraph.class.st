Class {
	#name : #BaselineOfSCypherGraph,
	#superclass : #BaselineOf,
	#category : #BaselineOfSCypherGraph
}

{ #category : #baseline }
BaselineOfSCypherGraph >> baseline: spec [
	<baseline>

	spec for: #common do: [
		self scypher: spec.
		spec 
			package: 'SCypherGraph-Core' with: [spec requires: 'SCypher'];
			package: 'SCypherGraph-Tests' with: [ spec requires: #('SCypherGraph-Core')].
		spec 
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('SCypherGraph-Core');
			group: 'Tests' with: #('SCypherGraph-Tests')].
		

]

{ #category : #'external projects' }
BaselineOfSCypherGraph >> scypher: spec [
	spec
		baseline: 'SCypher'
		with: [ spec
				repository: 'github://mumez/SCypher/repository';
				loads: 'default' ]
]

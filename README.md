# SCypherGraph
High-level object wrapper of [Neo4j](https://neo4j.com/) graph database using [SmallBolt](https://github.com/mumez/SmallBolt) and [SCypher](https://github.com/mumez/SCypher)

# Installation

```smalltalk
Metacello new
  baseline: 'SCypherGraph';
  repository: 'github://mumez/SCypherGraph:main/src';
  load.
```

# Examples

## Basic

```smalltalk
db := SgGraphDb default.
db settings username: 'neo4j'; password: 'neoneo'.
db allLabels. "Get all node labels"

"Print 'Movie' node properties"
(db nodesLabeled: 'Movie') 
   do: [ :each | self traceCr: each properties ].
```

## Get node with where:

```smalltalk
matrix := (db nodesLabeled: 'Movie' where: [:each | each @ 'title' = 'The Matrix']) first.
matrix properties.
```

## Get relationships

```smalltalk
matrix inRelationships.
matrix outRelationships.

(matrix inRelationshipsTyped: 'ACTED_IN')
  collect: [:each | each endNode @ 'name']. 
```

## Get relationships with where:

```smalltalk
(matrix inRelationshipsTyped: 'ACTED_IN' where: [ :start :rel :end | (rel @ 'roles') = #('Neo') ])
  collect: [ :each | each endNode properties ].
```

## Create nodes

```smalltalk
sf := db mergeNodeLabeled: 'Genre' properties: {'name'->'SF'. 'description'->'Science Fiction'}.
action := db mergeNodeLabeled: 'Genre' properties: {'name'->'Action'. 'description'->'Exciting Actions'}. 
```

## Create relationships

```smalltalk
matrixToSf := matrix relateOneTo: sf typed: 'HAS_GENRE' properties: {'score'-> 6}.
matrixToAction := matrix relateTo: action typed: 'HAS_GENRE' properties: {'score'-> 7}. 
```

## Execute Cypher directly

```smalltalk
db runCypher: 'UNWIND range(1, 10) AS n RETURN n*n'. "inspect it"

db runCypher: 'UNWIND range($from, $to) AS n RETURN n*n' 
   arguments: {'from'->2. 'to'->5}. "inspect it"
```

## Execute dynamically generated Cypher

```smalltalk
m := 'm' asCypherObject. "Movie"
p := 'p' asCypherObject. "Person"
o := 'o' asCypherObject. "Other person"

pathPattern := (p node: 'Person') - ('act1' asCypherObject rel: 'ACTED_IN' ) -> (m node: 'Movie' props: {'released'->2000})  <- ('act2' asCypherObject rel: 'ACTED_IN' ) - (o node: 'Person').

actorNameParam := 'actorName' asCypherParameter.
where := (p @ 'name') starts: actorNameParam.
"where := ((p @ 'born') > 1970) and: ((o @ 'born') > 1970). " " <= try changing"

return := (p @ 'name'), (o @ 'name'), (m @ 'title').

query := CyQuery match: pathPattern where: where return: return orderBy: (p @ 'name') skip: 0 limit: 100. "print it"

result := db runCypher: query arguments: { actorNameParam -> 'Tom' }.
(result fieldValues groupedBy: [ :each | each at: 1 ]). "inspect it"
```

## Changing IP and port

```smalltalk
db settings targetUri: 'bolt://127.0.0.1:7687'.
```


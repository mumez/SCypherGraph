# SCypherGraph
[WIP] Object wrapper of Neo4j graph database using SmallBolt and SCypher

# Installation

```smalltalk
Metacello new
  baseline: 'SCypherGraph';
  repository: 'github://mumez/SCypherGraph:main/src';
  load.
```

# Examples

```smalltalk
db := SgGraphDb default.
db allLabels.
db nodesLabeled: 'Movie'
```
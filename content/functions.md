## Time Functions
{:#functions}

To address the limitations of SPARQL when dealing with temporal data, particularly the inability to compare partial or floating time literals, we propose a set of SPARQL extension functions called **Time Functions**.
These functions allow for consistent, meaningful comparison and reasoning over heterogeneous temporal literals by interpreting them as **time intervals**.

The formal specification and accompanying ontology for these functions are available at [https://w3id.org/time-fn/](https://w3id.org/time-fn/).
The ontology uses the namespace `https://w3id.org/time-fn/` with the recommended prefix `time-fn:`.
This specification defines the semantics of each function and provides an ontology for integrating time-aware logic into SPARQL queries.
The ontology is defined in Turtle using the [Function Ontology (FnO)](cite:cites de2016ontology) to formally describe the semantics, inputs, and outputs of each function.
FnO provides a reusable and machine-readable vocabulary for specifying function metadata, which is well-suited for describing SPARQL extension functions.
This approach aligns with best practices in the Semantic Web community and mirrors how the GeoSPARQL specification defines its own function set using FnO.[^GeoSPARQLFunctions]
By adopting the same method, the Time Functions can be consistently documented, discovered, and potentially reused by other tools and specifications.

[^GeoSPARQLFunctions]: [https://github.com/opengeospatial/ogc-geosparql/blob/master/vocabularies/functions.ttl](https://github.com/opengeospatial/ogc-geosparql/blob/master/vocabularies/functions.ttl)

### Motivation and Design

Time Functions treats all temporal literals as time intervals.
Each literal is interpreted as the range of time it could plausibly represent, defined by its earliest and latest possible interpretations.
For instance, a literal like `"2025-08"^^xsd:gYearMonth` can be understood as spanning from the start of August 1st (`"2025-08-01T00:00:00-14:00"^^xsd:dateTime`) to the end of August 31st (`"2025-08-31T23:59:59+14:00"^^xsd:dateTime`).
Floating date-time values, which lack explicit time zone information, are interpreted as intervals that encompass all possible time zone offsets—following the [W3C Recommendation](cite:cites v_biron_xml_2004) to consider the full ±14:00 hour range, rather than a fixed default like UTC.

By shifting from point-based to interval-based reasoning, these functions enable meaningful comparisons across data types, handle ambiguities introduced by missing time zones or precision, and make temporal filtering in SPARQL more reliable and consistent.


### Overview of Time Functions

The current Time Functions include five core functions:

- **time-fn:periodMinInclusive(?timeLiteral)**: Returns the inclusive lower bound of the time period represented by the given temporal literal, as an `xsd:dateTime`.
- **time-fn:periodMaxInclusive(?timeLiteral)**: Returns the inclusive upper bound of the time period represented by the given temporal literal.
- **time-fn:periodMinExclusive(?timeLiteral)**: Returns the exclusive lower bound of the time period. This is particularly useful for defining open-ended or non-overlapping intervals in filtering logic.
- **time-fn:periodMaxExclusive(?timeLiteral)**: Returns the exclusive upper bound of the time period.
- **time-fn:bindDefaultTimezone(?timeLiteral, ?timeZone)**: For a given `xsd:dateTime` literal without a time zone (i.e., a floating time), this function returns a new literal with the specified time zone bound. If the literal already includes a time zone, it is returned unchanged.
The function aligns with the approach proposed in [Working with Time and Timezones](cite:cites phillips_working_2024), which recommends interpreting floating times as UTC by default.
However, it also supports more flexible, context-specific interpretations by allowing users to explicitly specify an alternative time zone.
Caution is advised when applying this function across data from heterogeneous sources, as there is no universally correct default time zone.
Nevertheless, the function enables binding a default time zone retrieved dynamically from the dataset itself.
For example, a SERVICE clause may be used to ensure that the time zone is sourced from the same dataset or endpoint as the time literal, preserving consistency within federated queries.


### Use Cases

The Time Functions are applicable in a wide range of practical scenarios. When comparing dates of different data types, such as matching an `xsd:dateTime` with an `xsd:date`, the functions allow both values to be interpreted as intervals and compared accordingly.
This is particularly useful in knowledge graphs where schema constraints are loose and data often lacks uniform temporal granularity.

Floating time literals pose challenges in distributed and heterogeneous datasets. Without a defined time zone, their interpretation is ambiguous, which can lead to incorrect comparisons or missed matches. Time Functions make it possible to consistently bind a default time zone where appropriate or interpret the literal as an interval that spans all possible time zones, depending on the application's needs.

These functions also support more advanced temporal logic, such as detecting overlaps between time periods, validating temporal boundaries, and improving sorting behavior. In knowledge graphs like Wikidata, where date precision is user-defined but not preserved in SPARQL query results, Time Functions allow users to reconstruct and reason about the intended temporal scope of such data. More generally, they provide a principled foundation for integrating diverse temporal representations in SPARQL queries, enabling more accurate and expressive querying of temporal knowledge.

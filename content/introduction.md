## Introduction
{:#introduction}

Temporal literals are common in many datasets on the Semantic Web.
SPARQL, the standard query language for RDF, is frequently used to query, filter, and compare such temporal information.
However, current support for comparing and reasoning over time-related literals in SPARQL is limited, especially when it comes to *partial time literals* (e.g., `xsd:gYear`, `xsd:gYearMonth`, `xsd:date`) and *floating times* (i.e., time literals without explicit time zones).

Although [the RDF 1.1 standard](cite:cites cyganiak_rdf_2014) recommends the use of various built-in XML Schema temporal data types (e.g., `xsd:dateTime`, `xsd:date`, and `xsd:gYearMonth`), the [operator mappings from SPARQL 1.1](cite:cites harris_sparql_2013) define comparison semantics only for literals of the same data type.
Cross-datatype comparisons (e.g., comparing an `xsd:date` with an `xsd:dateTime`) are not defined, and existing SPARQL engines and querying frameworks such as Virtuoso, BlazeGraph, and Comunica return false or empty results in these cases, even if the date parts of the literals are comparable.

This issue becomes problematic in large-scale, real-world knowledge graphs like Wikidata, where users can specify date precision (e.g., year, month, day) when entering temporal data.
Its SPARQL endpoint, however, returns fully qualified `xsd:dateTime` values without indicating the original precision.
For example, a historical event entered as `27th century BCE` may appear as such in the user interface, but is internally represented and queryable only as `"−2650-01-01T00:00:00Z"^^xsd:dateTime`.
This loss of precision in the queryable data undermines temporal reasoning and can produce misleading query results, such as asserting that this historical event happened in the month of January.

Another critical challenge arises with *floating times*, which are time literals that lack time zone information.
A literal like `"2025-08-01T12:00:00"^^xsd:dateTime` can be interpreted differently depending on the context, or may be wrongly adjusted to the user’s local time zone.
This ambiguity makes consistent comparison and sorting unreliable.
While the [W3C Group Draft Note on Working with Time and Timezones](cite:cites phillips_working_2024) recommends treating such floating times as UTC by default, this approach is insufficient in the open and distributed context of the Semantic Web, where data originates from diverse sources with potentially different implicit time zone assumptions.
As discussed in the GitHub issue regarding implicit time zones in SPARQL[^IssueImplicitTimeZoneComparisonSorting], it is problematic to consider floating times from different sources as equal because they can represent different time instants and thus have different implicit time zones.

[^IssueImplicitTimeZoneComparisonSorting]: [https://github.com/w3c/sparql-query/issues/116](https://github.com/w3c/sparql-query/issues/116)

A more robust approach is to treat all temporal literals—particularly floating and partial ones—as time intervals, bounded by their earliest and latest possible interpretations.
For example, a floating time can be represented by the time interval it could occupy across the full range of legal time zone offsets (−14:00 to +14:00, as per [XML Schema Part 2: Datatypes Second Edition](cite:cites v_biron_xml_2004)).
This perspective enables meaningful comparison between floating, partial, and fully-qualified time literals by aligning them to their temporal bounds rather than requiring exact matches.

Despite the growing interest in temporal reasoning on knowledge graphs, e.g., in works such as [Soulard et al. 2025](cite:cites soulard2025explainable), issues around time zones and floating times are rarely addressed explicitly.
Moreover, while enhancement proposals like SEP-0002[^SEP-0002] improve SPARQL’s handling of date-time arithmetic, they do not cover cross-type comparison or floating time semantics.

[^SEP-0002]: [https://github.com/w3c/sparql-dev/blob/main/SEP/SEP-0002/sep-0002.md](https://github.com/w3c/sparql-dev/blob/main/SEP/SEP-0002/sep-0002.md)

This paper aims to highlight these overlooked issues and present a concrete, extensible solution.
We propose a set of SPARQL extension functions—called *Time Functions*—that enable comparison across different temporal data types, interpretation of floating and partial times as intervals, and consistent and explainable time-based filtering and sorting.

The remainder of this paper is structured as follows.
[](#functions) introduces the proposed SPARQL extension functions for time handling, along with their formal semantics.
Subsequently, [](#demo) presents a demo application showcasing how these functions enable richer and more accurate temporal queries over RDF data.
Finally, [](#conclusion) concludes with a discussion of how Time Functions address the limitations of SPARQL for temporal reasoning, highlights their relevance for future standardization, and encourages improved temporal data publishing practices.

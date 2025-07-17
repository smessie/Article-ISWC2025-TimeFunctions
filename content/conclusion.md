## Conclusion
{:#conclusion}

Temporal data is pervasive on the Semantic Web, yet SPARQL currently lacks the expressive capabilities needed to correctly compare and reason over partial and floating time literals.
One common issue is the inability to compare values like `xsd:date` and `xsd:dateTime` directly—despite them potentially representing the same calendar day—because SPARQL requires operands to be of the same datatype.
Separately, data modeling practices further complicate temporal reasoning: for instance, Wikidata represents imprecise time periods such as “27th century BCE” using a single `xsd:dateTime` literal (e.g., "-2650-01-01T00:00:00Z"), thereby flattening a broad time range into a misleading instant.
Likewise, floating time literals without explicit time zones make comparisons and sorting ambiguous, especially in federated or heterogeneous data settings.
These challenges highlight a broader need for improved temporal data publishing practices: data should be expressed using accurate data types that reflect temporal granularity, and time zones should be made explicit wherever possible to avoid implicit and potentially conflicting assumptions.

To address these limitations, this paper proposed a set of SPARQL extension functions, **Time Functions**, which reinterpret time literals as time intervals, enabling consistent and type-agnostic comparisons.
These functions support partial dates, floating times, and even cross-type comparisons by interpreting each time literal as a bounded interval, which can then be compared meaningfully using SPARQL.
Additionally, a function for binding a default time zone enables explicit handling of floating times in a configurable way.
These functions are formally specified using the Function Ontology (FnO), following established practices such as those in GeoSPARQL, and are implemented in a demo application using the Comunica query engine.
The demo provides an interactive environment to explore the functions in action and illustrates how they resolve common pitfalls in temporal querying.

While the functions offer an immediate and practical solution, they are also intended to contribute to the broader discussion around improving temporal reasoning in SPARQL 1.2 and beyond.
By surfacing the challenges and demonstrating a viable path forward, we hope this work sparks further standardization efforts and community feedback.

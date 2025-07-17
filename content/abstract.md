## Abstract
<!-- Context:      Why the need is so pressing or important -->
Working with temporal data on the Semantic Web remains challenging due to SPARQL’s limited support for comparing time literals of different data types and handling floating times without explicit time zones.
<!-- Need:         Why something needed to be done at all -->
These issues are especially problematic when dealing with partial time literals (such as `xsd:date`, `xsd:gYearMonth`, or `xsd:gYear`) and floating times, both of which are common in real-world knowledge graphs like Wikidata.
<!-- Task:         What was undertaken to address the need -->
To showcase the relevance and urgency of the problem, we gathered and reviewed existing discussions, specifications, draft proposals, and examples from deployed knowledge graphs, providing a consolidated starting point for further community dialogue.
<!-- Object:       What the present document does or covers -->
We then proposed a solution in the form of a set of SPARQL extension functions—**Time Functions**—designed to reinterpret time literals as time intervals, enabling consistent and type-agnostic temporal comparisons.
<!-- Findings:     What the work done yielded or revealed -->
These functions are formally described using the Function Ontology (FnO), and implemented in the Comunica query engine, with a publicly available demo application that allows users to interactively explore and test the functions.
<!-- Conclusion:   What the findings mean for the audience -->
The demo includes curated example queries that highlight both the limitations of existing SPARQL behavior and how the Time Functions enable more accurate filtering and sorting of temporal data.
<!-- Perspectives: What the future holds, beyond this work -->
In addition to providing a technical proposal, we advocate for improved temporal data publishing practices, urging data providers to use accurate data types and explicit time zones to support reliable temporal reasoning in the open-world context of RDF.

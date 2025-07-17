## Demo
{:#demo}

To illustrate the practical utility of the Time Functions, we developed an online demo application, available at [https://smessie.github.io/TimezonelessTimeLiteralsInSparqlDemo/](https://smessie.github.io/TimezonelessTimeLiteralsInSparqlDemo/).
The application is a lightweight SPARQL query editor that allows users to experiment interactively with the Time Functions described in [](#functions).

Users can write SPARQL queries and immediately view the results, demonstrating how the Time Functions can address limitations in standard SPARQL when comparing partial or floating time literals.
Under the hood, the demo runs on the [Comunica query engine](cite:cites taelman_iswc_resources_comunica_2018), which has been extended to support these custom SPARQL extension functions.
The query interface itself is powered by the open-source YASQE editor[^Yasqe], which offers features such as syntax highlighting and autocompletion.

[^Yasqe]: [https://docs.triply.cc/yasgui-api/#yasqe](https://docs.triply.cc/yasgui-api/#yasqe)

<figure id="fig:default-query" class="halfwidth">
 <img src="img/demo-default-query.png" alt="[Demo app with default query comparing an `xsd:date` to an `xsd:dateTime` yielding no results.]" />
 <figcaption markdown="block">
 Demo app with default query comparing an `xsd:date` to an `xsd:dateTime` yielding no results.
 </figcaption>
</figure>

<figure id="fig:rewritten-query" class="halfwidth right">
 <img src="img/demo-rewritten-query.png" alt="[Demo app with query using Time Functions to compare an `xsd:date` to an `xsd:dateTime`, yielding expected results.]" />
 <figcaption markdown="block">
 Demo app with query using Time Functions to compare an `xsd:date` to an `xsd:dateTime`, yielding expected results.
 </figcaption>
</figure>


The application includes example queries that highlight common pitfalls when working with time literals in SPARQL, as well as how the Time Functions can be used to resolve them.
Figure 1 shows a screenshot of the demo with a query that compares an `xsd:date` to an `xsd:dateTime`.
Since SPARQL does not support comparisons between these types, the query yields no results—even though the date components are equivalent.
In Figure 2, the same query is rewritten using the Time Functions to map both literals to their corresponding time intervals.
This allows for a meaningful comparison, and the query returns the expected result.


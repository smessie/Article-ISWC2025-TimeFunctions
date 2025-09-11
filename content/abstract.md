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

<span id="keywords" rel="schema:about"><strong class="title">Keywords</strong>
<a href="https://en.wikipedia.org/wiki/SPARQL" resource="http://dbpedia.org/resource/SPARQL">SPARQL</a>,
time literals,
extension functions,
partial times,
floating times
</span>

<span id="demo" rel="schema:url"><strong class="title">Demo:</strong>
<a href="https://smessie.github.io/TimeFunctions-SPARQL-Editor/">https://smessie.github.io/TimeFunctions-SPARQL-Editor/</a></span>

<span id="canonical" rel="schema:url"><strong class="title">Canonical version:</strong>
<a href="https://smessie.github.io/Article-ISWC2025-TimeFunctions/">https://smessie.github.io/Article-ISWC2025-TimeFunctions/</a></span>

<span class="printonly firstpagefooter">
<span class="firstpagefootertop">&nbsp;</span>
<span class="footnotecopyright">
<span style="font-style:italic">Posters, Demos, and Industry Tracks at ISWC 2025, November 2--6, 2024, Nara, Japan</span><br />
<img src="img/mail.png" width="12px" style="vertical-align: -2px;" /> <a href="mailto:ieben.smessaert@ugent.be">ieben.smessaert@ugent.be</a> (I. Smessaert); <a href="mailto:julianandres.rojasmelendez@ugent.be">julianandres.rojasmelendez@ugent.be</a> (J. Rojas); <a href="mailto:pieter.colpaert@ugent.be">pieter.colpaert@ugent.be</a> (P. Colpaert)<br />
<img src="img/orcid.svg" width="12px" style="vertical-align: -2px;" /> <a href="https://orcid.org/0009-0004-5281-0723">0009-0004-5281-0723</a> (I. Smessaert); <a href="https://orcid.org/0000-0002-6645-1264">0000-0002-6645-1264</a> (J. Rojas); <a href="https://orcid.org/0000-0001-6917-2167">0000-0001-6917-2167</a> (P. Colpaert)<br />
<img src="img/cc-by.png" width="50px" style="vertical-align: middle;" /><span style="font-size: 0.75em">&ensp;© 2025 Copyright for this paper by its authors. Use permitted under Creative Commons License Attribution 4.0 International (CC BY 4.0).</span><br />
</span>
</span>
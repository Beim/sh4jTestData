<?xml version="1.0" encoding="iso-8859-1" standalone="yes" ?>
<!-- $Id: owl2html.xsl,v 1.5 2004/06/20 21:39:34 euzenat Exp $ -->

<!-- This stylesheet provides a rough view of a particular ontology -->
<!-- TODO:
     - base axioms
     - find same entity -->

<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:bib="http://www.inrialpes.fr/exmo/papers"
 xmlns:datext="http://www.jclark.com/xt/java/java.util.Date"
 xmlns:datexa="xalan://java.util.Date"
 xmlns:units="http://visus.mit.edu/fontomri/0.01/units.owl#"
 xmlns:foaf="http://xmlns.com/foaf/0.1/#"
 xmlns:ical="http://www.w3.org/2002/12/cal/#"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
 xmlns:owl="http://www.w3.org/2002/07/owl#"
 xmlns:wot="http://xmlns.com/wot/0.1/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:dcterms="http://purl.org/dc/terms/"
 xmlns:dctype="http://purl.org/dc/dcmitype/"
 xmlns:bibtex="http://purl.org/net/nknouf/ns/bibtex#">

<xsl:template match="/">

<html>
<head><title><xsl:value-of select="rdf:RDF/owl:Ontology/rdfs:label/text()"/></title></head>
<body bgcolor="ffffff">
<xsl:apply-templates select="rdf:RDF/owl:Ontology" />


<!-- select all the ordered templates in a variable
  select all the content with same name in a variable 
-->

<!-- apply these templates to -->

<h2>Classes</h2>
<xsl:variable name="croots"
	      select="rdf:RDF/owl:Class[not(rdfs:subClassOf/@rdf:resource)
		      or (not(starts-with(rdfs:subClassOf/@rdf:resource,'#')))]" />
<dl>
<xsl:for-each select="$croots">
  <xsl:apply-templates select="."/>
</xsl:for-each>
</dl>

<h2>Properties</h2>
<xsl:variable name="oproots" select="rdf:RDF/owl:ObjectProperty[not(rdfs:subPropertyOf/@rdf:resource)
		      or (not(starts-with(rdfs:subPropertyOf/@rdf:resource,'#')))]" />
<dl>
<xsl:for-each select="$oproots">
  <xsl:apply-templates select="."/>
</xsl:for-each>
</dl>
<xsl:variable name="dproots" select="rdf:RDF/owl:DatatypeProperty[not(rdfs:subPropertyOf/@rdf:resource)
		      or (not(starts-with(rdfs:subPropertyOf/@rdf:resource,'#')))]" />
<dl>
<xsl:for-each select="$dproots">
  <xsl:apply-templates select="."/>
</xsl:for-each>
</dl>

<h2>Individuals</h2>
<dl>
<xsl:for-each select="rdf:RDF/*[not(self::owl:Ontology) and not(self::owl:DatatypeProperty) and not(self::owl:ObjectProperty) and not(self::owl:Class)]">
  <xsl:apply-templates select="."/>
</xsl:for-each>
</dl>

<hr />
<address>
<!-- for XT -->
<xsl:choose>
  <xsl:when test="function-available('datext:to-string') and function-available('datext:new')">
    Generated by OWL2HTML on <xsl:value-of select="datext:to-string(datext:new())"/>
  </xsl:when>
  <!-- for Xalan -->
  <xsl:when test="function-available('datexa:toString') and function-available('datexa:new')">
    Generated by OWL2HTML on <xsl:value-of select="datexa:toString(datexa:new())"/>
  </xsl:when>
  <xsl:otherwise>Generated by OWL2HTML</xsl:otherwise>
</xsl:choose>
</address>
</body>
</html>

</xsl:template>

<xsl:template match="owl:Ontology">
<h1><xsl:value-of select="rdfs:label/text()"/></h1>
<p><xsl:value-of select="dc:description/text()"/></p>
<p>
<i><xsl:value-of select="rdfs:comment/text()"/></i><br />
Author: <xsl:value-of select="dc:creator/text()"/><br />
Contributor: <xsl:for-each select="dc:contributor">
<xsl:value-of select="text()"/><xsl:text>, </xsl:text></xsl:for-each>
<br />
Date: <xsl:value-of select="dc:date/text()"/><br />
Version: <xsl:value-of select="owl:versionInfo/text()"/>
</p>
</xsl:template>

<xsl:template match="owl:Class">
  <xsl:param name="super"/>
  <xsl:variable name="od">
    <xsl:choose>
      <xsl:when test="@rdf:ID"><xsl:value-of select="@rdf:ID"/></xsl:when>
      <xsl:when test="@rdf:about"><xsl:value-of select="@rdf:about"/></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <dt><b><a name="{$od}"><xsl:value-of select="$od"/></a></b>
    <xsl:text> (</xsl:text><xsl:value-of
    select="rdfs:label/text()"/>, <i><xsl:value-of select="rdfs:comment/text()"/>)</i>
  </dt>
  <dd>
    <xsl:apply-templates select="rdfs:subClassOf[@rdf:resource]" mode="ref">
      <xsl:with-param name="super" select="$super"/>
    </xsl:apply-templates>
  <ul><xsl:call-template name="iterRestriction">
      <xsl:with-param name="rests" select="rdfs:subClassOf/owl:Restriction"/>
    </xsl:call-template>
  </ul>
  <dl> <!-- Yes, n^2, sorry about that -->
    <xsl:for-each select="//rdf:RDF/owl:Class">
      <xsl:if test="./rdfs:subClassOf[@rdf:resource=concat('#',$od)]">
	<xsl:apply-templates select=".">
	  <xsl:with-param name="super" select="concat('#',$od)" />
	</xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </dl></dd>
</xsl:template>

<xsl:template match="rdfs:subClassOf" mode="ref">
  <xsl:param name="super"/>
  <xsl:choose>
    <xsl:when test="@rdf:resource">
      <xsl:variable name="name" select="@rdf:resource"/>
      <xsl:if test="not($name = $super)">
	<xsl:text>super: </xsl:text><i><a href="{$name}">
	    <xsl:value-of select="$name"/></a></i><br />
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>super: </xsl:text><xsl:apply-templates select="*" mode="ref"/><br />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="owl:Class" mode="ref">
  <xsl:choose>
    <xsl:when test="@rdf:resource">
      <i><a href="{@rdf:resource}">
	  <xsl:value-of select="@rdf:resource"/></a></i>
    </xsl:when>
    <xsl:when test="@rdf:about">
      <i><a href="{@rdf:about}">
	  <xsl:value-of select="@rdf:about"/></a></i>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*" mode="ref"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="owl:unionOf" mode="ref">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="ref"/>
    <xsl:if test="position() != last()"><xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="owl:intersectionOf" mode="ref">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="ref"/>
    <xsl:if test="position() != last()"><xsl:text> &amp; </xsl:text>
    </xsl:if>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="owl:complementOf" mode="ref">
  <xsl:text>-</xsl:text>
  <xsl:apply-templates select="*[1]" mode="ref"/>
</xsl:template>

<xsl:template match="owl:oneOf" mode="ref">
  <xsl:text> { </xsl:text>
  <xsl:apply-templates select="*" />
  <xsl:text> } </xsl:text>
</xsl:template>

<!-- Generic treatment of individuals -->
<!--xsl:template match="*">
  <xsl:text> { </xsl:text>
  <xsl:apply-templates select="*" />
  <xsl:text> } </xsl:text>
</xsl:template-->

<xsl:template name="iterRestriction">
  <xsl:param name="rests"/>
  <xsl:if test="$rests">
    <xsl:if test="not($rests[(position() &gt; 1) and
     (owl:onProperty/@rdf:resource = $rests[1]/owl:onProperty/@rdf:resource)])">
      <xsl:apply-templates select="$rests[1]"/>
    </xsl:if>
    <xsl:call-template name="iterRestriction">
      <xsl:with-param name="rests" select="$rests[position() &gt; 1]"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="owl:Restriction">
  <xsl:variable name="name" select="owl:onProperty[1]/@rdf:resource"/>
    <li><a href="{$name}"><xsl:value-of select="$name"/></a>
      <xsl:variable name="rests"
		    select="../../rdfs:subClassOf/owl:Restriction[owl:onProperty/@rdf:resource=$name]/*[2]"/>
      <xsl:apply-templates select="$rests"/>
    </li>
</xsl:template>

<xsl:template match="owl:allValuesFrom">
  <xsl:text> </xsl:text>
  <xsl:choose>
    <xsl:when test="@rdf:resource">
      <xsl:call-template name="name">
	<xsl:with-param name="name" select="@rdf:resource"/>
      </xsl:call-template><br />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*" mode="ref"/><br />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="owl:someValuesFrom">
  <xsl:text> (</xsl:text>
  <xsl:choose>
    <xsl:when test="@rdf:resource or @rdf:about">
	<xsl:apply-templates select="@rdf:resource|@rdf:about" mode="ref"/><br />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*" mode="ref"/><br />
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>) </xsl:text>
 </xsl:template>

<xsl:template name="name">
  <xsl:param name="name"/>
  <i><a href="{$name}"><xsl:value-of select="$name"/></a></i>
</xsl:template>

<xsl:template match="owl:cardinality">
  <xsl:text> [</xsl:text><xsl:value-of select="text()"/><xsl:text> </xsl:text><xsl:value-of select="text()"/><xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="owl:minCardinality">
  <xsl:text> [</xsl:text><xsl:value-of select="text()"/><xsl:text> +oo]</xsl:text>
</xsl:template>

<xsl:template match="owl:maxCardinality">
  <xsl:text> [0 </xsl:text><xsl:value-of select="text()"/><xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="*" mode="signature">
    <xsl:choose>
      <xsl:when test="rdfs:domain/@rdf:resource">
	<xsl:text> </xsl:text><a href="{rdfs:domain/@rdf:resource}"><xsl:value-of select="rdfs:domain/@rdf:resource"/></a>
      </xsl:when>
      <xsl:when test="rdfs:domain">
	<xsl:apply-templates select="rdfs:domain/*" mode="ref"/>
      </xsl:when>
      <xsl:otherwise><xsl:text>_</xsl:text></xsl:otherwise>
    </xsl:choose>
    <xsl:text> -> </xsl:text>
    <xsl:choose>
      <xsl:when test="rdfs:range/@rdf:resource">
	<xsl:text> </xsl:text><a href="{rdfs:range/@rdf:resource}"><xsl:value-of select="rdfs:range/@rdf:resource"/></a>
      </xsl:when>
      <xsl:when test="rdfs:range">
	<xsl:apply-templates select="rdfs:range/*" mode="ref"/>
      </xsl:when>
      <xsl:otherwise><xsl:text>_</xsl:text></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="owl:ObjectProperty">
  <xsl:variable name="od">
    <xsl:choose>
      <xsl:when test="@rdf:ID"><xsl:value-of select="@rdf:ID"/></xsl:when>
      <xsl:when test="@rdf:about"><xsl:value-of select="@rdf:about"/></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <dt><b><a name="{$od}"><xsl:value-of select="$od"/></a></b>:
    <xsl:apply-templates select="." mode="signature"/>
    <i> (<xsl:value-of select="rdfs:comment/text()"/>)</i>
  </dt><dd>
  <dl>
    <xsl:for-each select="//rdf:RDF/owl:ObjectProperty">
      <xsl:if test="./rdfs:subPropertyOf[@rdf:resource=concat('#',$od)]">
	<xsl:apply-templates select="."/>
      </xsl:if>
    </xsl:for-each>
  </dl></dd>
</xsl:template>

<xsl:template match="owl:DatatypeProperty">
  <xsl:variable name="od">
    <xsl:choose>
      <xsl:when test="@rdf:ID"><xsl:value-of select="@rdf:ID"/></xsl:when>
      <xsl:when test="@rdf:about"><xsl:value-of select="@rdf:about"/></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <dt><b><a name="{$od}"><xsl:value-of select="$od"/></a></b>
    <xsl:apply-templates select="." mode="signature"/>
    <i> (<xsl:value-of select="rdfs:comment/text()"/>)</i>
  </dt><dd>
  <dl>
    <xsl:for-each select="//rdf:RDF/owl:DatatypeProperty">
      <xsl:if test="./rdfs:subPropertyOf[@rdf:resource=concat('#',$od)]">
	<xsl:apply-templates select="."/>
      </xsl:if>
    </xsl:for-each>
  </dl></dd>
</xsl:template>

<xsl:template match="*">
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="@rdf:ID"><xsl:value-of select="@rdf:ID"/></xsl:when>
      <xsl:when test="@rdf:about"><xsl:value-of select="substring(@rdf:about,2)"/></xsl:when>
      <xsl:when test="@rdf:resource"><xsl:value-of select="substring(@rdf:resource,2)"/></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <dt><xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>@</xsl:text>
    <xsl:choose>
    <xsl:when test="$name"><a name="{$name}"><xsl:value-of select="$name"/></a></xsl:when>
    <xsl:otherwise><xsl:text>_</xsl:text></xsl:otherwise>
  </xsl:choose>
  <xsl:text>&gt;</xsl:text></dt><dd>
  <ul compact="1"><xsl:for-each select="*">
    <li><xsl:apply-templates select="." mode="attr"/></li>
  </xsl:for-each></ul></dd>
</xsl:template>

<xsl:template match="*" mode="attr">
  <xsl:value-of select="name()"/>
  <xsl:text> = </xsl:text>
  <xsl:choose>
    <xsl:when test="*"><xsl:apply-templates select="*"/></xsl:when>
    <xsl:when test="@rdf:resource"><xsl:text>&lt;_@</xsl:text><a href="{@rdf:resource}"><xsl:value-of select="@rdf:resource"/></a><xsl:text>&gt;</xsl:text></xsl:when>
    <xsl:when test="text()"><xsl:apply-templates select="text()"/></xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()">
  <xsl:text>'</xsl:text><xsl:value-of select="."/><xsl:text>'</xsl:text>
</xsl:template>

<xsl:template match="rdf:first">
  <xsl:choose>
    <xsl:when test="@rdf:resource"><xsl:text>&lt;_@</xsl:text><a href="{@rdf:resource}"><xsl:value-of select="@rdf:resource"/></a><xsl:text>&gt;</xsl:text></xsl:when>
    <xsl:otherwise><xsl:apply-templates select="*"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:rest">
  <xsl:choose>
    <xsl:when test="@rdf:resource and (@rdf:resource = rdf:nil)"/>
    <xsl:otherwise>
      <xsl:text>,</xsl:text>
      <xsl:apply-templates select="*"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

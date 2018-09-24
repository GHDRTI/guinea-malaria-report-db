<?xml version = "1.0" encoding = "UTF-8"?>
<!-- xsl stylesheet declaration with xsl namespace: 
Namespace tells the xlst processor about which 
element is to be processed and which is used for output purpose only 
--> 
<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
xmlns:dxf="http://dhis2.org/schema/dxf/2.0">  

<xsl:variable name="data" select="document('orgUnits.xml')/orgUnits/orgUnit"/>

<!-- xsl template declaration:  
template tells the xlst processor about the section of xml 
document which is to be formatted. It takes an XPath expression. 
In our case, it is matching document root element and will 
tell processor to process the entire document with this template. 
--> 
<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dxf:dataValueSet">
	<dataValueSet>
		<xsl:attribute name="dataSet">
			<xsl:value-of select="@dataSet"/>	
		</xsl:attribute>
		<xsl:attribute name="completeDate">
			<xsl:value-of select="@completeDate"/>	
		</xsl:attribute>
		<xsl:attribute name="period">
			<xsl:value-of select="@period"/>	
		</xsl:attribute>
		<xsl:attribute name="orgUnit">
			<!-- Do look up here -->
			<xsl:value-of select="$data[@key = @orgUnit]/@value"/>	
		</xsl:attribute>
		<xsl:apply-templates/>
	</dataValueSet>
</xsl:template>

<xsl:template match="dxf:dataValue">
  <dataValue>
  <xsl:attribute name="dataElement">
		<xsl:value-of select="@dataElement"/>	
	</xsl:attribute>
	<xsl:attribute name="period">
		<xsl:value-of select="@period"/>	
	</xsl:attribute>
	<xsl:attribute name="orgUnit">
		<xsl:value-of select="@orgUnit"/>	
	</xsl:attribute>
	<xsl:attribute name="categoryOptionCombo">
		<xsl:value-of select="@categoryOptionCombo"/>	
	</xsl:attribute>
	<xsl:attribute name="attributeOptionCombo">
		<xsl:value-of select="@attributeOptionCombo"/>	
	</xsl:attribute>
	<xsl:attribute name="value">
		<xsl:value-of select="@value"/>	
	</xsl:attribute>
	<xsl:attribute name="lastUpdated">
		<xsl:value-of select="@lastUpdated"/>	
	</xsl:attribute>
	<xsl:attribute name="followUp">
		<xsl:value-of select="@followUp"/>	
	</xsl:attribute>
 </dataValue>
</xsl:template>

</xsl:stylesheet>
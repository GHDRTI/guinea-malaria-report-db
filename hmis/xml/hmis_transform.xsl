<?xml version = "1.0" encoding = "UTF-8"?>
<!-- xsl stylesheet declaration with xsl namespace: 
Namespace tells the xlst processor about which 
element is to be processed and which is used for output purpose only 
--> 
<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
xmlns:dxf="http://dhis2.org/schema/dxf/2.0">  

<!-- Load up the lookup tables: -->
<xsl:variable name="orgUnits" select="document('orgUnits.xml')/orgUnits/orgUnit"/>


<!-- xsl template declaration:  
template tells the xlst processor about the section of xml 
document which is to be formatted. It takes an XPath expression. 
In our case, it is matching document root element and will 
tell processor to process the entire document with this template. 
--> 
<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*/text()[not(normalize-space())]" />

<xsl:template match="dxf:dataValueSet">
	<dataValueSet>
		<!-- when getting a datavalueSet with an orgUnitGroup (rather than the orgUnit), the dataValueSet doens't have any attributes. such as orgunit, completeDate, period, etc-->
		<xsl:apply-templates/>
	</dataValueSet>
</xsl:template>

<xsl:template match="dxf:dataValue">
  <xsl:variable name="currentDataElement" select="@dataElement"/>
  <xsl:variable name="currentCategoryOptionCombo" select="@categoryOptionCombo"/>
  <xsl:variable name="currentOrgUnit" select="@orgUnit"/>

  <!-- only include data elements and org units that are in the mapping file -->
  <xsl:if test="$dataElements[@hmisUID = $currentDataElement] and $orgUnits[@hmisUID = $currentOrgUnit]" >
  <dataValue>
  <xsl:attribute name="dataElement">
  	    <xsl:value-of select="$dataElements[@hmisUID = $currentDataElement]/@projectUID"/>
	</xsl:attribute>
	<xsl:attribute name="period">
		<xsl:value-of select="@period"/>	
	</xsl:attribute>
	<xsl:attribute name="orgUnit">
		<xsl:value-of select="$orgUnits[@hmisUID = $currentOrgUnit]/@projectUID"/>	
	</xsl:attribute>
	<xsl:attribute name="categoryOptionCombo">
		<!-- Look up the project category combo option -->
		 <xsl:value-of select="$dataElements[@hmisUID = $currentDataElement and @hmisCategoryOptionCombo = $currentCategoryOptionCombo]/@projectCategoryOptionCombo"/>
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
 </xsl:if>
</xsl:template>

</xsl:stylesheet>
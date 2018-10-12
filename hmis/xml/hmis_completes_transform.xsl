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
<xsl:variable name="dataElements" select="document('dataElements.xml')/dataElements/dataElement"/>

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

<xsl:template match="dxf:completeDataSetRegistrations">
	<completeDataSetRegistrations>
		<!-- when getting a datavalueSet with an orgUnitGroup (rather than the orgUnit), the dataValueSet doens't have any attributes. such as orgunit, completeDate, period, etc-->
		<xsl:apply-templates/>
	</completeDataSetRegistrations>
</xsl:template>

<xsl:template match="dxf:completeDataSetRegistration">
  <xsl:variable name="currentOrgUnit" select="@organisationUnit"/>

  <!-- only include data elements and org units that are in the mapping file -->
  
  <xsl:if test="$orgUnits[@hmisUID = $currentOrgUnit]" >
  <completeDataSetRegistration>
  	<xsl:attribute name="attributeOptionCombo">
		<xsl:value-of select="@attributeOptionCombo"/>	
	</xsl:attribute>
	<!-- in case you are wondering, this is the uid of the dataset in 
	the destination/stop palu system-->
	<xsl:attribute name="dataSet">k2ednnpKPCw</xsl:attribute>
	<xsl:attribute name="date">
		<xsl:value-of select="@date"/>	
	</xsl:attribute>
	<xsl:attribute name="organisationUnit">
		<xsl:value-of select="$orgUnits[@hmisUID = $currentOrgUnit]/@projectUID"/>	
	</xsl:attribute>
	<xsl:attribute name="period">
		<xsl:value-of select="@period"/>	
	</xsl:attribute>
 </completeDataSetRegistration>

 </xsl:if>
</xsl:template>

</xsl:stylesheet>
<?xml version = "1.0" encoding = "UTF-8"?>
<!-- xsl stylesheet declaration with xsl namespace: 
Namespace tells the xlst processor about which 
element is to be processed and which is used for output purpose only 
-->
<xsl:stylesheet version="1.0" xmlns:dxf="http://dhis2.org/schema/dxf/2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	<xsl:template match="*/text()[not(normalize-space())]"/>
	<xsl:template match="dxf:dataValueSet">
		<completeDataSetRegistrations>
			<!-- when getting a datavalueSet with an orgUnitGroup (rather than the orgUnit), the dataValueSet doens't have any attributes. such as orgunit, completeDate, period, etc-->
			<xsl:for-each-group group-by="@orgUnit" select="dxf:dataValue">
				<xsl:variable name="currentOrgUnit" select="current-grouping-key()"/>
				<!-- Only sync org units that are in the -->
				<xsl:if test="$orgUnits[@hmisUID = $currentOrgUnit]">
					<completeDataSetRegistration>
						<xsl:attribute name="attributeOptionCombo">HllvX50cXC0</xsl:attribute>
						<xsl:attribute name="period">
							<xsl:value-of select="@period"/>
						</xsl:attribute>
						<xsl:attribute name="dataSet">
							<xsl:value-of select="$dataSet"/>
						</xsl:attribute>
						<xsl:attribute name="organisationUnit">
							<xsl:value-of select="$orgUnits[@hmisUID = $currentOrgUnit]/@projectUID"/>
						</xsl:attribute>
					</completeDataSetRegistration> 
				</xsl:if>
			</xsl:for-each-group>
			<xsl:apply-templates/>
		</completeDataSetRegistrations>
	</xsl:template>
</xsl:stylesheet>
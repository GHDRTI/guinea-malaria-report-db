<?xml version = "1.0" encoding = "UTF-8"?>

<!-- xsl stylesheet declaration with xsl namespace: 
Namespace tells the xlst processor about which 
element is to be processed and which is used for output purpose only 
--> 
<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
xmlns:dxf="http://dhis2.org/schema/dxf/2.0">  

<xsl:import href="hmis_transform_datavalues.xsl"/>

<xsl:variable name="dataElements" select="document('population_dataelements.xml')/dataElements/dataElement"/>

<!-- Set this to the dataset uid in the stop palu database--> 
<xsl:variable name="dataSet" select="'tyeB4A6tZS4'"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>


</xsl:stylesheet>
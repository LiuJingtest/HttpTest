<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" indent="yes" encoding="UTF-8"  />

<!-- Defined parameters (overrideable) -->
<xsl:param    name="showData" select="'y'"/>
<xsl:param    name="titleReport" select="'Load Test Results'"/>
<xsl:param    name="dateReport" select="'date not defined'"/>

<xsl:template match="testResults">
	<html>
		<head>
			<title><xsl:value-of select="$titleReport" /></title>
			<style type="text/css">
				body {
					font:normal 68% verdana,arial,helvetica;
					color:#000000;
				}
				table{
					table-layout:fixed;
				}
				table tr td, table tr th {
					font-size: 68%;
					word-break:break-all ;
					word-wrap:break-word;
				}
				table.details tr th{
				    color: #ffffff;
					font-weight: bold;
					text-align:center;
					background:#2674a6;
					word-break:break-all ;
				}
				table.details tr td{
					background:#eeeee0;
					word-break:break-all ;
				}
				h1 {
					margin: 0px 0px 5px; font: 165% verdana,arial,helvetica
				}
				h2 {
					margin-top: 1em; margin-bottom: 0.5em; font: bold 125% verdana,arial,helvetica
				}
				h3 {
					margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica
				}
				.Failure {
					font-weight:bold; color:red;
				}
				
	
				img
				{
				  border-width: 0px;
				}
				
				.expand_link
				{
				   position=absolute;
				   right: 0px;
				   width: 27px;
				   top: 1px;
				   height: 27px;
				}
				
				.page_details
				{
				   display: none;
				}
                                
                                .page_details_expanded
                                {
                                    display: block;
                                    display/* hide this definition from  IE5/6 */: table-row;
                                }


			</style>
			<script language="JavaScript"><![CDATA[
                           function expand(details_id)
			   {
			      
			      document.getElementById(details_id).className = "page_details_expanded";
			   }
			   
			   function collapse(details_id)
			   {
			      
			      document.getElementById(details_id).className = "page_details";
			   }
			   
			   function change(details_id)
			   {
			      if(document.getElementById(details_id+"_image").src.match("expand"))
			      {
			         document.getElementById(details_id+"_image").src = "collapse.png";
			         expand(details_id);
			      }
			      else
			      {
			         document.getElementById(details_id+"_image").src = "expand.png";
			         collapse(details_id);
			      } 
               }
				function decodeUTF8(str){
					return str.replace(/(\\u)(\w{4}|\w{2})/gi, function($0,$1,$2){
    					return String.fromCharCode(parseInt($2,16));
					});
				}

				console.log(decodeUTF8('\u5cb3\u9e93'));
				
			]]></script>
		</head>
		<body>
		
			<xsl:call-template name="pageHeader" />
			
			<xsl:call-template name="summary" />
			<hr size="1" width="95%" align="center" />
			
			<xsl:call-template name="pagelist" />
			<hr size="1" width="95%" align="center" />
			
			<xsl:call-template name="detail" />

		</body>
	</html>
</xsl:template>

<xsl:template name="pageHeader">
	<h1><xsl:value-of select="$titleReport" /></h1>
	<table width="100%">
		<tr>
			<td align="left">Date report: <xsl:value-of select="$dateReport" /></td>
			<td align="right"><a href="../htmlDebug/TestReport.html">单个接口测试报告 </a></td>
		</tr>
	</table>
	<hr size="1" />
</xsl:template>

<xsl:template name="summary">
	<h2>Summary</h2>
	<table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
		<tr valign="top">
			<th>Case</th>
			<th>Failures</th>
			<th>Success Rate</th>
			<th>Average Time</th>
			<th>Min Time</th>
			<th>Max Time</th>
		</tr>
		<tr valign="top">
			<xsl:variable name="allCount" select="count(/testResults/httpSample[@lb != '获取测试数据'])" />
			<xsl:variable name="allFailureCount" select="count(/testResults/*[attribute::s='false' and @lb != '获取测试数据'])" />
			<xsl:variable name="allSuccessCount" select="count(/testResults/*[attribute::s='true' and @lb != '获取测试数据'])" />
			<xsl:variable name="allSuccessPercent" select="$allSuccessCount div $allCount" />
			<xsl:variable name="allTotalTime" select="sum(/testResults/*/@t)" />
			<xsl:variable name="allAverageTime" select="$allTotalTime div $allCount" />
			<xsl:variable name="allMinTime">
				<xsl:call-template name="min">
					<xsl:with-param name="nodes" select="/testResults/*/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="allMaxTime">
				<xsl:call-template name="max">
					<xsl:with-param name="nodes" select="/testResults/*/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$allFailureCount &gt; 0">Failure</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<td align="center">
				<xsl:value-of select="$allCount" />
			</td>
			<td align="center">
				<xsl:value-of select="$allFailureCount" />
			</td>
			<td align="center">
				<xsl:call-template name="display-percent">
					<xsl:with-param name="value" select="$allSuccessPercent" />
				</xsl:call-template>
			</td>
			<td align="center">
				<xsl:call-template name="display-time">
					<xsl:with-param name="value" select="$allAverageTime" />
				</xsl:call-template>
			</td>
			<td align="center">
				<xsl:call-template name="display-time">
					<xsl:with-param name="value" select="$allMinTime" />
				</xsl:call-template>
			</td>
			<td align="center">
				<xsl:call-template name="display-time">
					<xsl:with-param name="value" select="$allMaxTime" />
				</xsl:call-template>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="pagelist">
	<h2>Interface</h2>
	<table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
		<tr valign="top">
			<th width="400px" >URL</th>
			<th>Case</th>
			<th>Failures</th>
			<th>Success Rate</th>
			<th>Average Time</th>
			<th>Min Time</th>
			<th>Max Time</th>
			<th width="40px"></th>
		</tr>
		<xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb) and @lb != '获取测试数据']">
			<xsl:variable name="label" select="@lb" />
			<xsl:variable name="count" select="count(../*[@lb = current()/@lb])" />
			<xsl:variable name="failureCount" select="count(../*[@lb = current()/@lb][attribute::s='false'])" />
			<xsl:variable name="successCount" select="count(../*[@lb = current()/@lb][attribute::s='true'])" />
			<xsl:variable name="successPercent" select="$successCount div $count" />
			<xsl:variable name="totalTime" select="sum(../*[@lb = current()/@lb]/@t)" />
			<xsl:variable name="averageTime" select="$totalTime div $count" />
			<xsl:variable name="minTime">
				<xsl:call-template name="min">
					<xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="maxTime">
				<xsl:call-template name="max">
					<xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
				</xsl:call-template>
			</xsl:variable>
			<tr valign="top">
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<td>
				<xsl:if test="$failureCount > 0">
				  <a><xsl:attribute name="href">#<xsl:value-of select="$label" /></xsl:attribute>
				  <xsl:value-of select="$label" />
				  </a>
				</xsl:if>
				<xsl:if test="0 >= $failureCount">
				  <xsl:value-of select="$label" />
				</xsl:if>
				</td>
				<td align="center">
					<xsl:value-of select="$count" />
				</td>
				<td align="center">
					<xsl:value-of select="$failureCount" />
				</td>
				<td align="center">
					<xsl:call-template name="display-percent">
						<xsl:with-param name="value" select="$successPercent" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$averageTime" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$minTime" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$maxTime" />
					</xsl:call-template>
				</td>
				<td align="center">
				   <a href="">
				      <xsl:attribute name="href"><xsl:text/>javascript:change('page_details_<xsl:value-of select="position()" />')</xsl:attribute>
				      <img src="expand.png" alt="expand/collapse"><xsl:attribute name="id"><xsl:text/>page_details_<xsl:value-of select="position()" />_image</xsl:attribute></img>				      
				   </a>
				</td>
			</tr>
			
                        <tr class="page_details">
                           <xsl:attribute name="id"><xsl:text/>page_details_<xsl:value-of select="position()" /></xsl:attribute>
                           <td colspan="8" bgcolor="#FF0000">
                              <div align="center">
			         <b>Details for Interface "<xsl:value-of select="$label" />"</b>
			         <table bordercolor="#000000" bgcolor="#2674A6" border="0"  cellpadding="1" cellspacing="1" width="95%">
			         <tr>
			            <th>Thread</th>
			            <th>Iteration</th>
			            <th>Time (milliseconds)</th>
			            <th>Bytes</th>
			            <th>Success</th>
			         </tr>
			         		         
			         <xsl:for-each select="../*[@lb = $label and @tn != $label]">			         			            
			            <tr>
			               <td><xsl:value-of select="@tn" /></td>
			               <td align="center"><xsl:value-of select="position()" /></td>
			               <td align="right"><xsl:value-of select="@t" /></td>
			               <!--  TODO allow for missing bytes field -->
			               <td align="right"><xsl:value-of select="@by" /></td>
			               <td align="center"><xsl:value-of select="@s" /></td>
			            </tr>
			         </xsl:for-each>
			         
			         </table>
			      </div>
                           </td>
                        </tr>
			
		</xsl:for-each>
	</table>
</xsl:template>

<xsl:template name="detail">
	<xsl:variable name="allFailureCount" select="count(/testResults/*[attribute::s='false'])" />

	<xsl:if test="$allFailureCount > 0">
		<h2>Failure Detail</h2>

		<xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb)]">

			<xsl:variable name="failureCount" select="count(../*[@lb = current()/@lb][attribute::s='false'])" />

			<xsl:if test="$failureCount > 0">
				<h3><xsl:value-of select="@lb" /><a><xsl:attribute name="name"><xsl:value-of select="@lb" /></xsl:attribute></a></h3>

				<table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="95%" style="word-break:break-all">
				<tr valign="top">
					<th width="80px">Response</th>
					<th width="200px">Failure Message</th>
					<xsl:if test="$showData = 'y'">
					   <th >Response Data</th>
					</xsl:if>
				</tr>
			
				<xsl:for-each select="/testResults/*[@lb = current()/@lb][attribute::s='false']">
					<tr>
						<td id='status' align="center"><xsl:value-of select="@rc | @rs" /> - <xsl:value-of select="@rm" /></td>
						<td align="center"><xsl:value-of select="assertionResult/failureMessage" /></td>
						<xsl:if test="$showData = 'y'">
							<td style="word-break:break-all" ><xsl:value-of select="responseData" /></td>
						</xsl:if>
					</tr>
				</xsl:for-each>
				
				</table>
			</xsl:if>

		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template name="min">
	<xsl:param name="nodes" select="/.." />
	<xsl:choose>
		<xsl:when test="not($nodes)">NaN</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$nodes">
				<xsl:sort data-type="number" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="number(.)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="max">
	<xsl:param name="nodes" select="/.." />
	<xsl:choose>
		<xsl:when test="not($nodes)">NaN</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$nodes">
				<xsl:sort data-type="number" order="descending" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="number(.)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="display-percent">
	<xsl:param name="value" />
	<xsl:value-of select="format-number($value,'0.00%')" />
</xsl:template>

<xsl:template name="display-time">
	<xsl:param name="value" />
	<xsl:value-of select="format-number($value,'0 ms')" />
</xsl:template>
</xsl:stylesheet>

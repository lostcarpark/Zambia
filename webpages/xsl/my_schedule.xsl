<?xml version="1.0" encoding="UTF-8" ?>
<!--
	my_schedule
	Created by Peter Olszowka on 2013-12-09.
	Copyright (c) 2013-2021 Peter Olszowka. All rights reserved.
-->
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="badgeid" select="''"/>
	<xsl:output encoding="UTF-8" indent="yes" method="html" />
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="doc/query[@queryName='sessions']/row">
				<xsl:apply-templates select="doc/query[@queryName='sessions']/row" />
			</xsl:when>
			<xsl:otherwise>
				<div class="alert alert-error">No schedule sessions found.</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="doc/query[@queryName='sessions']/row">
		<div class="mb-5">
			<h5 class="mb-0"><xsl:value-of select="@title" disable-output-escaping="yes"/></h5>
			<div>
				<b>
					<span><xsl:value-of select="@roomname" /></span>
					<xsl:text> &#8226; </xsl:text>
					<span><xsl:value-of select="@trackname" /></span>
					<xsl:text> &#8226; </xsl:text>
					<span><xsl:value-of select="@typename" /></span>
					<xsl:text> &#8226; </xsl:text>
					<span><xsl:value-of select="@starttime" /><xsl:text>&#8211;</xsl:text><xsl:value-of select="@endtime" /></span>
				</b>
			</div>
			<div class="my-2"><xsl:value-of select="@progguiddesc" disable-output-escaping="yes"/></div>
			<xsl:if test="@persppartinfo">
				<div class="my-2">
					<b>Prospective participant information:</b>
					<span><xsl:text> </xsl:text><xsl:value-of select="@persppartinfo" /></span>
				</div>
			</xsl:if>
			<xsl:if test="@notesforpart">
				<div class="my-2">
					<b>Notes for participants:</b>
					<span><xsl:text> </xsl:text><xsl:value-of select="@notesforpart" /></span>
				</div>
			</xsl:if>
			<xsl:variable name="sessionid" select="@sessionid" />
			<xsl:apply-templates select="/doc/query[@queryName='participants']/row[@sessionid = $sessionid]" />
		</div>
	</xsl:template>

	<xsl:template match="/doc/query[@queryName='participants']/row">
		<div class="row mb-2 align-items-baseline">
			<div class="col-lg-3">
				<xsl:if test="@moderator = '1'">
					<b><xsl:text>Mod: </xsl:text></b>
				</xsl:if>
				<span><xsl:value-of select="@pubsname" disable-output-escaping="yes"/></span>
				<xsl:if test="not(@pubsname = @badgename)">
					<span><xsl:text> (</xsl:text><xsl:value-of select="@badgename" disable-output-escaping="yes"/><xsl:text>)</xsl:text></span>
				</xsl:if>
				<xsl:text> </xsl:text>
			</div>
			<div class="col-lg-3">
				<xsl:choose>
					<xsl:when test="@badgeid = $badgeid">
						<div class="form-group">
							<xsl:element name="label">
								<xsl:attribute name="class"><xsl:text>sr-only</xsl:text></xsl:attribute>
								<xsl:attribute name="id"><xsl:text>select-pos-</xsl:text><xsl:value-of select="@participantonsessionid" /></xsl:attribute>
								<xsl:text>Confirm Your Involvement</xsl:text>
							</xsl:element>
							<xsl:element name="select">
								<xsl:attribute name="class"><xsl:text>form-control confirmation-select</xsl:text></xsl:attribute>
								<xsl:attribute name="name"><xsl:text>availability</xsl:text></xsl:attribute>
								<xsl:attribute name="data-sessionid"><xsl:value-of select="@sessionid" /></xsl:attribute>
								<xsl:attribute name="data-participantonsessionid"><xsl:value-of select="@participantonsessionid" /></xsl:attribute>
								<xsl:attribute name="id"><xsl:text>select-pos-</xsl:text><xsl:value-of select="@participantonsessionid" /></xsl:attribute>
								<option value="">Please confirm...</option>
								<option value="ACCEPTED">Yes, I'll be on the session</option>
								<option value="DECLINED">No, this doesn't work</option>
								<option value="MAYBE">Maybe</option>
							</xsl:element>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Unconfirmed</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="col-lg-3">
				<xsl:choose>
					<xsl:when test="@email != ''">
						<xsl:element name="a">
							<xsl:attribute name="href"><xsl:text>mailto:</xsl:text><xsl:value-of select="@email" /></xsl:attribute>
							<xsl:value-of select="@email" />
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<span>Email not available</span>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="col-lg-3">
				<xsl:value-of select="@comments" />
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>

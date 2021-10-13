<?php
// Copyright (c) 2018-2019 Peter Olszowka. All rights reserved. See copyright document for more details.
$report = [];
$report['name'] = 'Participant Photos';
$report['description'] = 'Show participants who have uploaded photos.';
$report['categories'] = array(
    'Participant Info Reports' => 700,
);
$report['columns'] = array(
    array("width" => "6em"),
    array("width" => "12em"),
    array("orderable" => true)
);
$report['queries'] = [];
$report['queries']['photos'] =
"SELECT P.badgeid, P.pubsname, CASE WHEN P.approvedphotofilename IS NULL THEN 'No Photo Approved' ELSE CONCAT('<img src=\"".PHOTO_PUBLIC_DIRECTORY."/', P.approvedphotofilename, '\" style=\"max-width:100px;\" />') END AS photo "
. <<<'EOD'
    FROM
             Participants P
    WHERE
        P.approvedphotofilename IS NOT NULL;
EOD;
$report['xsl'] =<<<'EOD'
<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" indent="yes" method="html" />
    <xsl:include href="xsl/reportInclude.xsl" />
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="doc/query[@queryName='photos']/row">
                <table id="reportTable" class="report">
                    <thead>
                        <tr style="height:2.6rem">
                            <th class="report">Badge Id</th>
                            <th class="report">Participant Name</th>
                            <th class="report">Photo</th>
                        </tr>
                    </thead>
                    <xsl:apply-templates select="doc/query[@queryName='photos']/row" />
                </table>
            </xsl:when>
            <xsl:otherwise>
                <div class="alert alert-danger">No results found.</div>
            </xsl:otherwise>                    
        </xsl:choose>
    </xsl:template>

    <xsl:template match="doc/query[@queryName='photos']/row">
        <tr>
            <td class="report"><xsl:call-template name="showBadgeid"><xsl:with-param name="badgeid" select="@badgeid"/></xsl:call-template></td>
            <td class="report"><xsl:value-of select="@pubsname" /></td>
            <td class="report"><xsl:value-of select="@photo" disable-output-escaping="yes" /></td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
EOD;

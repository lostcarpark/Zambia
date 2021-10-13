<?php
// Copyright (c) 2018-2019 Peter Olszowka. All rights reserved. See copyright document for more details.
$report = [];
$report['name'] = 'Participant Programme Item Suggestions';
$report['description'] = 'Show programme item ideas shggested through the participant survey.';
$report['categories'] = array(
    'Participant Info Reports' => 700,
);
$report['columns'] = array(
    array("width" => "6em"),
    array("width" => "12em"),
);
$report['queries'] = [];
$report['queries']['suggestions'] =<<<'EOD'
SELECT
        P.badgeid, P.pubsname, A.value, A.lastupdate
    FROM
             Participants P
        INNER JOIN ParticipantSurveyAnswers A ON P.badgeid = A.participantid
    WHERE
        A.questionid = 11
	AND A.value != ''
	AND A.value IS NOT NULL;
EOD;
$report['xsl'] =<<<'EOD'
<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" indent="yes" method="html" />
    <xsl:include href="xsl/reportInclude.xsl" />
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="doc/query[@queryName='suggestions']/row">
                <table id="reportTable" class="report">
                    <thead>
                        <tr style="height:2.6rem">
                            <th class="report">Badge Id</th>
                            <th class="report">Suggested By</th>
                            <th class="report">Programme Suggestions</th>
                            <th class="report">Last Updated</th>
                        </tr>
                    </thead>
                    <xsl:apply-templates select="doc/query[@queryName='suggestions']/row" />
                </table>
            </xsl:when>
            <xsl:otherwise>
                <div class="alert alert-danger">No results found.</div>
            </xsl:otherwise>                    
        </xsl:choose>
    </xsl:template>

    <xsl:template match="doc/query[@queryName='suggestions']/row">
        <tr>
            <td class="report"><xsl:call-template name="showBadgeid"><xsl:with-param name="badgeid" select="@badgeid"/></xsl:call-template></td>
            <td class="report"><xsl:value-of select="@pubsname" /></td>
            <td class="report"><xsl:value-of select="@value" disable-output-escaping="yes" /></td>
            <td class="report"><xsl:value-of select="@lastupdate" /></td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
EOD;

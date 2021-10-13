<?php
// Copyright (c) 2018-2019 Peter Olszowka. All rights reserved. See copyright document for more details.
$report = [];
$report['name'] = 'Participant Would Prefer Not To See';
$report['description'] = 'Show programme items participants would like excluded from programme.';
$report['categories'] = array(
    'Participant Info Reports' => 700,
);
$report['columns'] = array(
    array("width" => "6em"),
    array("width" => "12em"),
    array("orderable" => true)
);
$report['queries'] = [];
$report['queries']['prefernot'] =<<<'EOD'
SELECT
        P.badgeid, P.pubsname, A.value, A.lastupdate
    FROM
             Participants P
        INNER JOIN ParticipantSurveyAnswers A ON P.badgeid = A.participantid
    WHERE
        A.questionid = 19
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
            <xsl:when test="doc/query[@queryName='prefernot']/row">
                <table id="reportTable" class="report">
                    <thead>
                        <tr style="height:2.6rem">
                            <th class="report">Badge Id</th>
                            <th class="report">Suggested By</th>
                            <th class="report">Would Prefer Not To See</th>
                            <th class="report">Last Updated</th>
                        </tr>
                    </thead>
                    <xsl:apply-templates select="doc/query[@queryName='prefernot']/row" />
                </table>
            </xsl:when>
            <xsl:otherwise>
                <div class="alert alert-danger">No results found.</div>
            </xsl:otherwise>                    
        </xsl:choose>
    </xsl:template>

    <xsl:template match="doc/query[@queryName='prefernot']/row">
        <tr>
            <td class="report"><xsl:call-template name="showBadgeid"><xsl:with-param name="badgeid" select="@badgeid"/></xsl:call-template></td>
            <td class="report"><xsl:value-of select="@pubsname" /></td>
            <td class="report"><xsl:value-of select="@value" disable-output-escaping="yes" /></td>
            <td class="report"><xsl:value-of select="@lastupdate" /></td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
EOD;

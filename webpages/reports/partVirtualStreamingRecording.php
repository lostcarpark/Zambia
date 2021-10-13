<?php
// Copyright (c) 2018-2019 Peter Olszowka. All rights reserved. See copyright document for more details.
$report = [];
$report['name'] = 'Participant Virtual/Recording/Live Streaming';
$report['description'] = 'Show all participants who expressed a preference on virtual participation, recording and live streaming.';
$report['categories'] = array(
    'Participant Info Reports' => 700,
);
$report['columns'] = array(
    array("width" => "5em"),
    array("width" => "12em", "orderData" => 2),
    array("visible" => false),
    array("orderable" => false)
);
$report['queries'] = [];
$report['queries']['survey'] =<<<'EOD'
SELECT
        P.badgeid, 
        P.pubsname,
        A4.value AS virtual_participation,
        A11.value AS live_stream,
        A12.value AS recording,
        A13.value AS stream_comment,
        MAX(A.lastupdate) AS lastupdate
    FROM
        Participants P
        INNER JOIN ParticipantSurveyAnswers A ON P.badgeid = A.participantid
        LEFT JOIN ParticipantSurveyAnswers A4 ON P.badgeid = A4.participantid AND A4.questionid = 24
        LEFT JOIN ParticipantSurveyAnswers A11 ON P.badgeid = A11.participantid AND A11.questionid = 22
        LEFT JOIN ParticipantSurveyAnswers A12 ON P.badgeid = A12.participantid AND A12.questionid = 23
        LEFT JOIN ParticipantSurveyAnswers A13 ON P.badgeid = A13.participantid AND A13.questionid = 28
    GROUP BY
        P.badgeid;
EOD;
$report['xsl'] =<<<'EOD'
<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" indent="yes" method="html" />
    <xsl:include href="xsl/reportInclude.xsl" />
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="doc/query[@queryName='survey']/row">
                <table id="reportTable" class="report">
                    <thead>
                        <tr style="height:2.6rem">
                            <th class="report">Badge Id</th>
                            <th class="report">Participant Name</th>
                            <th class="report">Virtual</th>
                            <th class="report">Live Streaming?</th>
                            <th class="report">Recording?</th>
                            <th class="report">Streaming and Recording Comments</th>
                            <th class="report">Last Updated</th>
                        </tr>
                    </thead>
                    <xsl:apply-templates select="doc/query[@queryName='survey']/row" />
                </table>
            </xsl:when>
            <xsl:otherwise>
                <div class="alert alert-danger">No results found.</div>
            </xsl:otherwise>                    
        </xsl:choose>
    </xsl:template>

    <xsl:template match="doc/query[@queryName='survey']/row">
        <tr>
            <td class="report"><xsl:call-template name="showBadgeid"><xsl:with-param name="badgeid" select="@badgeid"/></xsl:call-template></td>
            <td class="report"><xsl:value-of select="@pubsname" /></td>
            <td class="report"><xsl:value-of select="@virtual_participation" /></td>
            <td class="report"><xsl:value-of select="@live_stream" /></td>
            <td class="report"><xsl:value-of select="@recording" /></td>
            <td class="report"><xsl:value-of select="@stream_comment" /></td>
            <td class="report"><xsl:value-of select="@lastupdate" /></td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
EOD;

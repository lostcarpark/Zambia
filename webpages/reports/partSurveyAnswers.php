<?php
// Copyright (c) 2018-2019 Peter Olszowka. All rights reserved. See copyright document for more details.
$report = [];
$report['name'] = 'Participant Survey Submissions';
$report['description'] = 'Show all participants who submitted survey answers. Note, this table can be a bit hard to read. See other reports for partial results.';
$report['categories'] = array(
    'Participant Info Reports' => 700,
);
$report['columns'] = array(
    array("width" => "6em"),
    array("width" => "12em", "orderData" => 2),
    array("width" => "24em"),
    array("width" => "24em"),
);
$report['queries'] = [];
$report['queries']['survey'] =<<<'EOD'
SELECT
        P.badgeid, 
        P.pubsname,
        A1.value AS prog_suggestion,
        A2.value AS prefer_not,
        A3.value AS talk_about,
        A4.value AS virtual_participation,
        A5.value AS people_with,
        A6.value AS not_talk_about,
        A7.value AS people_avoid,
        A8.value AS item_types,
        A9.value AS moderator,
        A10.value AS mod_experience,
        A11.value AS live_stream,
        A12.value AS recording,
        A13.value AS stream_comment,
        A14.value AS other_notes,
        MAX(A.lastupdate) AS lastupdate
    FROM
        Participants P
        INNER JOIN ParticipantSurveyAnswers A ON P.badgeid = A.participantid
        LEFT JOIN ParticipantSurveyAnswers A1 ON P.badgeid = A1.participantid AND A1.questionid = 11
        LEFT JOIN ParticipantSurveyAnswers A2 ON P.badgeid = A2.participantid AND A2.questionid = 19
        LEFT JOIN ParticipantSurveyAnswers A3 ON P.badgeid = A3.participantid AND A3.questionid = 16
        LEFT JOIN ParticipantSurveyAnswers A4 ON P.badgeid = A4.participantid AND A4.questionid = 24
        LEFT JOIN ParticipantSurveyAnswers A5 ON P.badgeid = A5.participantid AND A5.questionid = 13
        LEFT JOIN ParticipantSurveyAnswers A6 ON P.badgeid = A6.participantid AND A6.questionid = 17
        LEFT JOIN ParticipantSurveyAnswers A7 ON P.badgeid = A7.participantid AND A7.questionid = 12
        LEFT JOIN ParticipantSurveyAnswers A8 ON P.badgeid = A8.participantid AND A8.questionid = 18
        LEFT JOIN ParticipantSurveyAnswers A9 ON P.badgeid = A9.participantid AND A9.questionid = 20
        LEFT JOIN ParticipantSurveyAnswers A10 ON P.badgeid = A10.participantid AND A10.questionid = 21
        LEFT JOIN ParticipantSurveyAnswers A11 ON P.badgeid = A11.participantid AND A11.questionid = 22
        LEFT JOIN ParticipantSurveyAnswers A12 ON P.badgeid = A12.participantid AND A12.questionid = 23
        LEFT JOIN ParticipantSurveyAnswers A13 ON P.badgeid = A13.participantid AND A13.questionid = 28
        LEFT JOIN ParticipantSurveyAnswers A14 ON P.badgeid = A14.participantid AND A14.questionid = 29
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
                            <th class="report" style="width:12em">Programme Suggestions</th>
                            <th class="report" style="width:12em">Would prefer not to see</th>
                            <th class="report">Would like to talk about</th>
                            <th class="report">Virtual</th>
                            <th class="report">People would like to be with</th>
                            <th class="report">Don't want to talk about</th>
                            <th class="report">People to avoid</th>
                            <th class="report">Types of item</th>
                            <th class="report">Moderator?</th>
                            <th class="report">Moderator Experience</th>
                            <th class="report">Live Streaming?</th>
                            <th class="report">Recording?</th>
                            <th class="report">Streaming and Recording Comments</th>
                            <th class="report">Additional Information</th>
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
            <td class="report"><xsl:value-of select="@prog_suggestion" disable-output-escaping="yes" /></td>
            <td class="report"><xsl:value-of select="@prefer_not" /></td>
            <td class="report"><xsl:value-of select="@talk_about" disable-output-escaping="yes" /></td>
            <td class="report"><xsl:value-of select="@virtual_participation" /></td>
            <td class="report"><xsl:value-of select="@people_with" /></td>
            <td class="report"><xsl:value-of select="@not_talk_about" disable-output-escaping="yes" /></td>
            <td class="report"><xsl:value-of select="@people_avoid" /></td>
            <td class="report"><xsl:value-of select="@item_types" /></td>
            <td class="report"><xsl:value-of select="@moderator" /></td>
            <td class="report"><xsl:value-of select="@mod_experience" /></td>
            <td class="report"><xsl:value-of select="@live_stream" /></td>
            <td class="report"><xsl:value-of select="@recording" /></td>
            <td class="report"><xsl:value-of select="@stream_comment" /></td>
            <td class="report"><xsl:value-of select="@other_notes" disable-output-escaping="yes" /></td>
            <td class="report"><xsl:value-of select="@lastupdate" /></td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
EOD;

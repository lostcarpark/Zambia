<?php
// Copyright (c) 2018 Peter Olszowka. All rights reserved. See copyright document for more details.
$report = [];
$report['name'] = 'Program Participant Badge Labels';
$report['description'] = 'Print badge labels showing program schedule for all program participants.';
$report['categories'] = array(
    'Publication Reports' => 880,
);
$report['queries'] = [];
$report['queries']['participants'] =<<<'EOD'
SELECT
        P.badgeid, P.pubsname
    FROM
             Participants P
        JOIN CongoDump CD USING (badgeid)
    WHERE
        EXISTS (
            SELECT SCH.sessionid
                FROM 
                         Schedule SCH
                    JOIN ParticipantOnSession POS USING (sessionid)
                    JOIN Sessions S USING (sessionid)
                WHERE
                        POS.badgeid = P.badgeid
                    AND S.pubstatusid = 2 /* Published */
            )
    ORDER BY
         IF(INSTR(P.pubsname, CD.lastname) > 0, CD.lastname, SUBSTRING_INDEX(P.pubsname, ' ', -1)),
         CD.firstname;
EOD;
$report['queries']['sessions'] =<<<'EOD'
SELECT
        POS.badgeid, POS.moderator, POS.sessionid, R.roomname, S.title,
        DATE_FORMAT(ADDTIME('$ConStartDatim$',SCH.starttime),'%a %l:%i %p') AS starttime
    FROM
             ParticipantOnSession POS
        JOIN Schedule SCH USING (sessionid)
        JOIN Sessions S USING (sessionid)
        JOIN Rooms R USING (roomid)
    WHERE
        S.pubstatusid = 2 /* Published */
    ORDER BY
        POS.badgeid, POS.sessionid;
EOD;
/*
$report['queries']['sessions'] =<<<'EOD'
SELECT
        S.sessionid, S.title, S.progguiddesc, R.roomname, SCH.roomid, PS.pubstatusname,
        DATE_FORMAT(ADDTIME('$ConStartDatim$',SCH.starttime),'%a %l:%i %p') AS starttime,
        DATE_FORMAT(S.duration,'%i') AS durationmin, DATE_FORMAT(S.duration,'%k') AS durationhrs,
		T.trackname, KC.kidscatname
    FROM
             Sessions S
        JOIN Schedule SCH USING (sessionid)
        JOIN Rooms R USING (roomid)
        JOIN PubStatuses PS USING (pubstatusid)
        JOIN Tracks T USING (trackid)
		JOIN KidsCategories KC USING (kidscatid)
    ORDER BY
        SCH.starttime, R.roomname;
EOD;
*/
$report['xsl'] =<<<'EOD'
<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" indent="yes" method="html" />
    <xsl:include href="xsl/reportInclude.xsl" />
    <xsl:template match="/">
        <link rel="stylesheet" href="css/zambia_report_print.css" type="text/css" />        
        <xsl:choose>
            <xsl:when test="doc/query[@queryName='participants']/row">
                <div class="form">
                    <div class="form-element">
                        <label for="units">Units</label>
                        <select name="units" id="units">
                            <option value="cm">cm</option>
                            <option value="mm">mm</option>
                            <option value="in">inches</option>
                        </select>
                    </div>
                    <div class="form-element">
                        <label for="width">Width</label>
                        <input type="number" name="width" id="width" value="9" min="1" max="300" step="0.1"></input>
                    </div>
                    <div class="form-element">
                        <label for="height">Height</label>
                        <input type="number" name="height" id="height" value="5" min="1" max="300" step="0.1"></input>
                    </div>
                    <div class="form-element">
                        <label for="fontsize">Font size (pt)</label>
                        <input type="number" name="fontsize" id="fontsize" value="8" min="1" max="18" step="0.1"></input>
                    </div>
                    <div class="form-element">
                        <label for="badgenumbers">Badge numbers</label>
                        <input name="badgenumbers" id="badgenumbers"></input>
                    </div>
                </div>
                <div>
                    <xsl:apply-templates select="doc/query[@queryName='participants']/row" />
                </div>
                <script src="javascript/ReportBadgeStickers.js"></script>
            </xsl:when>
            <xsl:otherwise>
                <div class="alert alert-danger">No results found.</div>
            </xsl:otherwise>                    
        </xsl:choose>
    </xsl:template>

    <xsl:template match="doc/query[@queryName='participants']/row">
        <xsl:variable name="badgeid" select="@badgeid" />
        <div class="badge-sticker" id="{@badgeid}">
            <div class="participant">
                <span><xsl:value-of select="@badgeid" /></span>
                <xsl:text> </xsl:text>
                <span>
                    <xsl:call-template name="showPubsname">
                        <xsl:with-param name="badgeid" select = "@badgeid" />
                        <xsl:with-param name="pubsname" select = "@pubsname" />
                    </xsl:call-template>
                </span>
            </div>
            <div>
                <xsl:apply-templates select="/doc/query[@queryName='sessions']/row[@badgeid=$badgeid]" />
            </div>
        </div>
    </xsl:template>

    <xsl:template match="doc/query[@queryName='sessions']/row">
        <p class="program-item">
            <span class="report"><xsl:value-of select="@starttime" /></span>
            <xsl:text> : </xsl:text>
            <span class="report"><xsl:value-of select="@roomname" /></span>
            <xsl:text> </xsl:text>
            <span class="report"><xsl:value-of select="@title" /></span>
            <span class="report">
                <xsl:if test="@moderator='1'">
                    <xsl:text> MOD</xsl:text>
                </xsl:if>
            </span>
        </p>        
    </xsl:template>
</xsl:stylesheet>
EOD;

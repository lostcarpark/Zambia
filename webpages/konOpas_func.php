<?php
//	Copyright (c) 2015-2019 Peter Olszowka. All rights reserved. See copyright document for more details.
    require_once('db_functions.php');
	function retrieveKonOpasData() {
	  //Get the site URL 
    $url = 'https://zambia.octocon.com';

		$results = array();
		if (prepare_db_and_more() === false) {
			$results["message_error"] = "Unable to connect to database.<br />No further execution possible.";
			return $results;
			};
		$ConStartDatim = CON_START_DATIM;
		// first query: which people are on which sessions
		$query = <<<EOD
SELECT
		SCH.sessionid, P.badgeid, P.pubsname, POS.moderator
	FROM
			 Schedule SCH
		JOIN Sessions S USING (sessionid)
		JOIN ParticipantOnSession POS USING (sessionid)
		JOIN Participants P USING (badgeid)
	WHERE
		S.pubstatusid = 2 /* Public */
	ORDER BY
		SCH.sessionid,
		POS.moderator DESC,
		P.badgeid;
EOD;
		$result = mysqli_query_with_error_handling($query);
		$sessionHasParticipant = array();
		$participantOnSession = array();
		while($row = mysqli_fetch_assoc($result)) {
			$sessionHasParticipant[$row["sessionid"]][] = array("id" => $row["badgeid"], "name" => $row["pubsname"].($row["moderator"] == "1" ? " (moderator)" : ""));
			$participantOnSession[$row["badgeid"]][] = $row["sessionid"];
			}
		$query = <<<EOD
SELECT
		S.sessionid AS id, S.title, S.meetinglink, TR.trackname, TY.typename, R.roomname AS loc,
		DATE_FORMAT(duration, '%k') * 60 + DATE_FORMAT(duration, '%i') AS mins, S.progguiddesc AS `desc`, 
		DATE_FORMAT(ADDTIME('$ConStartDatim',SCH.starttime),'%Y-%m-%d') as date,
		DATE_FORMAT(ADDTIME('$ConStartDatim',SCH.starttime),'%H:%i') as time
	FROM
			 Schedule SCH
		JOIN Sessions S USING (sessionid)
		JOIN Tracks TR USING (trackid)
		JOIN Types TY USING (typeid)
		JOIN Rooms R USING (roomid)
	WHERE
		S.pubstatusid = 2 /* Public */
	ORDER BY
		S.sessionid;
EOD;
		$result = mysqli_query_with_error_handling($query);
		$program = array();
		while($row = mysqli_fetch_assoc($result)) {
			$programRow = array(
				"id" => $row["id"],
				"title" => $row["title"],
				"tags" => array("track:".$row["trackname"],"type:".$row["typename"]),
				"date" => $row["date"],
				"time" => $row["time"],
				"loc" => array($row["loc"]),
				"people" => $sessionHasParticipant[$row["id"]],
				"desc" => $row["desc"],
				"links" => [],
				);
			if (!empty($row["meetinglink"])) {
				$programRow["links"] = ["meeting" => $row["meetinglink"]];
			}
			$program[] = $programRow;
			}
		$query = <<<EOD
SELECT
		P.badgeid, P.pubsname, sortedpubsname, P.bio, P.approvedphotofilename, P.use_photo
	FROM
		Participants P
	WHERE
		P.badgeid IN (
			SELECT POS.badgeid FROM
					 ParticipantOnSession POS
				JOIN Sessions S USING (sessionid)
				JOIN Schedule SCH USING (sessionid)
				WHERE S.pubstatusid = 2 /* Public */
			)
EOD;
    $result = mysqli_query_with_error_handling($query);
		$people = [];
		while($row = mysqli_fetch_assoc($result)) {
			$peopleRow = [
				"id" => $row["badgeid"],
				"name" => array($row["pubsname"]),
				"sortname" => $row["sortedpubsname"],
				"prog" => $participantOnSession[$row["badgeid"]],
				"bio" => $row["bio"],
				"links" => []
			];
			//if (PARTICIPANT_PHOTOS)
			  if (!empty($row['approvedphotofilename'])) {
			    $peopleRow['links']['img'] = ROOT_URL . PHOTO_PUBLIC_DIRECTORY . '/' . $row['approvedphotofilename'];
			  }
//print_r($peopleRow);
			//}
			$people[] = $peopleRow;
		}
		//header('Content-type: application/json');
		$results["json"] = "var program = ".json_encode($program).";\n";
		$results["json"] .= "var people = ".json_encode($people).";\n";
		return $results;
	}
?>

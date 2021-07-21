<?php

/***
 * Support user updates on ConReg conreg_members table.
 */
 
class ConRegMember
{
  protected $connection;
  
  /**
   * Constructs a new Member object.
   */
  public function __construct()
  {
    $connection = new mysqli(CONREG_DBHOSTNAME, CONREG_DBUSERID, CONREG_DBPASSWORD, CONREG_DBDB);
  }

  /**
   * Get the ConReg member ID for badge ID.
   */
  protected function getMid($badgeId)
  {
    $sql = "SELECT mid FROM conreg_zambia WHERE badgeid=?";
    $stmt = $connection->prepare($sql);
    $stmt->bind_param('S', $badgeId);
    $result = $stmt->get_result();
    if ($result) {
      return ($result->fetch_field());
    }
  }
}

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
    $this->connection = new mysqli(CONREG_DBHOSTNAME, CONREG_DBUSERID, CONREG_DBPASSWORD, CONREG_DBDB);
  }

  /**
   * Get the ConReg member ID for badge ID.
   */
  public function getMid($badgeId)
  {
    $sql = "SELECT mid FROM conreg_zambia WHERE badgeid=?";
    $stmt = $this->connection->prepare($sql);
    $stmt->bind_param('s', $badgeId);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result) {
      return ($result->fetch_object()->mid);
    }
    return NULL;
  }
  
  public function updateMember($badgeId, $fields)
  {
    $mid = $this->getMid($badgeId);
    if (!empty($mid)) {
      $sql = "UPDATE conreg_members SET first_name=?, last_name=?, badge_name=?, phone=?, email=?, street=?, street2=?, city=?, county=?, postcode=? WHERE $mid=?";
      $stmt = $this->connection->prepare($sql);
      $stmt->bind_param('ssssssssssi', $fields['first_name'], $fields['last_name'], $fields['badge_name'], $fields['phone'], $fields['email'], $fields['street'], $fields['street2'], $fields['city'], $fields['county'], $fields['postcode'], $mid);
      return $stmt->execute();
    }
  }
}

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
}

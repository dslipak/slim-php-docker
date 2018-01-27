<?php

$dsn = "pgsql:host=db;port=5432;dbname=postgres";
$user = "postgres";
$password = "postgres";

try {
    $dbh = new PDO($dsn, $user, $password);
	$sql = "SELECT relname, n_tup_ins - n_tup_del as rowcount FROM pg_stat_all_tables";
    
    foreach ($dbh->query($sql) as $row) {
        print $row['relname'] . "\t";
        print $row['rowcount'] . "\t\n";
    }
} catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
}

?>
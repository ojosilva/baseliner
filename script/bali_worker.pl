package Baseliner::WorkerX;

use base 'TheSchwartz::Moosified::Worker';

sub work {
        my ($class, $job) = @_;
    
        # $job is an instance of TheSchwartz::Moosified::Job
        print "\n\nWORKING:\n\n".YAML::Dump( $job->arg );
        # do heavy things like resize photos, add 1 to 2 etc.
        $job->completed;
}


package main;

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

BEGIN {  $ENV{DBIC_TRACE} = 0 };

use Baseliner;
use YAML;

use TheSchwartz::Moosified;
my $client = TheSchwartz::Moosified->new( verbose => 1);
Baseliner->model('Bali')->storage->dbh_do(
	sub {
		my ($storage, $dbh) = @_;
		$client->databases([$dbh]) or die $!;  	
	} );

$client->insert('Baseliner::WorkerX', { args1 => 1212, args2 => 21212 } ) or die $!;
print "Inserted\n";
$client->can_do('Baseliner::WorkerX');
$client->work();

################################################# 

1;
    


__DATA__
CREATE TABLE IF NOT EXISTS funcmap (
        funcid         INTEGER PRIMARY KEY AUTO_INCREMENT,
        funcname       VARCHAR(255) NOT NULL,
        UNIQUE(funcname)
);

CREATE TABLE IF NOT EXISTS job (
        jobid           INTEGER PRIMARY KEY AUTO_INCREMENT,
        funcid          INTEGER UNSIGNED NOT NULL,
        arg             MEDIUMBLOB,
        uniqkey         VARCHAR(255) NULL,
        insert_time     INTEGER UNSIGNED,
        run_after       INTEGER UNSIGNED NOT NULL,
        grabbed_until   INTEGER UNSIGNED NOT NULL,
        priority        SMALLINT UNSIGNED,
        coalesce        VARCHAR(255),
        UNIQUE(funcid,uniqkey)
);

CREATE TABLE IF NOT EXISTS error (
        error_time      INTEGER UNSIGNED NOT NULL,
        jobid           INTEGER NOT NULL,
        message         VARCHAR(255) NOT NULL,
        funcid          INT UNSIGNED NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS exitstatus (
        jobid           INTEGER PRIMARY KEY NOT NULL,
        funcid          INT UNSIGNED NOT NULL DEFAULT 0,
        status          SMALLINT UNSIGNED,
        completion_time INTEGER UNSIGNED,
        delete_after    INTEGER UNSIGNED
);


use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

BEGIN {  $ENV{DBIC_TRACE} = 0 };

use Baseliner;

   


use YAML;
#BaselinerX::Dispatcher->ConfigSets
print YAML::Dump( {} );

for( Baseliner->model('Bali::BaliNamespace')->all ) {
	print "NAMESPACE: ",$_->namespace,",par:", $_->parent,"\n";
	for( $_->children ) {
		print "hijos: ", $_->namespace, "\n";
	}

}

use TheSchwartz::Moosified;
my $client = TheSchwartz::Moosified->new( verbose => 1);
Baseliner->model('Bali')->storage->dbh_do(
	sub {
		my ($storage, $dbh) = @_;
		$client->databases([$dbh]) or die $!;  	
	} );

$client->insert('Baseliner::Worker', { args1 => 1, args2 => 2 } ) or die $!;
print "Inserted\n";
$client->can_do('Baseliner::Worker');
use Baseliner::Worker;
$client->work();
 
#print "DIB:".YAML::Dump( Baseliner->model('Bali')->storage->dbh );
#use TheSchwartz::Moosified;
# my $client = TheSchwartz::Moosified->new();
# $client->databases([Baseliner->model('Bali::BaliNamespace')->dbh]);

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

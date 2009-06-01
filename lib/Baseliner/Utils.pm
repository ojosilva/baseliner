package Baseliner::Utils;

=head1 DESCRIPTION

Some utilities shared by different Baseliner modules and plugins.

=cut 

use Exporter::Tidy default => [ qw/_loc _log slashFwd slashBack slashSingle _unique _throw _say _now _nowstamp parse_date/ ];
	
use Locale::Maketext::Simple (Style => 'gettext');
use Carp;
use DateTime;
use strict;

BEGIN {
	loc_lang($Baseliner::locale);
}

## base standard utilities subs
sub slashFwd {
	(my $path = $_[0]) =~ s{\\}{/}g ;
	return $path;
}

sub slashBack {
	(my $path = $_[0]) =~ s{/}{\\}g ;
	return $path;
}

sub slashSingle {
	(my $path = $_[0]) =~ s{//}{/}g ;
	$path =~ s{\\\\}{\\}g ;
	return $path;	
}

sub _unique {
	keys %{{ map {$_=>1} @_ }};
}

sub _loc {
	loc( @_ );
}

sub _log {
	print STDERR ( @_, "\n" );
}

sub _throw {
	Carp::confess(@_);
}

sub _say {
	print @_,"\n" if( $Baseliner::DEBUG );
} 

sub _now {
    my $now = DateTime->now(time_zone=>'CET');
    $now=~s{T}{ }g;
    return $now;
}

sub _nowstamp {
    (my $t = _now )=~ s{\:|\/|\\}{}g;
    return $t;
}

use DateTime::Format::Natural;
sub parse_date {
    my ( $format, $date ) = @_;
    my $parser = DateTime::Format::Natural->new( format=>$format );
    return $parser->parse_datetime(string => $date);
}

# return an array with hashes of data from a resultset
sub rs_data {
	my $rs = shift;
	my @data;
	while( my $row = $rs->next ) {
		push @data, { $row->get_columns };
	}
	return @data;
}

1;

__END__

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008 The Authors of Baseliner.org. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut

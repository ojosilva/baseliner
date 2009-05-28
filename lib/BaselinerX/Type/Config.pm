package BaselinerX::Type::Config;
use Baseliner::Plug;
with 'Baseliner::Core::Registrable';

register_class 'config' => __PACKAGE__;

use Switch 'Perl6';

has name 	=> ( is=> 'rw', isa=> 'Str' );
has desc 	=> ( is=> 'rw', isa=> 'Str' );
has metadata => ( is=> 'rw', isa=> 'ArrayRef' );  ##TODO this shall be a Moose subtype someday, an array of ConfigColumn
has formfu 	=> ( is=> 'rw', isa=> 'ArrayRef', default=> sub { [] } );
has 'plugin' => (is=>'rw', isa=>'Str', default=>'');
has 'id' => (is=>'rw', isa=>'Str', default=>'');

# load config from the namespace tree
sub load_from_ns {
	my $self = shift;
}

# Setup the Config Infraestructure Globals
sub setup_inf {
	my $c=shift;
	
}

sub column_order {
	my $self=shift;
	my @cols = ();
	push @cols, $_->{id} for( @{$self->metadata} );
	return @cols;
}

use YAML;

=head2 factory

Creates a config data object, mixing param + table + default

	$config_data = $config->factory( $c, ns=>$ns, bl=>$bl, getopt=>1, data=>{ some_key => 'S' } );

1) Getopt if getopt=>1
2) data=>{ } hash value
3) config table
4) metadata field default

=cut
sub factory {
	my ($self, $c, %p ) = @_;
	$p{ns} ||= '/';
	$p{bl} ||= '*';
	my $data = $p{data} || {};
	for( @{$self->metadata} ) {
warn "KEY = " . $_->{id};		
		next if defined $data->{ $_->{id} }; 
		## load missing from table
		my $rs = $c->model('Baseliner::BaliConfig')->search({ ns=>$p{ns}, bl=>$p{bl}, key=>$self->key.'.'.$_->{id} }) or die $!;
		while( my $r = $rs->next ) {
			$data->{ $_->{id} } = $r->value;
		}
	}
	$data = $self->getopt( $data ) if $p{getopt};
	return $data;
}

sub store {
	my ($self, $c, %p ) = @_;
	my $data = $p{data};
	$p{ns} ||= '/';
	$p{bl} ||= '*';
	for( @{$self->metadata} ) {
		next unless defined $data->{ $_->{id} };
		my $rs = $c->model('Baseliner::BaliConfig')->search({ ns=>$p{ns}, bl=>$p{bl}, key=>$self->key.'.'.$_->{id} })
			or die $!;			
		while( my $r = $rs->next ) {
			$r->value( $data->{ $_->{id} } );
			$r->update;
		}
	}
	return 1;
}

sub grid_columns { 
	my $self=shift;
	my @cols;
    ## {header: "Modificado", width:80, dataIndex: 'modificado', sortable: true, hidden: true },
	for( @{$self->metadata || [] } ) {
        push @cols,
          {
            header    => $_->{label},
            width     => ( $_->{width} || 80 ),
            dataIndex => $_->{id},
            sortable  => ( $_->{sortable} || \1 ),
            hidden    => ( $_->{hidden} || \0 )
          }
	}
	return \@cols;
}

sub grid_fields { 
	my $self=shift;
	my @data;
	for( @{$self->metadata || [] } ) {
		push @data, { name=> $_->{id} };
	}
	return \@data;
}

# Returns the full key list generated from the config's metadata
sub get_keys {
	my $self=shift;
	my $config = $self->key;
	my @keys;
	push @keys, "$config.$_->{id}" for( @{$self->metadata} ); 
	return @keys;
}

sub rows {
	my ($self,%p) = @_;
	my $config_set = $self->key;
	## order_by is not effective in this query
	my $rs = Baseliner->model('Baseliner::BaliConfig')->search({ key=>{-in=> [ $self->get_keys ] } }, { order_by => [qw/ns/] });
	my $last_ns = '';
	my @rows=();
	my @packed_data=();
	my $data;
	while( my $r = $rs->next ) {
		if( $r->ns ne $last_ns ) {
			if( $data ) {
				$data->{packed_data} = join '|',@packed_data;
				@packed_data = ();
				push @rows, $data;
			}
			$last_ns = $r->ns;
			$data = {};
		}
		my $short = $self->short_from_key( $r->key );
		$data->{$short} = $r->value;
		push @packed_data, $r->value;
	}	
	push @rows, $data if( $data );
	## now order by
	if( $p{sort_field} ) {
		my %r;
		my $i = 0;
		for(@rows) {
			my $val = $_->{ $p{sort_field} };
			next if( $p{query} && ( $_->{packed_data} !~/$p{query}/ ) );
			$r{ $val . "-$i" } = $_;	
			$i++;
		}
		my @sorted = sort keys %r;
		@rows = map { $r{$_} } ( $p{dir} eq 'ASC' ? reverse @sorted : @sorted );
	}
	return @rows;
}

sub load_inf {
	my ($self,$c, $config_set) = @_;
	my $data = {};
	my $rs = $c->model('Baseliner::BaliConfig')->search({ ns=>'/', bl=>'*', key=>{-like=>"$config_set.%" } });
	while( my $r = $rs->next  ) {
		(my $var = $r->key) =~ s{^(.*)\.(.*?)$}{$2}g;
		$data->{$var} = $r->value;
	}	
	return $data;
}

# Loads key aliases straight into the stash for fast/lazy access 
sub load_stash {
	my $c = shift;
	my @config_list = ref $_[0] ? @{ $_[0] } : @_;
	for my $config_set ( @config_list ) {
		my $config = $c->registry->get( $config_set );
		## read config from the table
		my $rs = $c->model('Baseliner::BaliConfig')->search({ ns=>'/', bl=>'*', key=>{-like=>"$config_set.%" } });
		while( my $r = $rs->next  ) {
			(my $var = $r->key) =~ s{^(.*)\.(.*?)$}{$2}g;
			$c->stash->{$var} = $r->value;
		}
		## read config from the command-line arguments
		my $data = $config->getopt;
		for( keys %{ $data || {} } ) {
			$c->stash->{$_} = $data->{$_} if defined $data->{$_};
		}
		#print "====BaliConfig====\n" . YAML::Dump( );
	}
}

# get command-line options for a configset
sub getopt {
	my $self=shift;
	my $defaults = shift;
	use Getopt::Lucid qw( :all );
	my %to_lucid = ( 'bool'=> 'switch', 'num'=> 'counter') ; ## map config meta to Lucid types
	my @opts;
	no warnings;
	for( @{$self->metadata} ) {
		my %opt = ();
		$opt{name} = $_->{opt} || $_->{id};
		$opt{type} = defined $_->{opt_type} ? $_->{opt_type} : $to_lucid{$_->{type}} || 'parameter';
		for my $verb ( qw/default required needs anycase valid/ ) {
			$opt{$verb} = $_->{$verb} if( defined $_->{$verb} );
		}
		push @opts, bless(\%opt,'Getopt::Lucid::Spec');
	} ;
	use warnings;
	my $opt = Getopt::Lucid->getopt( \@opts );
	$opt->merge_defaults( $defaults ) if ref $defaults;
	return { $opt->options };
}

# creates a config object
sub config_store {
	my $self = shift;
	my $config_name = shift;
	my $config = $self->ConfigSets->{ $config_name };
	my %data = map { 
				my $opt = $_->{opt} || $_->{id};
				$opt => \$_->{value} 
			} @{$config->metadata};
	return \%data;
}

## config to formfu elements
sub formfu_elements {
	my ($self) = @_;
	unless( @{$self->formfu} ) {  
		my @elems=();  ## formfu elements
		my $pos = 0;
		foreach my $row ( @{$self->metadata} ) {
			my $key = $row->{id};
			my $e = {};
			given( uc( $row->{type} ) ) {
				when /TEXT/ {
					$e->{xtype} = 'textfield';
				}
				when /TEXTAREA/ {
					$e->{xtype} = 'textarea';
					$e->{attrs_xml} = {  wysiwyg => 1 };
				}
				when /BOOL/ {
					$e->{xtype} = 'Select';
					$e->{options} = [ ['1','True'], ['0','False'] ];
					$e->{default} = '1';
				}
			}
			$e->{name} = $row->{name} || $key;
			$e->{fieldLabel} = $row->{label} || $e->{name};
			for my $e_name ( keys %{ $row->{extjs} || {} } ) {  			
				$e->{$e_name} = $row->{extjs}->{$e_name};
			}
			use YAML; print STDERR "$key - ".Dump $e."\n";
			$elems[ defined $row->{pos} ? $row->{pos} : $pos++ ] = $e;
		}
		my @elems2 = grep { ref $_ } @elems;## get rid of empty refs
		push @elems2, {  type=> 'Submit', name=> 'Sb' };
		$self->formfu(\@elems2);  
	}		
	return $self->formfu;
}

1;

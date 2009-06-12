package BaselinerX::CA::HarvestForm;
use Baseliner::Plug;
use Baseliner::Utils;

# http://localhost:3000/scm/servlet/harweb.Form?CMD=GetInfo&ID=37&PACKAGE_ID=39&PROJECT_ID=50&PACKAGE_NAME=GBP.328.N-000009%20prueba

use YAML;
BEGIN { extends 'Catalyst::Controller' };

register 'config.harvest.form' => {
	metadata => [
		{  id=>'width' },
	]
};

# given a formobjid => first row hash
sub form_data : Private {
	my ($self,$c, $fid )=@_;
	my $form = $c->model('Harvest::Harform')->search({ formobjid => $fid })->first;
	my $table = $form->formtypeobjid->formtablename;
	# get current data
	$table =~ s/(_|^)(.)/\U$2/g;
	my $row = $c->model( 'Harvest::' . $table )->search({ formobjid=>$fid })->first;
	return $row->get_columns;
}

use XML::Smart;
sub parse_form_xml : Private {
	my ($self,$c)=@_;
	my $xml;
	my $id = $c->req->params->{ID} || $c->stash->{formobjid};
	my $cache_id = 'Harform-' . $id;
	my $xml_cache = $c->cache->get($cache_id);
	if( $xml_cache ) {
		$xml = new XML::Smart( $xml_cache );
	}
	else {
		my $rs = $c->model( 'Harvest::Harform' )->search({ formobjid=> $id });
		my $ft = $rs->first->formtypeobjid->formtypename;
		my $file = $c->path_to( 'root', 'harform', $ft . ".xml" )	;
		$xml = new XML::Smart( $file );
		$c->cache->set($cache_id, $xml->data);
	}
	return $xml;
}


=head2 xml_to_grid_columns

	# metadata
	$c->stash->{formobjid} = $fid;
	my ($fields, $cols ) = $c->forward( 'BaselinerX::CA::HarvestForm', 'xml_to_grid_columns' );
	# columns
    $c->stash->{columns} = js_dumper $cols;
	# fields 
    $c->stash->{fields} = js_dumper $fields;

=cut
sub xml_to_grid_columns : Private {
	my ($self,$c)=@_;
	my $xml = $c->forward( 'parse_form_xml' );
	my @meta;
	my @fields;
	my %kkey;
	for my $key ( $xml->{harvest_form}->order ) {
		my $f = $xml->{harvest_form}->{$key}[ $kkey{$key}++ ];
		next if "$f->{dbfield}" eq 'formname';
		next unless "$f->{label}" ;
		push @fields, {
			name => "$f->{dbfield}"
		};
		push @meta, 
          {
            header    => "$f->{label}",
            width     => ( $f->{width} || 80 ),
            dataIndex => "$f->{dbfield}",
            sortable  => ( "$f->{sortable}" || \1 ),
            hidden    => ( "$f->{hidden}" || \0 )
          };
	}
	return (\@fields, \@meta) ;
}

sub xml_to_extjs : Private {
	my ($self,$c)=@_;
	my $xml = $c->forward( 'parse_form_xml' );
	my @meta;
	my %ext_map = (  combobox=>'combo', 'date-field'=>'datefield', 'text-area'=>'textarea', 'text-field'=>'textfield' );
	my %kkey;
	# get current data
	( my $table = $xml->{harvest_form}->{dbtable} .'' )=~ s/(_|^)(.)/\U$2/g;
	my $row = $c->model( 'Harvest::' . $table )->search({ formobjid=>$c->req->params->{ID} })->first;
	# prepare form
	my $form = {};
	$form->{url} = '/scm/form_submit';
	$form->{frame} = \0;
	$form->{method} = 'post';
	push @meta, { xtype=>'hidden', name=>'formobjid', value=>$c->req->params->{ID} };
	for my $key (  $xml->{harvest_form}->order  ) {
		if( grep( /$key/, qw/combobox text-field date-field text-area/ ) ) {
			my $f = $xml->{harvest_form}->{$key}[ $kkey{$key}++ ];
			my $field = "$f->{dbfield}";
			next if $field eq 'formname';
			my $item = { };
			$item->{xtype} = $ext_map{$key};
			$item->{id} = "$f->{dbfield}";
			$item->{name} = "$f->{dbfield}";
			$item->{fieldLabel} = "$f->{label}";
			$item->{size} = "$f->{maxsize}" if( $key =~ /text-field/ );
			$item->{anchor} = "80%" if(  $key =~ /text-area/ );
			# assign current date to field
			if(  $key =~ /date-field/ ) {
				my $val = $row->get_column($field); ## avoid column deflation
                $val and $item->{value} = parse_date('dd/mm/yy', $val)->dmy('/');  ## dd/mm/yy => dd/mm/yyyy
				$item->{format} = 'd/m/Y';  ## tell extjs what format to use
			} else {
				$item->{value} = $row->$field();
			}
			# Combo Stuff
			if(  $key =~ /combobox/ ) {
				my $k = 0;
				my @entry;
				for(  $f->{entry}->('@') ) {
					push @entry, [ "id" . $k++ , "$_" ];
				}
				$item->{store} = \(  "new Ext.data.SimpleStore( " . js_dumper( { fields=>["id","text"], data=> [ @entry ] }) . ")" );
				$item->{displayField} = 'text';
				$item->{editable} = \0;
				$item->{forceSelection} = \1;
				$item->{triggerAction} = 'all';
				$item->{mode} = 'local';
			}
			push @meta, $item; 
		} else {
			my $value = $xml->{harvest_form}->{$key} . "";
			push @meta, { xtype=>'hidden', name=>$key, value=>$value  };
		}
	}
	$form->{items} = \@meta;
	#my $extform = js_dumper( $form ); 
	$c->stash->{form} = js_dumper( $form );
	return;
}

use JavaScript::Dumper;
sub form_meta : Path('/scm/servlet/harweb.Form') {
	my ($self,$c)=@_;
	$c->forward( 'xml_to_extjs' );
	$c->stash->{title} = $c->req->params->{PACKAGE_NAME} || 'Harvest Form';
	$c->stash->{template} = '/site/formpage.html';
	#$c->res->body( '<pre>' . $c->stash->{form} );
}

use DateTime::Format::DateParse;

sub form_submit : Path( '/scm/form_submit' ) {
	my ($self,$c)=@_;
	#my $table = $c->req->params->{db_table};
	#my $formobjid = $c->req->params->{formobjid};
 	#my $form = $c->model( 'Harvest::FormGbp' )->search({ formobjid=>$formobjid })->first;
	#warn Dump $form->formobjid;

	my $p = $c->req->params;
	(  my $table = $p->{dbtable} )=~ s/(_|^)(.)/\U$2/g;
	my $formobjid = $p->{formobjid};
 	my $form = $c->model( 'Harvest::' . $table )->search({ formobjid=>$formobjid })->first;
	delete $p->{$_} for( qw/dbtable formobjid formname id name numtabs/ );
    for(keys %{  $p  }) {
        if( $form->column_info($_)->{data_type} =~ m/date/i ) {
            $p->{$_} = parse_date( 'dd/mm/Y' , $p->{$_} )->ymd; ## y-m-d - to match NLS_DATE
        }
    }
	eval {
		#$c->model( 'Harvest' )->storage->dbh_do( sub { $_[1]->do( "alter session set nls_date_format = 'DD/MM/YYYY' "); });
		$form->update( $p );
	};
	if( $@ ) {
		warn $@;
		$c->res->body( "false" );
	} else {
		$c->res->body( "true" );
	}
}

## FormFu handling
use HTML::FormFu::ExtJS;
sub formfu_meta : Path('/scm/formfu/servlet/harweb.Form') {
	my ($self,$c)=@_;
	$c->forward( 'xml_to_formfu' );
    my $form = new HTML::FormFu::ExtJS( {
            action   => '/scm/form_submit',
            elements => $c->stash->{form},
        }
    );
	$c->stash->{form} = $form;
	$c->stash->{title} = $c->req->params->{PACKAGE_NAME} || 'Harvest Form';
	$c->stash->{template} = '/site/formpage.html';
}

## Render using FormFu
sub xml_to_formfu : Private {
	my ($self,$c)=@_;
	my $xml = $c->forward( 'parse_form_xml' );
	my %ret;
	my @fu_meta;
	my %fu_map = (  combobox=>'Select', 'date-field'=>'Date', 'text-area'=>'Textarea', 'text-field'=>'Text' );
	my %kkey;
	for my $key (  $xml->{harvest_form}->order  ) {
		if( grep( /$key/, qw/combobox text-field date-field text-area/ ) ) {
			my $f = $xml->{harvest_form}->{$key}[ $kkey{$key}++ ];
			# FormFu attrs
			my $fu = { };
			$fu->{type} = $fu_map{$key};
			$fu->{id} = "$f->{dbfield}";
			$fu->{name} = "$f->{dbfield}";
			$fu->{label} = "$f->{label}";
			$fu->{size} = "$f->{maxsize}" if( $key =~ /text-field/ );
			# ExtJS attributes
			$fu->{attrs} = {};
			$fu->{attrs}->{anchor} = "80%" if(  $key =~ /text-area/ );
			# Combo Stuff
			if(  $key =~ /combobox/ ) {
				my $k = 0;
				for(  $f->{entry}->('@') ) {
					push @{ $fu->{options} }, [ "id" . $k++ , "$_" ];
				}
			}
			push @fu_meta, $fu; 
		} else {
			$ret{$key} = $xml->{harvest_form}->{$key} . "";
		}
	}
	$c->stash->{form} = [ @fu_meta ];
	return; 
}


##########################################################################################3
##########################################################################################3
##########################################################################################3
##########################################################################################3
##########################################################################################3
##########################################################################################3
##########################################################################################3
##########################################################################################3
## Deprecated

sub form_table_metadata : Private  {
	my ($self,$c )=@_;
	my $rs = $c->model( 'Harvest::Harform' )->search({ formobjid=> $c->req->params->{ID} });
	my $ft = $rs->first->formtypeobjid;
	my $table = $ft->formtablename;
	my @meta;
	foreach(  $ft->harformtypedefs(undef, { order_by => 'attrid' }) ) {
		my $type = $_->columntype eq 'varchar' 
						? ( $_->columnsize eq '2000' ? 'Textarea' : 'Text' ) 
						: 'Date';
		push @meta, { type=> $type , label=>$_->label, name=> $_->columnname }; 
	}
	$c->stash->{data} = [ @meta ];
#		{
#			xtype => 'textfield',
#			fieldLabel => 'Comment',
#			name => 'comment',
#		}
#	];
	return;
}

sub form : Local {
	my ($self,$c)=@_;
	# create tab component
	$c->stash->{url} = '/comp/formpanel.mas';
	$c->stash->{title} = $c->req->params->{PACKAGE_NAME};
	$c->stash->{template} = 'comp/NewCompPage.mas';
}

sub show_form : Path('/oldscm/servlet/harweb.Form') {
	my ($self,$c)=@_;
	#$c->stash->{html} =  '<pre>' . Dump $c->req->params. '</pre>' ;
	$c->stash->{url} = '/scm/form_render';
	$c->stash->{title} = $c->req->params->{PACKAGE_NAME};
	$c->stash->{template} = 'comp/NewTabComp.mas';
}

use Data::Dumper;
sub form_xml_metadatax : Private  {
	my ($self,$c )=@_;
	my $rs = $c->model( 'Harvest::Harform' )->search({ formobjid=> $c->req->params->{ID} });
	my $ft = $rs->first->formtypeobjid->formtypename;

	my $file = $c->path_to( 'root', 'harform', "$ft.xml" )	;
	warn "FORMXML=$file";
	use XML::Simple;
	$file=~s/\\/\//g ;
	my $data = XMLin( $file, KeepRoot => 1,ForceArray => qw/harvest_form/ );
	warn Dumper $data;
	$c->stash->{data} = [  ];
}

1;

package BaselinerX::Type::Menu;
use Baseliner::Plug;
with 'Baseliner::Core::Registrable';

register_class 'menu' => __PACKAGE__;

has 'id'=> (is=>'rw', isa=>'Str', default=>'');
has 'name' => ( is=> 'rw', isa=> 'Str' );
has 'label' => ( is=> 'rw', isa=> 'Str' );
has 'url' => ( is=> 'rw', isa=> 'Str' );
has 'url_comp' => ( is=> 'rw', isa=> 'Str' );
has 'url_run' => ( is=> 'rw', isa=> 'Str' );
has 'title' => ( is=> 'rw', isa=> 'Str' );
has 'level' => ( is=> 'rw', isa=> 'Int' );
has 'handler' => ( is=> 'rw', isa=> 'Str' );

use JavaScript::Dumper;
sub ext_menu_json {
	my ($self)=@_;
	js_dumper($self->ext_menu);
}

sub ext_menu {
	my $self=shift;
	use YAML;
	my $ret={ xtype=> 'tbbutton', text=> $self->{label} };
	my @children;
	for( $self->get_children ) {
		push @children ,$_->ext_menu;
	}
	if( defined $self->{url} ) {
		$ret->{handler}=\"function(){ Baseliner.addNewTab('$self->{url}', '$self->{title}'); }";
	}
	elsif( defined $self->{url_run} ) {
		$ret->{handler}=\"function(){ Baseliner.runUrl('$self->{url_run}'); }";
	}
	elsif( defined $self->{url_comp} ) {
		$ret->{handler}=\"function(){  Baseliner.addNewTabComp('$self->{url_comp}', '$self->{title}'); }";
	}
	elsif( defined $self->{handler} ) {
		$ret->{handler}=\"$self->{handler}";
	}
	$ret->{menu} = \@children if(@children);
	return $ret;
}
1;

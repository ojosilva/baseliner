package BaselinerX::Type::Generic;
use Baseliner::Plug;
with 'Baseliner::Core::Registrable';

has 'config' => (is=>'rw', isa=>'Str', default=>'' );

1;
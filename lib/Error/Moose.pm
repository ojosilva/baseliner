package Error::Moose;
use base 'Error';

sub import {
    warn "IMP=" .join ',',@_;
}

1;

package Email::MIME::RFC2047::Encoder::WordEncoder;

use strict;

sub new {
    my $package = shift;
    my $self = { @_ };

    $self->{buffer} = '';
    
    return bless($self, $package);
}

sub finish {
    my $self = shift;

    if($self->{buffer} ne '') {
        $self->flush();
        $self->{buffer} = '';
    }
}

1;

